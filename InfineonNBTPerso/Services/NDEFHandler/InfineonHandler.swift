// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonNdef

/// Handler using the a Infineon Java NDEF library to handle the standardize NDEF file format, parse
/// and validate the certificate
public class InfineonHandler: INDEFHandler {
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
        let uriRecord = try UriRecord(uriIdentifier: UriRecord.UriIdentifier.uriHttp, uri: url)
        let extRecord = createInfineonBrandProtectionRecord(from: cert)
        let message = NdefMessage(ndefRecords: [uriRecord, extRecord])
        let messageData = try NdefManager.encode(message: message)

        return messageData
    }

    /// Parses the NDEF message for the connection handover use case, containing the bluetooth mac
    /// address (only supported by Infineon Lib)
    ///
    /// - Parameter deviceMac: MAC address of bluetooth device
    /// - Returns The NDEF message as byte array
    /// - Throws: An ``NdefError`` and ``CertificateError``  in case issue with creating NDEF
    /// message.
    public func createConnectionHandoverNdefMessage(deviceMac: Data) throws -> Data {
        let localName = "NBT"
        let record = createConnectionHandoverRecord(deviceMac: deviceMac, localName: localName)
        let message = NdefMessage(ndefRecords: [record])
        let messageData = try NdefManager.encode(message: message)
        return messageData
    }

    /// Creates and returns a NDEF record for the bluetooth connection handover (OOB data) based on
    /// the given mac address of the bluetooth device. Additionally a general local name for the
    /// bluetooth device is added to the record.
    ///
    /// - Parameter deviceMac: MAC address of bluetooth device.
    /// - Parameter local_name: Local name of the bluetooth device, will be added to record.
    /// - Returns Bluetooth NDEF record  record.
    private func createConnectionHandoverRecord(
        deviceMac: Data,
        localName: String?
    ) -> BluetoothRecord {
        let record = BluetoothRecord(deviceAddress: deviceMac)
        if let deviceName = localName {
            record.setName(dataTypes: DataTypes.completeLocalName, localName: deviceName)
        }
        return record
    }

    /// Parses certificate string to NDEF Record for the brand protection use case, based on Android
    /// NDEF lib.
    ///
    /// - Parameter cert: Root certificate as string
    /// - Returns The NDEF record containing the certificate
    private func createInfineonBrandProtectionRecord(from cert: Data) -> NdefRecord {
        let recordTypeCert = "infineon technologies:infineon.com:nfc-bridge-tag.x509"
        let recordID = Data([0x00])

        return NdefRecord(
            tnf: NdefConstants.tnfExternalType,
            type: recordTypeCert.data(using: .utf8)!,
            id: recordID,
            payload: cert
        )
    }
}
