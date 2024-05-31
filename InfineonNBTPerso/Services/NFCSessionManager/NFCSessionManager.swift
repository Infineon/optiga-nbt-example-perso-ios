// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import CoreNFC
import Foundation

import InfineonApdu
import InfineonApduNbt
import InfineonChanneliOSNfc
import InfineonConsoleLogger
import InfineonNdef

/// The ``NFCSessionManager`` class serves as a manager for NFC tag reader sessions. It inherits
/// from ``NSObject`` and adopts the ``NFCTagReaderSessionDelegate`` protocol, allowing it to
/// handle NFC tag reader session events. Additionally, it conforms to the ``ObservableObject``
/// protocol, enabling it to be observed for changes in its properties.
///
/// Usage:
/// - The ``NFCSessionManager`` class should be instantiated to perform NFC operations.
/// - It handles NFC tag reader sessions and delegates using the ``NFCTagReaderSessionDelegate``
/// protocol.
/// - It can be observed for changes using the ``ObservableObject`` protocol.
class NFCSessionManager: NSObject, NFCTagReaderSessionDelegate, ObservableObject {
    /// An optional property holder for the ``NBTUseCaseManager`` which provides API related to
    /// personalization for use case supported by NBT device.
    ///
    /// - Important: This property is `nil` when there is no active NFC tag reader session.
    ///
    /// - SeeAlso: ``NBTUseCaseManager``

    /// An optional holder for the ``NBTUseCaseManager`` which provides the function to handle use
    /// case personalizations operation supported by the NBT application.
    ///
    /// - Important: This property is `nil` when there is no active NFC tag reader session.
    ///
    /// - SeeAlso: ``NBTUseCaseManager``
    var nbtUseCaseManager: NBTUseCaseManager?

    /// An optional holder for the onSuccessCallBack operation, used to inform UI level that the NBT
    /// use case is personalized.
    var onSuccessCallBack: (() -> Void)?

    /// An optional property holds an instance of ``NFCTagReaderSession``. It is used to establish
    /// a connection with an NBT device and perform NFC operations with  NBT device.
    ///
    /// - Important: This property may be `nil` when there is no active NFC tag reader session.
    ///
    /// - SeeAlso: ``NFCTagReaderSession``
    var tagReaderSession: NFCTagReaderSession?

    /// A published property that represents the message related to ``NFCTagReaderSession``
    /// operations.
    ///
    /// - Remark: The ``message`` property is marked with the ``@Published`` property wrapper,
    /// allowing it to automatically publish changes to any subscribers. When the value of `message`
    /// changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``message`` is set to ``.empty``.
    ///
    /// - SeeAlso: ``NFCTagReaderSession`` and ``@Published``
    @Published var message: String = .empty

    /// A published property that represents possible states of an NFC reader session during NFC tag
    /// interaction.
    ///
    /// - Remark: The ``nfcReaderSessionState`` property is marked with the ``@Published`` property
    /// wrapper, allowing it to automatically publish changes to any subscribers. When the value of
    /// ``nfcReaderSessionState`` changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``nfcReaderSessionState`` is set to ``.initial``.
    @Published var nfcReaderSessionState: NFCReaderSessionState = .initial

    /// Method to set onSuccessCallBack listener, used to inform UI level that NBT use case is
    /// personalize completed successfully
    ///
    /// - Parameter onSuccessCallBack: onSuccessCallBack listener
    func set(onSuccessCallBack: @escaping () -> Void) {
        self.onSuccessCallBack = onSuccessCallBack
    }

    /// Method to update message property to store and update the message of the
    /// ``NFCTagReaderSession`` operations.
    ///
    /// - Note: Method executed on ``DispatchQueue.main.async`` to publish the changes to SwiftUI
    /// from non UI thread.
    ///
    /// - Parameter message: Descriptive text message related to ``NFCTagReaderSession`` operations.
    public func setMessage(_ message: String) {
        DispatchQueue.main.async {
            self.message = message
        }
    }

