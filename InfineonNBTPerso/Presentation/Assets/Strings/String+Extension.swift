// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

/// An extension of the String type that defines the string constant used in application.
extension String {
    // MARK: - Application level constants

    /// Defines name of the application name.
    static let appName = "NBT Personalization"

    /// Defines sub title for application.
    static let subTitleForApp = "OPTIGA\u{2122}\u{00A0}Authenticate\u{00A0}NBT"

    /// Message to make sure NBT device is personalized.
    static let messageCheckAppletIsPersonalized =
        "Please make sure the OPTIGA™ Authenticate NBT is correctly personalized"

    /// The message for user to click on ``Retry`` button to check NFC device's use case
    /// capabilities.
    static let messageRetryAgain =
        "Sorry! Something went wrong,\n please click on the retry button" +
        " to check the device's capabilities again"

    /// The title for ``Retry``  button.
    static let buttonTitleRetry = "Retry"

    /// The title for ``Start personalization``  button.
    static let buttonTitlePersonalize = "Start personalization"

    /// Message to inform user that unable to load sample device certificate or key.
    static let errorMessageCertificateKeyLoading =
        "Unable to load sample device certificate or key"

    /// Message to retry again.
    static let messageRetry = ", Please try again"

    /// Message from iOS if NFC interface not ready.
    static let messageSystemResourceNotAvailable = "System resource unavailable"

    /// Message from iOS if NFC interface not ready.
    static let messageNfcNotReady = "NFC interface not ready"

    /// Message if multiple tags are detected.
    static let messageMultipleTagsDetected =
        "Multiple NFC tags detected. Please present only one tag at a time"

    /// The Empty string.
    /// - Note : There isn't a specific code point to unicode character code for the empty string
    /// (i.e., a string with zero characters).
    static let empty = ""

    /// Error message `Tag response error / no response` return by iOS in case of card is not able
    /// to respond to APDU command.
    static let errorMessageNoResponse = "Tag response error / no response"

    // MARK: - IFXComponents level constants

    /// The hint for the inactive state button.
    static let hintInactiveButton = "Inactive Button"

    /// The hint for the active state button.
    static let hintActiveButton = "Active Button"

    /// The hint for the button.
    static let buttonTitleDefault = "Button"

    // MARK: - NBT device use case capabilities screen level constants

    /// The message for user to tap the NBT device to the mobile phone to check NFC device use case
    /// capabilities.
    static let messageToTapNfcDeviceToCheckCapabilities =
        "Tap your iPhone to the OPTIGA™ Authenticate NBT to check its use case capabilities!"

    /// The message for user informing that the NBT device is already personalized for a use case.
    static let messageDeviceAlreadyPersonalized =
    "The OPTIGA™ Authenticate NBT is already personalized for a use case, please reset the device!"

    /// The message represents the available use case of the NBT device.
    static let messageAvailableInteractions = "Available interactions are indicated!"

    /// The menu title of the brand protection button.
    static let menuTitleBP = "Brand Protection"

    /// The menu title of the connection handover button.
    static let menuTitleCH = "Static conn. handover"

    /// The menu title of the pass-through button.
    static let menuTitlePT = "Pass-through"

    /// The menu title of the ADT button.
    static let menuTitleADT = "Async. data transfer"

    /// The menu title of the reset NBT device to delivery state button.
    static let menuTitleReset = "Reset to delivery state"

    /// The button title of the reset NBT device to delivery state button.
    static let buttonTitleReset = "Reset"

    // MARK: - Reset screen level constants

    /// The message tap NBT device to reset to default state.
    static let messageTapDeviceForReset =
        "Please tap your iPhone to the OPTIGA™ Authenticate NBT to reset it to its default state!" +
        " This may take a few seconds..."

    /// The message for user to informing that the resetting NBT device to default state is
    /// successful.
    static let messageResetSuccess =
        "Sample restored to default state, returning to main application!"

    /// The message for user to inform resetting NFC device to default state.
    static let messageResettingDevice = "Sample restoring to default state..."

    // MARK: - Passthrough screen level constants

    /// The message for user to inform user that NBT device has ben successfully personalized for
    /// the pass-through use case
    static let messagePTSuccessfullyPersonalized =
        "Sample successfully personalized for the host parameterization via pass-through" +
        " use case, returning to main application!"

    /// The message to inform the user that the NBT device is personalized for the pass-through use
    /// case.
    static let messagePTPersonalizing =
        "The device is being personalized ..."

    /// The message ask user to tap NBT device to personalized it for the pass-through use case.
    static let messageTapDeviceForPTPersonalize =
        "Please tap your iPhone to the OPTIGA™ Authenticate NBT to personalize it for the host" +
        " parameterization via pass-through use case!"

    // MARK: - ADT screen level constants

    /// The message for user to inform user that NBT device is personalized to ADT state.
    static let messageADTSuccessfullyPersonalized =
        "Sample successfully personalized for the host parameterization via asynchronous data" +
        " transfer use case, returning to main application!"

    /// The message for user to inform user that NBT device is personalizing to ADT state.
    static let messageATDPersonalizing =
        "The device is being personalized ..."

    /// The message ask user to tap NBT device to personalized it for the ADT use case.
    static let messageTapDeviceForADTPersonalize =
        "Please tap your iPhone to the OPTIGA™ Authenticate NBT to personalize it for the host" +
        " parameterization via asynchronous data transfer use case!"

    // MARK: - CH screen level constants

    /// The message for user to inform user that NBT device is personalized to connection handover
    /// state is successfully.
    static let messageCHSuccessfullyPersonalized =
        "Sample successfully personalized for the static connection handover use case, returning" +
        " to main application!"

    /// The message for user to inform user that NBT device is personalizing to CH state.
    static let messageCHPersonalizing =
        "The device is being personalized ..."

    /// The message ask user to enter BLE mack address to user.
    static let messageEnterBluetoothMacAddress =
        "Please enter the desired Bluetooth address for the static connection handover use case!"

    /// The message ask user to tap NBT device to personalized it for the static connection handover
    /// use case.
    static let messageTapDeviceForCHPersonalize =
        "Please tap your iPhone to the OPTIGA™ Authenticate NBT to personalize it for the static" +
        " connection handover use case!"

    /// The message represents hint to user for enter mac address of BLE device.
    static let lableBLEMacEditText = "Enter Bluetooth MAC:"

    /// The hint for the BLE address ``EditTextView``.
    static let hintDefaultBELMacAddress = "e.g. \"AABBCCDDEEFF\""

    // MARK: - BP screen level constants

    /// The message ask user to enter COTT server link to user.
    static let messageEnterCOTT =
        "Enter a COTT server address and tap your iPhone to the OPTIGA™ Authenticate NBT to" +
        " personalize it for the brand protection use case!"

    /// The message for user to inform user that NBT device is personalized to BP state
    static let messageBPPersonalized =
        "Sample successfully personalized for the brand protection use case, returning to" +
        " main application!"

    /// The message for user to inform user that NBT device is personalizing to BP state.
    static let messageBPPersonalizing =
        "The device is being personalized ..."

    /// The message ask user to tap NBT device to personalized it for the BP use case.
    static let MessageTapDeviceForBPPersonalize =
        "Please tap your iPhone to the OPTIGA™ Authenticate NBT to personalize it for the brand" +
        " protection use case!"

    /// The message represents the COTT server EditTextView title  .
    static let lableCottServerEditText = "Enter verification server for COTT:"

    /// The message represents the default COTT server link.
    static let defaultCottLink = "optiga-nbt-cott-service.infineon.com"
}
