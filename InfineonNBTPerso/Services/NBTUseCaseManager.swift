// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonApduNbt
import InfineonNdef
import InfineonUtils

/// The ``NBTUseCaseManager`` class serves as a manager for NBT personalization use case
/// supported by NBT device by providing the API specific to  use case personalization
/// operations.
public class NBTUseCaseManager {
    // MARK: - Variables

    /// Default COTT server URL used by BP use case.
    public var cottUrl =
        "http://www.infineon.com/?cott=PLACEHOLDERPLACEHOLDERPLACEHOLDERPLACEHOLDER"

    /// Placeholder for the dynamic COTT instance
    public final let cottPlaceholder = "?cott=PLACEHOLDERPLACEHOLDERPLACEHOLDERPLACEHOLDER"

    // MARK: - CommandSet

    /// A property holder for the ``NbtCommandSet`` which provides the API supported by the NBT
    /// device application.
    ///
    /// - SeeAlso: ``NBTCommandSet``
    private var nbtCommandSet: NbtCommandSet

    /// A property holder for the ``NbtCommandSetPerso`` which provides the personalization API
    /// supported by the NBT device personalization  application.
    ///
    /// - SeeAlso: ``NBTCommandSet``
    private var persoCommandSet: NbtCommandSetPerso

    // MARK: - ADT file access policy constants

