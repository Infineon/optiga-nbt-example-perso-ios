// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApduNbt

/// Class to define the states/configurations for the different use cases
public class StateConfig {
    /// CC file access policy
    private var fapCC: FileAccessPolicy

    /// NDEF file access policy
    private var fapNDEF: FileAccessPolicy

    /// FAP file access policy
    private var fapFAP: FileAccessPolicy

    /// Proprietary file1 file access policy
    private var fapFile1: FileAccessPolicy

    /// Proprietary file2 file access policy
    private var fapFile2: FileAccessPolicy

    /// Proprietary file3 file access policy
    private var fapFile3: FileAccessPolicy

    /// Proprietary file4 file access policy
    private var fapFile4: FileAccessPolicy

    /// Proprietary ``NFC`` interface configuration
    private var nfcInterfaceConfig: Bool

    /// Proprietary ``I2C`` interface configuration
    private var i2cInterfaceConfig: Bool

    /// Proprietary ``GPIO`` interface configuration
    private var gpioConfig: UInt8

    /// Constructor validates parameters and saves them to members
    /// - Parameter builder State config builder
    private init(builder: StateConfigBuilder) {
        nfcInterfaceConfig = builder.nfcInterfaceConfig
        i2cInterfaceConfig = builder.i2cInterfaceConfig
        gpioConfig = builder.gpioConfig
        fapCC = builder.fapCC
        fapNDEF = builder.fapNDEF
        fapFAP = builder.fapFAP
        fapFile1 = builder.fapFile1
        fapFile2 = builder.fapFile2
        fapFile3 = builder.fapFILE3
        fapFile4 = builder.fapFile4
    }

    /// Getter function for the CC file access policy
    ///
    /// - Returns  Returns the CC file access policy
    public func getFapCc() -> FileAccessPolicy {
        fapCC
    }

    /// Getter function for the NDEF file access policy.
    ///
    /// - Returns Returns the NDEF file access policy.
    public func getFapNdef() -> FileAccessPolicy {
        fapNDEF
    }

    /// Getter function for the FAP file access policy
    ///
    /// - Returns Returns the FAP file access policy
    public func getFapFap() -> FileAccessPolicy {
        fapFAP
    }

    /// Getter function for the proprietary file1 file access policy
    ///
    /// - Returns  Returns the proprietary file1 file access policy
    public func getFapFile1() -> FileAccessPolicy {
        fapFile1
    }

    /// Getter function for the proprietary file2 file access policy
    ///
    /// - Returns Returns the proprietary file2 file access policy
    public func getFapFile2() -> FileAccessPolicy {
        fapFile2
    }

    /// Getter function for the proprietary file2 file access policy
    ///
    /// - Returns Returns the proprietary file3 file access policy
    public func getFapFile3() -> FileAccessPolicy {
        fapFile3
    }

    /// Getter function for the proprietary file4 file access policy
    ///
    /// - Returns Returns the proprietary file4 file access policy
    public func getFapFile4() -> FileAccessPolicy {
        fapFile4
    }

    /// Getter function for the I2C interface config
    ///
    /// - Returns Returns the interface config
    public func getI2cInterfaceConfig() -> Bool {
        i2cInterfaceConfig
    }

    /// Getter function for the NFC interface config
    ///
    /// - Returns Returns the interface config
    public func getNfcInterfaceConfig() -> Bool {
        nfcInterfaceConfig
    }

    /// Getter function for the gpio config
    ///
    /// - Returns  Returns the gpio config
    public func getGpioConfig() -> UInt8 {
        gpioConfig
    }

    /// Builder class for the sample state configuration
    public class StateConfigBuilder {
        /// Proprietary ``NFC`` interface configuration with default value ``true`` menace allowed
        var nfcInterfaceConfig = true

        /// Proprietary ``I2C`` interface configuration with default value ``true`` menace allowed
        var i2cInterfaceConfig = true

        /// Proprietary ``GPIO`` interface configuration with default value ``I2C IRQ`` menace
        /// allowed
        var gpioConfig = NBTPersoConstants.nbtGpioI2CIrq

        /// Proprietary with default CC file file access policy
        var fapCC = NBTPersoConstants.defaultFapCcFile

        /// Proprietary with default NDEF file file access policy
        var fapNDEF = NBTPersoConstants.defaultFapNdefFile

        /// Proprietary with default FAP file file access policy
        var fapFAP = NBTPersoConstants.defaultFapFapFile

        /// Proprietary with default proprietary file1 specific file access policy
        var fapFile1 = NBTPersoConstants.defaultFapPpFile1

        /// Proprietary with default proprietary file2 specific file access policy
        var fapFile2 = NBTPersoConstants.defaultFapPpFile2

        /// Proprietary with default proprietary file3 file access policy
        var fapFILE3 = NBTPersoConstants.defaultFapPpFile3

        /// Proprietary with default proprietary file4 file access policy
        var fapFile4 = NBTPersoConstants.defaultFapPpFile4

        /// Setter function for the CC file access policy
        ///
        /// - Parameter fap: CC file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapCc(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapCC = fap
            return self
        }

        /// Setter function for the NDEF file access policy
        ///
        /// - Parameter fap: NDEF file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapNdef(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapNDEF = fap
            return self
        }

        /// Setter function for the FAP file access policy
        ///
        /// - Parameter fap: FAP file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapFap(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapFAP = fap
            return self
        }

        /// Setter function for the proprietary file1 file access policy
        ///
        /// - Parameter fap: Proprietary file 1  file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapFile1(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapFile1 = fap
            return self
        }

        /// Setter function for the proprietary file2 file access policy
        ///
        /// - Parameter fap: Proprietary file 2  file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapFile2(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapFile2 = fap
            return self
        }

        /// Setter function for the proprietary file3 file access policy
        ///
        /// - Parameter fap: Proprietary file 3  file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapFile3(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapFILE3 = fap
            return self
        }

        /// Setter function for the proprietary file4 file access policy
        ///
        /// - Parameter fap: Proprietary file 4  file file access policy
        ///
        /// - Returns: StateConfigBuilder context
        public func setFapFile4(fap: FileAccessPolicy) -> StateConfigBuilder {
            fapFile4 = fap
            return self
        }

        /// Setter function for the I2C interface config
        ///
        /// - Parameter i2cInterfaceConfig: I2C interface config
        /// - Returns: StateConfigBuilder context
        public func setI2cInterfaceConfig(i2cInterfaceConfig: Bool) -> StateConfigBuilder {
            self.i2cInterfaceConfig = i2cInterfaceConfig
            return self
        }

        /// Setter function for the NFC interface config
        ///
        /// - Parameter nfcInterfaceConfig: NFC interface config
        ///
        /// - Returns: StateConfigBuilder context
        public func setNfcInterfaceConfig(nfcInterfaceConfig: Bool) -> StateConfigBuilder {
            self.nfcInterfaceConfig = nfcInterfaceConfig
            return self
        }

        /// Setter function for the GPIO config
        ///
        /// - Parameter gpioConfig: GPIO interface config
        ///
        /// - Returns: StateConfigBuilder context
        public func setGpioInterfaceConfig(gpioConfig: UInt8) -> StateConfigBuilder {
            self.gpioConfig = gpioConfig
            return self
        }

        /// Constructor of the builder class
        ///
        /// - Returns: New Instance of  StateConfig class
        public func build() -> StateConfig {
            StateConfig(builder: self)
        }
    }
}
