// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// An enumeration representing the NFC device states.
///
/// The ``NBTDeviceState`` enum defines various NFC device states as cases representing NBT
/// device state.
///
/// - Usage:
///  - The ``NBTDeviceState`` enum is used to represent different NBT device states.
///  - Each case of the enum represents a specific NBT device state.
public enum NBTDeviceState: UInt16 {
    /// The default state of the NBT device.
    ///
    /// The ``defaultState`` case of the ``NBTDeviceState`` enum represents the default state of the
    /// NBT device.
    ///
    /// Usage:
    /// - It indicates that the NBT device is in the ``defaultState``.
    case defaultState

    /// IF the state of the NBT device is unknown.
    ///
    /// The ``unknown`` case of the ``NBTDeviceState`` enum represents the state of the NBT
    /// device is unknown.
    ///
    /// Usage:
    /// - It indicates that the NBT device state is ``unknown``.
    case unknown

    /// The use case personalized state of the NBT device.
    ///
    /// The ``useCasePersonalized`` case of the ``NBTDeviceState`` enum represents the personalized
    /// state of the NBT device.
    ///
    /// Usage:
    /// - It indicates that the NBT device is in the ``useCasePersonalized`` state.
    case useCasePersonalized
}
