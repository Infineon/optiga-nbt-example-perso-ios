// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApduNbt

/// Stores basic constants for the NBT product line.
public enum NBTPersoConstants {
    /// The constant defines the time delay for DispatchQueue to execute task after 3.0 sec
    public static let timeDelay = 3.0

    /// Global variable for the CC file offset
    public static let ccOffset: UInt16 = 15

    /// The Constant defines the size of bluetooth address in char, e.g 12 char is equal to 6 byte
    public static let bluetoothMacAddressSize = 12

    /// The empty NDEF file to be written, hardcoded size
    public static let emptyNdef = [UInt8](repeating: 0, count: 850)

    /// NDEF file length info for empty NDEF file
    public static let emptyNdefLength: [UInt8] = [0x00, 0x00]

    /// Global constant for the default offset
    public static let defaultOffset: UInt16 = 0

    /// Global variable for the default fap file bytes.
    public static let defaultFapBytes = Data(
        [
            0xE1, 0x03, 0x40, 0x00, 0x40, 0x00,
            0xE1, 0x04, 0x40, 0x40, 0x40, 0x40,
            0xE1, 0xA1, 0x40, 0x40, 0x40, 0x40,
            0xE1, 0xA2, 0x40, 0x40, 0x40, 0x40,
            0xE1, 0xA3, 0x40, 0x40, 0x40, 0x40,
            0xE1, 0xA4, 0x40, 0x40, 0x40, 0x40,
            0xE1, 0xAF, 0x40, 0x40, 0x40, 0x40
        ]
    )
    /// Global constant for CC file ID
    public static let nbtIdCCFile: UInt16 = 0xE103

    /// Global constant for NDEF file ID
    public static let nbtIdNdefFile: UInt16 = 0xE104

    /// Global constant for FAP file ID
    public static let nbtIdFapFile: UInt16 = 0xE1AF

    /// Global constant for proprietary file1 ID
    public static let nbtPP1FileId: UInt16 = 0xE1A1

    /// Global constant for proprietary file2 ID
    public static let nbtPP2FileId: UInt16 = 0xE1A2

    /// Global constant for proprietary file3 ID
    public static let nbtPP3FileId: UInt16 = 0xE1A3

    /// Global constant for proprietary file4 ID
    public static let nbtPP4FileId: UInt16 = 0xE1A4

    /// Global constant GPIO configurations with I2C IRQ
    public static let nbtGpioI2CIrq: UInt8 = 0x03

    /// Global variable for BMK key file ID
    public static let nbtBmkId: UInt16 = 40961

    /// Global variable for BSK key file ID
    public static let nbtBskId: UInt16 = 40962

    /// Global variable for access condition to block access. Need to call initialize() before use
    /// it
    public static var block: AccessCondition!

    /// Global variable for access condition to allow access. Need to call initialize() before use
    /// it
    public static var allow: AccessCondition!

    /// Initializing access conditions
    static func initialize() {
        do {
            block = try AccessCondition(accessConditionType: .never)
            allow = try AccessCondition(accessConditionType: .always)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Global constant CC file specific file access policy
    public static let defaultFapCcFile = FileAccessPolicy(
        fileId: nbtIdCCFile,
        accessConditionI2CR: allow,
        accessConditionI2CW: block,
        accessConditionNfcR: allow,
        accessConditionNfcW: block
    )

    /// Global constant NDEF file specific file access policy
    public static let defaultFapNdefFile = FileAccessPolicy(
        fileId: nbtIdNdefFile,
        accessConditionI2CR: allow,
        accessConditionI2CW: allow,
        accessConditionNfcR: allow,
        accessConditionNfcW: allow
    )

    /// Global constant FAP file specific file access policy
    public static let defaultFapFapFile = FileAccessPolicy(
        fileId: nbtIdFapFile,
        accessConditionI2CR: allow,
        accessConditionI2CW: allow,
        accessConditionNfcR: allow,
        accessConditionNfcW: allow
    )

    /// Global constant  proprietary file1 specific file access policy
    public static let defaultFapPpFile1 = FileAccessPolicy(
        fileId: nbtPP1FileId,
        accessConditionI2CR: allow,
        accessConditionI2CW: allow,
        accessConditionNfcR: allow,
        accessConditionNfcW: allow
    )

    /// Global constant  proprietary file2 specific file access policy
    public static let defaultFapPpFile2 = FileAccessPolicy(
        fileId: nbtPP2FileId,
        accessConditionI2CR: allow,
        accessConditionI2CW: allow,
        accessConditionNfcR: allow,
        accessConditionNfcW: allow
    )

    /// Global constant  proprietary file3 specific file access policy
    public static let defaultFapPpFile3 = FileAccessPolicy(
        fileId: nbtPP3FileId,
        accessConditionI2CR: allow,
        accessConditionI2CW: allow,
        accessConditionNfcR: allow,
        accessConditionNfcW: allow
    )

    /// Global constant  proprietary file4 specific file access polic
    public static let defaultFapPpFile4 = FileAccessPolicy(
        fileId: nbtPP4FileId,
        accessConditionI2CR: allow,
        accessConditionI2CW: allow,
        accessConditionNfcR: allow,
        accessConditionNfcW: allow
    )
}
