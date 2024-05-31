// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

/// An enum that defines the possible states of an NFC tag.
enum NFCReaderSessionState {
    /// The tag is initial state. it means that card is not poll or detected yet
    case initial

    /// The tag is disconnected.
    case disconnected

    /// The tag is polling for other NFC tags.
    case polling

    /// The tag is connected to NFC tags.
    case connected
}
