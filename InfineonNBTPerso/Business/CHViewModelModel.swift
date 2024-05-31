// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApduNbt

/// The ``CHViewModelModel`` class serves as a ViewModel providing the logic for personalization
/// operations related to NBT device for connection handover (CH) use case. It conforms to the
/// ``NFCSessionManager`` to effectively manage NFC reader sessions for the purpose of  NBT
/// devices personalization for CH operations. It can be also observed for changes using the
/// ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class CHViewModelModel: NFCSessionManager {
    /// A published property that represents the configuration status of a Connection Handover (CH)
    /// personalization operation. It holds a boolean value indicating whether Connection Handover
    /// (CH) personalization has been done or not.
    ///
    /// - Remark: The ``isCHStateConfigSuccess`` property is marked with the ``@Published``
    /// property  wrapper, allowing it to automatically publish changes to any subscribers. When
    /// the value of ``isCHStateConfigSuccess`` changes, the associated views are updated
    /// accordingly.
    ///
    /// - Note: The initial value of ``isCHStateConfigSuccess`` is set to `false` as status of  CH
    ///         personalization is not done yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published public var isCHStateConfigSuccess = false

    /// Represents the bluetooth mac address text input entered by the user.
    /// A published property that represents the bluetooth mac address for CH  text input entered
    /// by the user.
    ///
    ///  - Remark: The ``macAddress`` property is marked with the ``@Published`` property wrapper,
    ///    allowing it to automatically publish changes to any subscribers. When the value of
    ///    ``macAddress`` changes,  the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``macAddress`` is set to `Empty` as no URL enter by user yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published public var macAddress = String.empty

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to perform  Connection Handover (CH) personalization operation.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    override func initiateNBTDeviceCommunication() async throws {
        // Update the user interface message as personalizing NBT device for CH operation.
        DispatchQueue.main.async {
            self.message = .messageCHPersonalizing
            self.tagReaderSession?.alertMessage = self.message
        }
        // Perform the CH personalization operations. If fails to perform the CH personalization
        // operations it throws the `AdpuError` or other Error
        try await nbtUseCaseManager?.configureCHUseCase(macAddress: macAddress)

        // Update the user interface message as configured NBT device for CH.
        DispatchQueue.main.async {
            self.message = .messageCHSuccessfullyPersonalized
            self.tagReaderSession?.alertMessage = self.message
            self.isCHStateConfigSuccess = true
        }
        // Disconnect the NBT device
        try nbtUseCaseManager?.disconnect()

        // If onSuccessCallback is not nil. call the OnSuccessCallBack method to inform to UI for
        // update as success
        if let onSuccess = onSuccessCallBack {
            onSuccess()
        }
    }

    /// Loads the default UI state for the ``ConnectionHandoverView`` screen.
    ///
    /// This method is responsible for setting up the initial UI state for the
    /// ``ConnectionHandoverView`` screen. It also
    ///   - Set the bluetooth mac address  as empty.
    ///   - It set CH configuration state to false.
    ///   - Update the message to user for enter bluetooth mac address
    ///
    /// - Parameter onSuccessCallBack: A CH configuration callback closure that is called after
    /// successful CH configuration.
    public func loadDefaultUIState() {
        macAddress = .empty
        isCHStateConfigSuccess = false
        message = String.messageEnterBluetoothMacAddress
    }
}
