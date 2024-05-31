// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// The ``ResetViewModel`` class serves as a ViewModel providing the logic for reset default state
/// operations related to NBT device for personalization use case. It conforms to the
/// ``NFCSessionManager`` to effectively manage NFC reader sessions for the  purpose of NBT
/// reset operations. It can be also observed for changes using the ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class ResetViewModel: NFCSessionManager {
    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to perform reset personalization operation.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    override func initiateNBTDeviceCommunication() async throws {
        // Update the user interface message as reseting NBT device to default state.
        DispatchQueue.main.async {
            self.message = .messageResettingDevice
            self.tagReaderSession!.alertMessage = self.message
        }
        // Perform the reset operations. If fails perform reset operations it throws the
        // `AdpuError` or other Error
        _ = try await nbtUseCaseManager!.resetNfcDeviceState()

        // Update the user interface message as configured NBT device to default state.
        DispatchQueue.main.async {
            self.message = .messageResetSuccess
            self.tagReaderSession!.alertMessage = self.message
        }

        // Disconnect the NBT device
        try nbtUseCaseManager!.disconnect()

        // If onSuccessCallback is not nil. call the OnSuccessCallBack method to inform to UI for
        // update as success
        if let onSuccess = onSuccessCallBack {
            onSuccess()
        }
    }

    /// Loads the default UI state for the ``ResetView`` screen.
    ///
    /// This method is responsible for setting up the initial UI state for the ``ResetView`` screen
    /// and start the NFC session for reset NBT device to default state
    public func loadDefaultUIState() {
        // Update the tap NBT device for reset message
        message = String.messageTapDeviceForReset
        // Start the NFC session for reset NBT device to default state
        startNFCTagReaderSession(withAlertMessage: message)
    }
}
