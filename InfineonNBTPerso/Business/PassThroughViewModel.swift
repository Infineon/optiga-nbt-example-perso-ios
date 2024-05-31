// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApduNbt

/// The ``PassThroughViewModel`` class serves as a ViewModel providing the logic for personalization
/// operations related to NBT device for pass through (PT) use case. It conforms to the
/// ``NFCSessionManager`` to effectively manage NFC reader sessions for the purpose of NBT
/// devices personalization for PT operations. It can be also observed for changes using the
/// ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class PassThroughViewModel: NFCSessionManager {
    /// A published property that represents the configuration status of a Pass Through (PT)
    /// personalization operation. It holds a boolean value indicating whether Pass Through (PT)
    /// personalization has been done or not.
    ///
    /// - Remark: The ``isPTStateConfigSuccess`` property is marked with the ``@Published``
    /// property  wrapper, allowing it to automatically publish changes to any subscribers. When
    /// the value of ``isPTStateConfigSuccess`` changes, the associated views are updated
    /// accordingly.
    ///
    /// - Note: The initial value of ``isPTStateConfigSuccess`` is set to `false` as status of  PT
    ///         personalization is not done yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published public var isPTStateConfigSuccess = false

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to Pass Through (PT) personalization operation.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    override func initiateNBTDeviceCommunication() async throws {
        // Update the user interface message as personalizing NBT device for PT operation.
        DispatchQueue.main.async {
            self.message = .messagePTPersonalizing
            self.tagReaderSession?.alertMessage = self.message
        }
        // Perform the PT personalization operations. If fails to perform the PT personalization
        // operations it throws the `AdpuError` or other Error
        try await nbtUseCaseManager?.configurePTUseCase()

        // Update the user interface message as configured NBT device for PT.
        DispatchQueue.main.async {
            self.message = .messagePTSuccessfullyPersonalized
            self.tagReaderSession?.alertMessage = self.message
            self.isPTStateConfigSuccess = true
        }
        // Disconnect the NBT device
        try nbtUseCaseManager?.disconnect()

        // If onSuccessCallback is not nil. call the OnSuccessCallBack method to inform to UI for
        // update as success
        if let onSuccess = onSuccessCallBack {
            onSuccess()
        }
    }

    /// Loads the default UI state for the  ``PassThroughView`` screen.
    ///
    /// This method is responsible for setting up the initial UI state for the `` PassThroughView``
    /// screen. It also
    ///   - It set PT configuration state to false.
    ///   - Update the message to user for tab NBT device.
    ///   - Start the NFC session for PT personalization of NBT device
    /// - Parameter onSuccessCallBack: A PT configuration callback closure that is called after
    /// successful PT configuration.
    public func loadDefaultUIState() {
        isPTStateConfigSuccess = false
        message = String.messageTapDeviceForPTPersonalize
        startNFCTagReaderSession(withAlertMessage: .messageTapDeviceForPTPersonalize)
    }
}
