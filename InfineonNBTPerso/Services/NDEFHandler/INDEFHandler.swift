// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

///  Protocol handler for NDEF file format
public protocol INDEFHandler {
    /// Creates the NDEF message for the brand protection use case, containing the COTT url and the
    /// certificate for the sample.
    ///
    /// - Parameters:
    ///  - url: COTT url
    ///  - cert: Certificate
    /// - Returns  The NDEF message as byte array
    /// - Throws: An ``NdefError`` and ``CertificateError`` in case issue with creating NDEF
    /// message.
    func createBrandProtectionNdefMessage(url: String, cert: Data) throws -> Data

    /// Creates the NDEF message for the connection handover use case, containing the bluetooth mac
    /// address (only supported by Infineon Lib)
    ///
    /// - Parameter deviceMac: MAC address of bluetooth device
    /// - Returns The NDEF message as byte array
    /// - Throws: An ``NdefError`` and ``CertificateError``  in case issue with creating NDEF
    /// message.
    func createConnectionHandoverNdefMessage(deviceMac: Data) throws -> Data
}
