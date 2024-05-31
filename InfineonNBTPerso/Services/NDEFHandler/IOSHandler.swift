// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import CoreNFC
import Foundation
import InfineonNdef

/// Handler using the default iOS CoreNFC library to handle the standardized NDEF file format, parse
/// and validate the certificate
public class IOSHandler: INDEFHandler {
    let emptyUrlErrorUserInfo = "URI cannot be empty"
    let invalidMacErrorUserInfo = "Bluetooth device address must be 6 bytes"

    /// The MB flag is a 1-bit field that when set indicates the start of an NDEF
    /// message
    public static let mbFlag: UInt8 = 0x80

    /// The ME flag is a 1-bit field that when set indicates the end of an NDEF
    /// message . Note, that in case of a chunked payload, the ME flag is set
    /// only in the terminating record chunk of that chunked payload.
    public static let meFlag: UInt8 = 0x40

    /// Parses the NDEF message for the brand protection use case, containing the COTT url and the
    /// certificate for the sample.
    ///
    /// - Parameters:
    ///  - url: COTT url
    ///  - cert: Certificate
    /// - Returns  The NDEF message as byte array
    /// - Throws: An ``NdefError`` and ``CertificateError`` in case issue with creating NDEF
    /// message.
    public func createBrandProtectionNdefMessage(url: String, cert: Data) throws -> Data {
        var uriIdentifier = ""
        if !url.contains("http://") {
            uriIdentifier = "http://"
        }
        if url.isEmpty {
            throw IOSNDEFError(description: emptyUrlErrorUserInfo)
        }
        let uriRecord = NFCNDEFPayload
            .wellKnownTypeURIPayload(url: URL(string: uriIdentifier + url)!)
        let extRecord = createInfineonBrandProtectionRecord(from: cert)

        let ndefMessage = NFCNDEFMessage(records: [uriRecord!, extRecord])

        let data = try encodeNdefMessage(ndefMessage: ndefMessage)
        return Data(data)
    }

    /// Parses the NDEF message for the connection handover use case, containing the bluetooth mac
    /// address (only supported by Infineon Lib)
    ///
    /// - Parameter deviceMac: MAC address of bluetooth device
    /// - Returns The NDEF message as byte array
    /// - Throws: An ``NdefError`` and ``CertificateError``  in case issue with creating NDEF
    /// message.
    public func createConnectionHandoverNdefMessage(deviceMac: Data) throws -> Data {
        // iOS does not provide a library to generate Bluetooth OOB, therefore hardcoded
        let hardcodedNdefType: [UInt8] = [
            0xD2, 0x20, 0x0D, 0x61, 0x70, 0x70, 0x6C, 0x69,
            0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2F, 0x76,
            0x6E, 0x64, 0x2E, 0x62, 0x6C, 0x75, 0x65, 0x74,
            0x6F, 0x6F, 0x74, 0x68, 0x2E, 0x65, 0x70, 0x2E,
            0x6F, 0x6F, 0x62, 0x0D, 0x00
        ]

        // Adding bluetooth device address to NDEF message
        var fullNdef = Data(hardcodedNdefType)

        if deviceMac.count != 6 {
            throw IOSNDEFError(description: invalidMacErrorUserInfo)
        }

        fullNdef.append(deviceMac)

        // Adding bluetooth device name to NDEF message
        var deviceName = Data([0x09])
        deviceName.append("NBT".data(using: .utf8)!)
        fullNdef.append(Data([UInt8(deviceName.count)]))
        fullNdef.append(deviceName)
        return fullNdef
    }

    /// Encodes the collection of NDEF records and return as raw byte array
    ///
    /// - Parameter ndefRecords: Collection of NDEF records that are
    /// to be encoded to raw byte array data
    ///
    /// - Returns:  Raw byte array data that is encoded
    ///
    /// - Throws: Throws an ``NdefError`` if unable to encode the
    /// NDEF message bytes.
    ///
    private func encodeNdefMessage(ndefMessage: NFCNDEFMessage) throws -> Data {
        if ndefMessage.records.isEmpty {
            return Data([0xD0, 0x00, 0x00])
        }
        var stream = Data()
        var header = IOSHandler.mbFlag
        var index = 0

        while index < ndefMessage.records.count {
            let tempRecord = ndefMessage.records[index]
            if index == ndefMessage.records.count - 1 {
                header |= IOSHandler.meFlag
            }
            let record = try RecordEncoder().encodeRecord(header: header, ndefRecord: tempRecord)
            stream.append(record)
            header = 0x00
            index += 1
        }
        return stream
    }

    /// Parses certificate string to NDEF Record for the brand protection use case, based on Android
    /// NDEF lib.
    ///
    /// - Parameter cert: Root certificate as string
    /// - Returns The NDEF record containing the certificate
    private func createInfineonBrandProtectionRecord(from cert: Data) -> NFCNDEFPayload {
        let recordTypeCert = "infineon technologies:infineon.com:nfc-bridge-tag.x509"
        let id = Data([0x00])
        return NFCNDEFPayload(
            format: .nfcExternal,
            type: recordTypeCert.data(using: .utf8)!,
            identifier: id,
            payload: cert
        )
    }
}
