// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApduNbt
import InfineonUtils

/// The ``BPViewModelModel`` class serves as a ViewModel providing the logic for personalization
/// operations related to the NBT device for brand protection use case. It conforms to the
/// ``NFCSessionManager`` to effectively manage NFC reader sessions for the purpose of NBT
/// device personalization for brand protection operations. It can be also observed for changes
/// using the
/// ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class BPViewModelModel: NFCSessionManager {
    /// A published property that represents the configuration status of a brand protection (BP)
    /// personalization operation. It holds a boolean value indicating whether
    /// brand protection (BP) personalization has been done or not.
    ///
    /// - Remark: The ``isBPStateConfigSuccess`` property is marked with the ``@Published`` property
    /// wrapper, allowing it to automatically publish changes to any subscribers. When the value of
    /// ``isBPStateConfigSuccess`` changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``isBPStateConfigSuccess`` is set to `false` as status of  BP
    ///         personalization is not done yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published public var isBPStateConfigSuccess = false

    /// A published property that represents the URL for verification COTT server address text input
    /// entered by the user.
    ///
    ///  - Remark: The ``url`` property is marked with the ``@Published`` property wrapper, allowing
    /// it to automatically publish changes to any subscribers. When the value of ``url`` changes,
    /// the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``url`` is set to `Empty` as no URL enter by user yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published public var url = String.empty

    /// Represents the x509 certificate as binary data for encryption and decryption
    private var x509Certificate: Data?

    /// Represents the EC key for encryption and decryption
    private var ecKey: Data?

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to perform band protection (BP) personalization operation.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    override func initiateNBTDeviceCommunication() async throws {
        // Update the user interface message as personalizing NBT device for BP operation.
        DispatchQueue.main.async {
            self.message = .messageBPPersonalizing
            self.tagReaderSession?.alertMessage = self.message
        }

        // Validate the EC key and x509 Certificate is available. else throw the NSError
        guard let ecKey = ecKey, let cert = x509Certificate else {
            throw NSError(
                domain: "",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: String.errorMessageCertificateKeyLoading]
            )
        }

        // Perform the (BP) personalization operations. If fails to perform the BP personalization
        // operations it throws the `AdpuError` or other Error
        try await nbtUseCaseManager?.configureBPUseCase(ecKey: ecKey, url: url, cert: cert)

        // Update the user interface message as configured NBT device for (BP).
        DispatchQueue.main.async {
            self.message = .messageBPPersonalized
            self.tagReaderSession?.alertMessage = self.message
            self.isBPStateConfigSuccess = true
        }

        // Disconnect the NBT device
        try nbtUseCaseManager?.disconnect()

        // If onSuccessCallback is not nil. call the OnSuccessCallBack method to inform to UI for
        // update as success
        if let onSuccess = onSuccessCallBack {
            onSuccess()
        }
    }

    /// Retrieves a certificate from a file with the specified name and type, and parses it into a
    /// `Data` object.
    ///
    /// - Throws: If the resource file cannot be read or the certificate cannot be parsed, an error
    /// is thrown.
    private func readCertificate() throws {
        x509Certificate = try CertUtils.getCertificate(
            fromResource: Files.sampleDeviceCertificate,
            ofType: Files.sampleDeviceKeyFileType
        )
    }

    /// Retrieves a EC key from a file with the specified name and type, and parses it into a
    /// `Data`  object.
    ///
    /// - Throws: If the resource file cannot be read or the certificate cannot be parsed, an error
    /// is thrown.
    private func readECPrivateKey() throws {
        ecKey = try CertUtils.getECPrivateKey(
            fromResource: Files.sampleDeviceKey,
            ofType: Files.sampleDeviceKeyFileType
        )
    }

    /// Loads the default UI state for the ``BrandProtectionView`` screen.
    ///
    /// This method is responsible for setting up the initial UI state for the
    /// ``BrandProtectionView`` screen. It also
    ///   - Set the BP URL to default COTT server link
    ///   - It set BP configuration state to false.
    ///   - Update the message to user for enter COTT server URL.
    ///   - Reads and sets EC key and Certificate.
    /// - Parameter onSuccessCallBack: A BP configuration callback closure that is called after
    /// successful BP configuration.
    public func loadDefaultUIState(onSuccessCallBack: @escaping () -> Void) {
        set(onSuccessCallBack: onSuccessCallBack)
        url = .defaultCottLink
        isBPStateConfigSuccess = false
        message = String.messageEnterCOTT
        do {
            try readCertificate()
            try readECPrivateKey()
        } catch let error as CertificateError {
            message = error.localizedDescription
        } catch {
            message = error.localizedDescription
        }
    }
}
