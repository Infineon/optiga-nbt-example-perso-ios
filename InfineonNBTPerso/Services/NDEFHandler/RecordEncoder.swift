// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import CoreNFC
import Foundation
import InfineonUtils

/// Encodes the records into NDEF records.
public class RecordEncoder {
    /// Maximum length for the short record is 255.
    private let maxLengthForShortRecord = 255

    /// The CF flag is a 1-bit field indicating that this is either the first
    /// record chunk or a middle record chunk of a chunked payload .
    public static let cfFlag: UInt8 = 0x20

    /// The SR flag is a 1-bit field indicating, if set, that the PAYLOAD_LENGTH
    /// field is a single octet. This short record layout is intended for compact
    /// encapsulation of small payloads which will fit within PAYLOAD fields of
    /// size ranging between 0 to 255 octets.
    public static let srFlag: UInt8 = 0x10

    /// The IL flag is a 1-bit field indicating, if set, that the ID_LENGTH field
    /// is present in the header as a single octet. If the IL flag is zero, the
    /// ID_LENGTH field is omitted from the record header and the ID field is
    /// also omitted from the record.
    public static let ilFlag: UInt8 = 0x08

    /// Private tag for the logger message header
    private let headerTag = "RecordEncoder"

    /// Error message for invalid id length
    private let errInvalidIdLength = "Expected record id length <= 255 bytes"

    /// Error message for invalid payload type
    private let errInvalidPayloadType = "Unable to find encoder for payload"

    /// Length of the payload
    private let payloadLengthSize = 4

    /// Encodes the NDEF record.
    ///
    /// - Parameters:
    ///   - header: Record header
    ///   - abstractRecord: NDEF record
    ///
    /// - Returns: Returns the encoded byte array of the NDEF record.
    ///
    /// - Throws: NdefException Throws an NDEF exception if unable to
    /// encode the record.
    ///
    public func encodeRecord(header: UInt8, ndefRecord: NFCNDEFPayload) throws -> Data {
        let id: Data? = ndefRecord.identifier
        if let id = id, id.count > maxLengthForShortRecord {
            let appId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
            throw NSError(
                domain: appId!,
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: errInvalidIdLength]
            )
        }
        var stream = Data()

        stream = assembleRecordBytes(
            header: header,
            stream: stream,
            ndefRecord: ndefRecord,
            payload: ndefRecord.payload
        )
        return stream
    }

    /// Assembles the record bytes in the structure frame.
    ///
    /// - Parameters:
    ///   - header: Record header
    ///   - stream: Data stream in which the assembled byte is stored.
    ///   - ndefRecord:  NDEF record
    ///   - payload:  Encoded payload byte array of the record.
    ///
    /// - Returns: Assembled record bytes as data
    ///
    private func assembleRecordBytes(
        header: UInt8,
        stream: Data,
        ndefRecord: NFCNDEFPayload,
        payload: Data
    ) -> Data {
        var newStream = stream
        newStream = appendHeader(
            header: header,
            stream: newStream,
            ndefRecord: ndefRecord,
            payload: payload
        )
        newStream.append(UInt8(ndefRecord.type.count))
        newStream = appendPayloadLength(stream: newStream, length: payload.count)
        newStream = appendIdLength(stream: newStream, length: ndefRecord.identifier.count)
        newStream = appendData(stream: newStream, data: ndefRecord.type)
        newStream = appendData(stream: newStream, data: ndefRecord.identifier)
        newStream = appendData(stream: newStream, data: payload)
        return newStream
    }

    /// Appends the header of the record.
    /// '
    /// - Parameters:
    ///   - header: Record header
    ///   - stream: Data stream in which the assembled byte is stored.
    ///   - ndefRecord: NDEF record
    ///   - payload:  Encoded payload byte array of the record.
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendHeader(
        header: UInt8,
        stream: Data,
        ndefRecord: NFCNDEFPayload,
        payload: Data
    ) -> Data {
        var newStream = stream
        var header: UInt8 = header
        header = setShortRecord(header: header, payload: payload)
        header = setIdLength(header: header, ndefRecord: ndefRecord)
        header = setTypeNameFormat(header: header, ndefRecord: ndefRecord)
        newStream.append(header)
        return newStream
    }

    /// Appends the input data to the stream.
    ///
    /// - Parameters:
    ///   - stream: Data  stream in which the appended byte is stored.
    ///   - data: Data to be appended.
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendData(stream: Data, data: Data) -> Data {
        var newStream = stream
        if !data.isEmpty {
            newStream.append(contentsOf: data)
        }
        return newStream
    }

    /// Sets short record flag, if it is short.
    ///
    /// - Parameters:
    ///   - header: Header of the record.
    ///   - payload: Encoded payload byte array of the record.
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func setShortRecord(header: UInt8, payload: Data) -> UInt8 {
        var updatedHeader = header
        if payload.count <= maxLengthForShortRecord {
            updatedHeader |= RecordEncoder.srFlag
        }
        return updatedHeader
    }

    /// Sets record ID flag, if record has record ID.
    ///
    /// - Parameters:
    ///   - header: Header of the record.
    ///   - ndefRecord: NDEF record
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func setIdLength(header: UInt8, ndefRecord: NFCNDEFPayload) -> UInt8 {
        var updatedHeader = header
        if !ndefRecord.identifier.isEmpty {
            updatedHeader |= RecordEncoder.ilFlag
        }
        return updatedHeader
    }

    /// Sets the record TNF bits.
    ///
    /// - Parameters:
    ///   - header: Header of the record.
    ///   - ndefRecord: NDEF record
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func setTypeNameFormat(
        header: UInt8,
        ndefRecord: NFCNDEFPayload
    ) -> UInt8 {
        var updatedHeader = header
        updatedHeader |= ndefRecord.typeNameFormat.rawValue
        return updatedHeader
    }

    /// Appends the record payload length to the data stream.
    ///
    /// - Parameters:
    ///   - stream: Data stream in which the appended byte is stored.
    ///   - length: Record payload length
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendPayloadLength(
        stream: Data,
        length: Int
    ) -> Data {
        var newStream = stream
        if length <= maxLengthForShortRecord {
            newStream.append(UInt8(length))
        } else {
            let payloadLengthArray = Utils.toData(value: length, length: payloadLengthSize)
            newStream.append(contentsOf: payloadLengthArray)
        }
        return newStream
    }

    /// Appends the record ID length to the data stream.
    ///
    /// - Parameters:
    ///   - stream: Data stream to append the record ID.
    ///   - length: Record ID length
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendIdLength(
        stream: Data,
        length: Int
    ) -> Data {
        var newStream = stream
        if length > .zero {
            newStream.append(UInt8(length))
        }
        return newStream
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