    /// NDEF file access policy for ADT use case.
    private static let adtFapNdef = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdNdefFile,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.allow,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File1 specific file access policy for ADT use case.
    private static let adtFapFile1 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP1FileId,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.allow
    )

    /// File2 specific file access policy for ADT use case.
    private static let adtFapFile2 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP2FileId,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.allow,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File3 specific file access policy for ADT use case.
    private static let adtFapFile3 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP3FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File4 specific file access policy for ADT use case.
    private static let adtFapFile4 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP4FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    // MARK: - PT file access policy constants

    /// NDEF file access policy for PT use case.
    private static let ptFapNdef = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdNdefFile,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.allow,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File1 file access policy for PT use case.
    private static let ptFapFile1 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP1FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File2 file access policy for PT use case.
    private static let ptFapFile2 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP2FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File3 file access policy for PT use case.
    private static let ptFapFile3 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP3FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File4 file access policy for PT use case.
    private static let ptFapFile4 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP4FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    // MARK: - CH file access policy constants

    /// NDEF file access policy for CH use case.
    private static let chFapNdef = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdNdefFile,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.allow,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File1 file access policy for CH use case.
    private static let chFapFile1 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP1FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File2 file access policy for CH use case.
    private static let chFapFile2 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP2FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File3 file access policy for CH use case.
    private static let chFapFile3 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP3FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File4 file access policy for CH use case.
    private static let chFapFile4 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP4FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    // MARK: - BP file access policy constants

    /// NDEF file access policy for BP use case.
    private static let bpFapNdef = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdNdefFile,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// CC file access policy for BP use case.
    private static let bpFapCC = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdCCFile,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File1 file access policy for BP use case.
    private static let bpFapFile1 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP1FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File2 file access policy for BP use case.
    private static let bpFapFile2 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP2FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File3 file access policy for BP use case.
    private static let bpFapFile3 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP3FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// File4 file access policy for BP use case.
    private static let bpFapFile4 = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtPP4FileId,
        accessConditionI2CR: NBTPersoConstants.block,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.block,
        accessConditionNfcW: NBTPersoConstants.block
    )

    // MARK: - CC file access policy constants

    /// CC file access policy for default state.
    private static let defaultFapCC = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdCCFile,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.block
    )

    /// Temporary CC specific file access policy to be able to write the file via NFC
    private static let writeFapCC = FileAccessPolicy(
        fileId: NBTPersoConstants.nbtIdCCFile,
        accessConditionI2CR: NBTPersoConstants.allow,
        accessConditionI2CW: NBTPersoConstants.block,
        accessConditionNfcR: NBTPersoConstants.allow,
        accessConditionNfcW: NBTPersoConstants.allow
    )

    /// - Parameters:
    ///  - nbtCommandSet: A ``NBTCommandSet`` object. it represents the command set to be used by
    ///     the ``NBTUseCaseManager`` instance to perform APDU communication.
    ///   - persoCommandSet : An ``NbtCommandSetPerso`` object. it represents the command set to be
    /// used by the ``NBTUseCaseManager`` instance to perform personalization APDU communication.
    init(nbtCommandSet: NbtCommandSet, persoCommandSet: NbtCommandSetPerso) {
        self.nbtCommandSet = nbtCommandSet
        self.persoCommandSet = persoCommandSet
        // Initialize the NFC constant
        NBTPersoConstants.initialize()
    }

    /// Async method to connect to the NBT device.
    ///
    /// - Throws An ``APDUError``: if connecting to NBT fails.
    public func connect() async throws {
        _ = try await nbtCommandSet.connect(data: nil)
    }

    /// Method to disconnect from NBT device.
    ///
    /// - Throws An ``APDUError``: if disconnecting from NBT device fails.
    public func disconnect() throws {
        try nbtCommandSet.disconnect()
    }

    /// Async method to select application associated with ``NBTCommandSet``.
    ///
    /// - Returns: ``NbtApduResponse`` of select application command.
    /// - Throws An ``APDUError``: if communication with NBT device fails.
    public func selectApplication() async throws -> NbtApduResponse {
        try await nbtCommandSet.selectApplication()
    }

    /// Async method to reads the NBT device state.
    ///
    /// - Returns: NBTDeviceState of NFC device
    ///
    /// - Throws An ``APDUError``: if communication with NBT device fails. or read
    /// configuration operation.
    public func getNBTDeviceState() async throws -> NBTDeviceState {
        let apduResponse = try await nbtCommandSet.readFapBytes().checkOK()

        if let data = apduResponse.getData(), !data.isEmpty {
            if NBTPersoConstants.defaultFapBytes.elementsEqual(data) {
                return .defaultState
            }
            return .useCasePersonalized
        } else {
            return .unknown
        }
    }

    /// Async method to reset NBT device state by reseting File Access Policies for all PP
    /// files and NDEF file to default state.
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or reset
    /// configuration
    /// operation.
    public func resetNfcDeviceState() async throws {
        // If no parameters are specifically set, they will be set to default state
        let defaultStateConfig = StateConfig.StateConfigBuilder()
            .setI2cInterfaceConfig(i2cInterfaceConfig: true)
            .setNfcInterfaceConfig(nfcInterfaceConfig: true)
            .setGpioInterfaceConfig(gpioConfig: NBTPersoConstants.nbtGpioI2CIrq)
            .build()

        try await updateCCFiles(config: defaultStateConfig)
        try await updateFileAccessPolicies(config: defaultStateConfig)

        // Also Reset the NDEF file to default state
        try await resetNDEFFile()
    }

    /// Async method to configure NBT device for Asynchronous Data Transfer (ADT) use case.
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or ADT
    /// configuration
    /// operation.
    public func configureAdtUseCase() async throws {
        let adtStateConfig = StateConfig.StateConfigBuilder()
            .setFapNdef(fap: NBTUseCaseManager.adtFapNdef)
            .setFapFile1(fap: NBTUseCaseManager.adtFapFile1)
            .setFapFile2(fap: NBTUseCaseManager.adtFapFile2)
            .setFapFile3(fap: NBTUseCaseManager.adtFapFile3)
            .setFapFile4(fap: NBTUseCaseManager.adtFapFile4)
            .setI2cInterfaceConfig(i2cInterfaceConfig: true)
            .setNfcInterfaceConfig(nfcInterfaceConfig: true)
            .setGpioInterfaceConfig(gpioConfig: NBTPersoConstants.nbtGpioI2CIrq)
            .build()

        try await updateCCFiles(config: adtStateConfig)
        try await updateFileAccessPolicies(config: adtStateConfig)
    }

    /// Async method to configure NBT device for Pass Through (PT) use case.
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or PT
    /// configuration
    /// operation.
    public func configurePTUseCase() async throws {
        let passThroughStateConfig = StateConfig.StateConfigBuilder()
            .setFapNdef(fap: NBTUseCaseManager.ptFapNdef)
            .setFapFile1(fap: NBTUseCaseManager.ptFapFile1)
            .setFapFile2(fap: NBTUseCaseManager.ptFapFile2)
            .setFapFile3(fap: NBTUseCaseManager.ptFapFile3)
            .setFapFile4(fap: NBTUseCaseManager.ptFapFile4)
            .setI2cInterfaceConfig(i2cInterfaceConfig: true)
            .setNfcInterfaceConfig(nfcInterfaceConfig: true)
            .setGpioInterfaceConfig(gpioConfig: NBTPersoConstants.nbtGpioI2CIrq)
            .build()

        try await updateCCFiles(config: passThroughStateConfig)
        try await updateFileAccessPolicies(config: passThroughStateConfig)
    }

    /// Async method to configure NBT 200 device for Connection Handover (CH) use case
    ///
    /// - Parameter macAddress: The bluetooth mac address text input entered by the user
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or CH
    /// configuration
    /// operation.
    public func configureCHUseCase(macAddress: String) async throws {
        try await writeCHNDEFMessage(macAddress: Utils.toData(stream: macAddress))
        // Configure The CH Use case
        let chStateConfig = StateConfig.StateConfigBuilder()
            .setFapNdef(fap: NBTUseCaseManager.chFapNdef)
            .setFapFile1(fap: NBTUseCaseManager.chFapFile1)
            .setFapFile2(fap: NBTUseCaseManager.chFapFile2)
            .setFapFile3(fap: NBTUseCaseManager.chFapFile3)
            .setFapFile4(fap: NBTUseCaseManager.chFapFile4)
            .setI2cInterfaceConfig(i2cInterfaceConfig: true)
            .setNfcInterfaceConfig(nfcInterfaceConfig: true)
            .setGpioInterfaceConfig(gpioConfig: NBTPersoConstants.nbtGpioI2CIrq)
            .build()
        try await updateCCFiles(config: chStateConfig)
        try await updateFileAccessPolicies(config: chStateConfig)
    }

    /// Async method to configure NBT device for Brand Protection (BP) use case.
    ///
    /// - Parameters:
    ///  - ecKey: The EC Key for Encryption and decryption.
    ///  - url: URL for verification COTT server.
    ///  - cert: The x509 Certificate for Encryption and decryption.
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or BP
    /// configuration
    /// operation.
    public func configureBPUseCase(ecKey: Data, url: String, cert: Data) async throws {
        if url != String.empty {
            cottUrl = url + cottPlaceholder
        }

        try await writeSampleEcKey(ecKey: ecKey)

        try await writeBrandProtectionNDEFMessage(cottUrl: cottUrl, cert: cert)

        let bpStateConfig = StateConfig.StateConfigBuilder()
            .setFapCc(fap: NBTUseCaseManager.bpFapCC)
            .setFapNdef(fap: NBTUseCaseManager.bpFapNdef)
            .setFapFile1(fap: NBTUseCaseManager.bpFapFile1)
            .setFapFile2(fap: NBTUseCaseManager.bpFapFile2)
            .setFapFile3(fap: NBTUseCaseManager.bpFapFile3)
            .setFapFile4(fap: NBTUseCaseManager.bpFapFile4)
            .setI2cInterfaceConfig(i2cInterfaceConfig: true)
            .setNfcInterfaceConfig(nfcInterfaceConfig: true)
            .setGpioInterfaceConfig(gpioConfig: NBTPersoConstants.nbtGpioI2CIrq)
            .build()

        try await updateCCFiles(config: bpStateConfig)
        try await updateFileAccessPolicies(config: bpStateConfig)
    }

    /// Creates and writes COTT link and certificate to NDEF file, according to the brand protection
    /// use case.
    ///
    /// - Parameter macAddress: The byte array representing bluetooth mac address.
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or CH NDEF
    /// message configuration operation.
    private func writeCHNDEFMessage(macAddress: Data) async throws {
        // Choose between Android or Infineon specific NDEF library using the corresponding handler
        let handler = InfineonHandler()
        let ndefMessage = try handler.createConnectionHandoverNdefMessage(deviceMac: macAddress)
        try await updateNDEFMessage(ndefMessage: ndefMessage)
    }

    /// Creates and writes COTT link and certificate to NDEF file, according to the brand protection
    /// use case.
    ///
    /// - Parameters:
    ///  - cottUrl: URL for verification COTT server.
    /// - cert: The x509 Certificate for Encryption and decryption.
    ///
    /// - Throws  An ``APDUError``: if there are any issues with the APDU communication or BP NDEF
    /// message configuration operation.
    private func writeBrandProtectionNDEFMessage(cottUrl: String, cert: Data) async throws {
        // Choose between Android or Infineon specific NDEF library using the corresponding handler
        let handler = InfineonHandler()
        let ndefMessage = try handler.createBrandProtectionNdefMessage(url: cottUrl, cert: cert)
        try await updateNDEFMessage(ndefMessage: ndefMessage)
    }

    /// Async method to update CC, NDEF, FAP and EP File Access Policies to NFC device.
    ///
    /// - Parameter config: Define the states/configurations for the different use cases.
    ///
    /// - Throws  An ``APDUError`` if there are any issues with the APDU communication or update FAP
    /// operation.
    private func updateFileAccessPolicies(config: StateConfig) async throws {
        var apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapCc())
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapNdef())
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapFap())
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapFile1())
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapFile2())
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapFile3())
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: config.getFapFile4())
        _ = try apduResponse.checkOK()
    }

    /// Async method to update CC, NDEF, FAP and EP File Access Policies to NFC device.
    ///
    /// - Parameter config: Define the states/configurations for the different use cases.
    ///
    /// - Throws  An ``APDUError``  if there are any issues with the APDU communication or update
    /// FAP
    /// operation.
    private func updateCCFiles(config: StateConfig) async throws {
        var apduResponse = try await nbtCommandSet
            .updateFap(fapPolicy: NBTUseCaseManager.writeFapCC)
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.selectFile(fileId: NBTPersoConstants.nbtIdCCFile)
        _ = try apduResponse.checkOK()

        let ccByteArray = try buildCcFile(
            fapFile1: config.getFapFile1(),
            fapFile2: config.getFapFile2(),
            fapFile3: config.getFapFile3(),
            fapFile4: config.getFapFile4()
        )
        apduResponse = try await nbtCommandSet.updateBinary(
            offset: NBTPersoConstants.ccOffset,
            data: ccByteArray
        )
        _ = try apduResponse.checkOK()

        apduResponse = try await nbtCommandSet.updateFap(fapPolicy: NBTUseCaseManager.defaultFapCC)
        _ = try apduResponse.checkOK()
    }

    /// Async method to delete data in NDEF file ( only the NDEF file), Additionally setting the
    /// data length of the empty NDEF file to zero.
    ///
    /// - Throws  An ``APDUError``  if fails to update NDEF message or there are any issues with the
    /// APDU
    /// communication.
    private func resetNDEFFile() async throws {
        _ = try await updateNDEFMessage(ndefMessage: Data(NBTPersoConstants.emptyNdef))

        _ = try await nbtCommandSet.selectFile(fileId: NBTPersoConstants.nbtIdNdefFile).checkOK()

        // Additionally setting the data length of the empty NDEF file to zero
        _ = try await nbtCommandSet.updateBinary(
            offset: NBTPersoConstants.defaultOffset,
            data: Data(NBTPersoConstants.emptyNdefLength)
        ).checkOK()
    }

    /// Async method to update the NDEF message to NFC device.
    ///
    /// - Parameter ndefMessage: byte array of NDEF message.
    ///
    /// - Throws  An ``APDUError`` if fails to update NDEF message or there are any issues with the
    /// APDU
    /// communication.
    private func updateNDEFMessage(ndefMessage: Data) async throws {
        let apduResponse = try await nbtCommandSet.updateNdefMessage(dataBytes: ndefMessage)
        _ = try apduResponse.checkOK()
    }

    /// Async method to update the EC key in the BSK file of NFC device.
    ///
    /// - Note : The EC key in the BSK file needs to be overwritten for this demonstrator purpose to
    /// ensure that the sample data also works with productive samples.
    ///
    /// - Parameter ecKey: Optional byte array defining EC key.
    ///
    /// - Throws  An ``APDUError`` if fails to update EC key or there are any issues with the APDU
    /// communication.
    private func writeSampleEcKey(ecKey: Data) async throws {
        _ = try await persoCommandSet.personalizeData(
            dgi: NBTPersoConstants.nbtBskId,
            personalizeData: ecKey
        ).checkOK()
    }

    /// Translates the file access policies to the CC file format and builds full byte array to
    /// update the CC file
    ///
    /// - Parameters:
    ///  - fap_file1 File Access Policy for proprietary file1
    ///  - fap_file2 File Access Policy for proprietary file2
    ///  - fap_file3 File Access Policy for proprietary file3
    ///  - fap_file4 File Access Policy for proprietary file4
    /// - Throws A ``FileAccessPolicyError`` thrown by APDU library in case of FAP error
    public func buildCcFile(
        fapFile1: FileAccessPolicy,
        fapFile2: FileAccessPolicy,
        fapFile3: FileAccessPolicy,
        fapFile4: FileAccessPolicy
    ) throws -> Data {
        let ppFileHeader: [UInt8] = [0x05, 0x06, 0xE1]
        let ppFileSize: [UInt8] = [0x04, 0x00]
        var ccFileOutputStream = Data()

        // Transfer the access condition to a CC file valid format (if fap is 0x40 (=allow) it is
        // set to 0x00 (=allow in cc file)
        let f1Fap: [UInt8] = try [
            (fapFile1.getAccessBytes()[2] == 0x00) ? 0xFF : 0x00,
            (fapFile1.getAccessBytes()[3] == 0x00) ? 0xFF : 0x00
        ]
        let f2Fap: [UInt8] = try [
            (fapFile2.getAccessBytes()[2] == 0x00) ? 0xFF : 0x00,
            (fapFile2.getAccessBytes()[3] == 0x00) ? 0xFF : 0x00
        ]
        let f3Fap: [UInt8] = try [
            (fapFile3.getAccessBytes()[2] == 0x00) ? 0xFF : 0x00,
            (fapFile3.getAccessBytes()[3] == 0x00) ? 0xFF : 0x00
        ]
        let f4Fap: [UInt8] = try [
            (fapFile4.getAccessBytes()[2] == 0x00) ? 0xFF : 0x00,
            (fapFile4.getAccessBytes()[3] == 0x00) ? 0xFF : 0x00
        ]

        // Combine to one byte array
        ccFileOutputStream.append(contentsOf: ppFileHeader)
        ccFileOutputStream.append(contentsOf: [UInt8(NBTPersoConstants.nbtPP1FileId & 0xFF)])
        ccFileOutputStream.append(contentsOf: ppFileSize)
        ccFileOutputStream.append(contentsOf: f1Fap)

        ccFileOutputStream.append(contentsOf: ppFileHeader)
        ccFileOutputStream.append(contentsOf: [UInt8(NBTPersoConstants.nbtPP2FileId & 0xFF)])
        ccFileOutputStream.append(contentsOf: ppFileSize)
        ccFileOutputStream.append(contentsOf: f2Fap)

        ccFileOutputStream.append(contentsOf: ppFileHeader)
        ccFileOutputStream.append(contentsOf: [UInt8(NBTPersoConstants.nbtPP3FileId & 0xFF)])
        ccFileOutputStream.append(contentsOf: ppFileSize)
        ccFileOutputStream.append(contentsOf: f3Fap)

        ccFileOutputStream.append(contentsOf: ppFileHeader)
        ccFileOutputStream.append(contentsOf: [UInt8(NBTPersoConstants.nbtPP4FileId & 0xFF)])
        ccFileOutputStream.append(contentsOf: ppFileSize)
        ccFileOutputStream.append(contentsOf: f4Fap)
        return ccFileOutputStream
    }
}