    /// Notifies the delegate that the NFC tag reader session has been invalidated with a error.
    ///
    /// - Parameters:
    ///   - session: The ``NFCTagReaderSession`` that has been invalidated.
    ///   - error: The error that caused the invalidation of the session.
    ///
    /// - Important: Implemented this method to handle the invalidation of the NFC tag reader
    /// session and perform necessary cleanup or error handling.
    func tagReaderSession(_: NFCTagReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.tagReaderSession = nil
            self.nfcReaderSessionState = .disconnected
        }
        if let nfcError = error as? NFCReaderError,
           nfcError.code == .readerSessionInvalidationErrorUserCanceled {
            // User canceled the session, no need to show an error message
            return
        }
        let errorMessage = error.localizedDescription.replacingOccurrences(
            of: String.messageSystemResourceNotAvailable,
            with: String.messageNfcNotReady
        )
        setMessage(errorMessage + .messageRetry)
    }

    /// Notifies the delegate that the NFC tag reader session is active. Called when the tag reader
    /// session becomes active and is ready to detect tags.
    ///
    /// - Parameter session: The session object that has become active.
    func tagReaderSessionDidBecomeActive(_: NFCTagReaderSession) {
        nfcReaderSessionState = .polling
    }

    /// Notifies the delegate that the NFC tag reader session detected NFC tags.
    ///
    /// - Parameter session: session The session that detected the tags.
    /// - Parameter tags: An array of NFC tags detected by the NFC reader session.
    /// - Note: Upon detecting tags, this function is responsible for performing operations such as
    /// instantiates the ``ADTUseCaseManager`` , ``NBTCommandSet``, connecting to the tag and
    /// selecting the NBT applet to initiate asynchronous data transfer (ADT) operations. It also
    /// call the `initiateNBTDeviceCommunication()` method to proceed with further asynchronous
    /// data transfer (ADT) operations.
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        Task {
            // Return if multiple tag detected
            guard let tag = tags.first, tags.count == 1 else {
                try invalidateSession(errorMessage: .messageMultipleTagsDetected)
                return
            }
            // Instantiates the ``APDUChannel`` with console logger.
            let apduChannel = ApduChannel(
                channel: NfcChannel(tag: tag, readerSession: session),
                logger: ConsoleLogger.getConsoleLogger()
            )

            do {
                // Instantiates the ``NbtCommandSet`` with APDU channel.
                let nbtCommandSet = try NbtCommandSet(channel: apduChannel)
                // Instantiates the ``NbtCommandSetPerso`` with APDU channel.
                let persoCommandSet = try NbtCommandSetPerso(channel: apduChannel)

                // Instantiates the ``NBTUseCaseManager`` with NBT command set.
                nbtUseCaseManager = NBTUseCaseManager(
                    nbtCommandSet: nbtCommandSet,
                    persoCommandSet: persoCommandSet
                )
                // Connect to NBT device
                _ = try await nbtUseCaseManager?.connect()
                DispatchQueue.main.async {
                    self.nfcReaderSessionState = .connected
                }
                // Select the applet on NBT device
                let response = try await nbtUseCaseManager?.selectApplication()
                // If APDU response not success, invalidate the session with an error message
                // related to applet personalization.
                guard let response = response, response.isSuccessSW() else {
                    try invalidateSession(errorMessage: .messageCheckAppletIsPersonalized)
                    try nbtUseCaseManager?.disconnect()
                    return
                }
                // Invoke the `initiateNBTDeviceCommunication()` method to proceed with further
                // personalization operations.
                try await initiateNBTDeviceCommunication()
            } catch let error as ApduError {
                self.tagReaderSession?.invalidate(errorMessage: error.localizedDescription)
                DispatchQueue.main.async {
                    self.message = error.localizedDescription
                    self.nfcReaderSessionState = .disconnected
                }
            } catch let error as NdefError {
                self.tagReaderSession?.invalidate(errorMessage: error.localizedDescription)
                DispatchQueue.main.async {
                    self.message = error.localizedDescription
                    self.nfcReaderSessionState = .disconnected
                }
            } catch let error as CertificateError {
                self.tagReaderSession?.invalidate(errorMessage: error.localizedDescription)
                DispatchQueue.main.async {
                    self.message = error.localizedDescription
                    self.nfcReaderSessionState = .disconnected
                }
            } catch {
                self.tagReaderSession?.invalidate(errorMessage: error.localizedDescription)
                DispatchQueue.main.async {
                    self.message = error.localizedDescription
                    self.nfcReaderSessionState = .disconnected
                }
            }
        }
    }

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NBT device is detected, connected, and the
    /// NBT applet is selected to perform asynchronous data transfer (ADT) operations.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    /// - Throws: ``NdefError`` if there is any NDEF error
    ///
    /// - Note: Subclasses should override this method to implement specific use case operations.
    func startNFCTagReaderSession(withAlertMessage: String) {
        if NFCNDEFReaderSession.readingAvailable {
            tagReaderSession = NFCTagReaderSession(
                pollingOption: NFCTagReaderSession.PollingOption.iso14443,
                delegate: self
            )
            message = withAlertMessage
            tagReaderSession?.alertMessage = withAlertMessage
            setMessage(withAlertMessage)
            tagReaderSession?.begin()
        }
    }

    /// Async method to handle the tag presented event and start communication with the tag
    ///
    /// - Note: Method need to implement in subclass
    ///
    /// - Throws Error if any APDU communication fails with NBT device.
    dynamic func initiateNBTDeviceCommunication() async throws {}

    /// Method responsible for invalidate NFC reader session to end communication form the tag with
    /// error message.
    ///
    /// - Parameter errorMessage: Descriptive text message that is displayed on the alert action
    /// sheet once tag scanning has invalidated.
    func invalidateSession(errorMessage: String) throws {
        try nbtUseCaseManager?.disconnect()
        DispatchQueue.main.async {
            self.message = errorMessage
            self.nfcReaderSessionState = .disconnected
            self.tagReaderSession?.invalidate(errorMessage: self.message)
        }
    }
}
