// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import InfineonApduNbt
import SwiftUI

/// The ``ADTViewModel`` class serves as a ViewModel providing the logic for personalization
/// operations related to NBT device for Asynchronous Data Transfer (ADT) use case. It
/// conforms to the ``NFCSessionManager`` to effectively manage NFC reader sessions for the purpose
/// of NBT devices personalization for ADT operations. It can be also observed for changes
/// using the ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class ADTViewModel: NFCSessionManager {
    /// A published property that represents the configuration status of a Asynchronous Data
    /// Transfer (ADT)  personalization operation. It holds a boolean value indicating whether
    /// Asynchronous Data Transfer (ADT) personalization has been done or not.
    ///
    /// - Remark: The ``isADTStateConfigSuccess`` property is marked with the ``@Published``
    /// property  wrapper, allowing it to automatically publish changes to any subscribers. When
    /// the value of ``isADTStateConfigSuccess`` changes, the associated views are updated
    /// accordingly.
    ///
    /// - Note: The initial value of ``isADTStateConfigSuccess`` is set to `false` as status of  ADT
    ///         personalization is not done yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published public var isADTStateConfigSuccess = false

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to Asynchronous Data Transfer (ADT) personalization operation.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    override func initiateNBTDeviceCommunication() async throws {
        // Update the user interface message as personalizing NBT device for ADT operation.
        DispatchQueue.main.async {
            self.message = .messageATDPersonalizing
            self.tagReaderSession?.alertMessage = self.message
        }
        // Perform the ADT personalization operations. If fails to perform the ADT personalization
        // operations it throws the `AdpuError` or other Error
        try await nbtUseCaseManager?.configureAdtUseCase()

        // Update the user interface message as configured NBT device for ADT.
        DispatchQueue.main.async {
            self.message = .messageADTSuccessfullyPersonalized
            self.tagReaderSession?.alertMessage = self.message
            self.isADTStateConfigSuccess = true
        }
        // Disconnect the NBT device
        try nbtUseCaseManager?.disconnect()

        // If onSuccessCallback is not nil. call the OnSuccessCallBack method to inform to UI for
        // update as success
        if let onSuccess = onSuccessCallBack {
            onSuccess()
        }
    }

    /// Loads the default UI state for the  ``ADTView`` screen.
    ///
    /// This method is responsible for setting up the initial UI state for the `` ADTView`` screen.
    /// It also
    ///   - It set ADT configuration state to false.
    ///   - Update the message to user for tab NBT device.
    /// - Parameter onSuccessCallBack: A ADT configuration callback closure that is called after
    /// successful ADT configuration.
    public func loadDefaultUIState() {
        isADTStateConfigSuccess = false
        message = String.messageTapDeviceForADTPersonalize
        startNFCTagReaderSession(withAlertMessage: message)
    }
}
