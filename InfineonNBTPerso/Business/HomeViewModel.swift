// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import SwiftUI

/// The ``HomeViewModel`` class serves as a ViewModel providing the logic for selection of
/// personalization operations related to NBT device for different use case. It conforms to
/// the ``NFCSessionManager`` to effectively manage NFC reader sessions for the read NBT
/// devices personalization state. It can be also observed for changes using the
///  ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class HomeViewModel: NFCSessionManager {
    /// Indicates whether a initial NFC polling session is done or not
    private var isInitialNfcSessionStart = true

    /// A published property that represents the configuration status of a NBT. It holds a
    /// boolean value indicating whether NBT device personalization has been done or not.
    ///
    /// - Remark: The ``nbtDeviceState`` property is marked with the ``@Published`` property
    /// wrapper, allowing it to automatically publish changes to any subscribers. When the value of
    /// ``nbtDeviceState`` changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``nbtDeviceState`` is set to `unknown` as NBT
    ///   configuration status is unknown yet.
    ///
    /// - SeeAlso: ``@Published``
    @Published var nbtDeviceState: NBTDeviceState = .unknown {
        didSet {
            var newActionMenu: [ActionMenu] = []
            for index in 0 ..< actionMenu.count {
                switch nbtDeviceState {
                case .unknown:
                    newActionMenu.append(ActionMenu(
                        title: actionMenu[index].title,
                        icon: actionMenu[index].icon,
                        destination: actionMenu[index].destination,
                        isActive: false
                    ))
                case .defaultState:
                    newActionMenu.append(ActionMenu(
                        title: actionMenu[index].title,
                        icon: actionMenu[index].icon,
                        destination: actionMenu[index].destination,
                        isActive: actionMenu[index].title != .buttonTitleReset
                    ))
                case .useCasePersonalized:
                    newActionMenu.append(ActionMenu(
                        title: actionMenu[index].title,
                        icon: actionMenu[index].icon,
                        destination: actionMenu[index].destination,
                        isActive: actionMenu[index].title == .buttonTitleReset
                    ))
                }
            }
            actionMenu = newActionMenu
            if nbtDeviceState == .useCasePersonalized {
                message = .messageDeviceAlreadyPersonalized
            } else if nbtDeviceState == .defaultState {
                message = .messageAvailableInteractions
            }
        }
    }

    /// A published property that represents the action menus. It holds list of ``ActionMenu``.
    ///
    /// - Remark: The ``actionMenu`` property is marked with the ``@Published`` property
    /// wrapper, allowing it to automatically publish changes to any subscribers. When the value of
    /// ``actionMenu`` changes, the associated views are updated accordingly.
    ///
    /// - SeeAlso: ``@Published``
    @Published var actionMenu = [
        ActionMenu(
            title: .menuTitleADT,
            icon: Images.adtGreyIcon.rawValue,
            destination: AnyView(ADTView()),
            isActive: false
        ),
        ActionMenu(
            title: .menuTitleBP,
            icon: Images.certifiedIcon.rawValue,
            destination: AnyView(BrandProtectionView()),
            isActive: false
        ),
        ActionMenu(
            title: .menuTitlePT,
            icon: Images.passthroughIcon.rawValue,
            destination: AnyView(PassThroughView()),
            isActive: false
        ),
        ActionMenu(
            title: .menuTitleCH,
            icon: Images.bluetoothIcon.rawValue,
            destination: AnyView(ConnectionHandoverView()),
            isActive: false
        ),
        ActionMenu(
            title: .empty,
            icon: Images.adtGreyIcon.rawValue,
            destination: AnyView(ADTView()),
            isActive: false
        ), // If title is empty this is not visible
        ActionMenu(
            title: .buttonTitleReset,
            icon: Images.resetIcon.rawValue,
            destination: AnyView(ResetView()),
            isActive: false
        )
    ]

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to read NBT device state to activate/deactivate
    /// personalization related operation.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    override func initiateNBTDeviceCommunication() async throws {
        // Reads the NBT device state. If fails it throws the `AdpuError` or other Error
        let nfcDeviceState = try await nbtUseCaseManager?.getNBTDeviceState()
        DispatchQueue.main.async {
            self.nbtDeviceState = nfcDeviceState ?? .unknown

            // Update the user interface message as as per NBT device state.
            switch self.nbtDeviceState {
            case .defaultState:
                self.message = .messageAvailableInteractions
            case .unknown:
                self.message = .messageRetryAgain

            case .useCasePersonalized:
                self.message = .messageDeviceAlreadyPersonalized
            }
            self.tagReaderSession?.alertMessage = self.message
        }
        // Disconnect the NBT device
        try nbtUseCaseManager?.disconnect()
    }

    /// Loads the default UI state for the ``HomeView`` screen.
    ///
    /// This method is responsible for setting up the initial UI state for the ``HomeView`` screen.
    public func loadDefaultUIState() {
        DispatchQueue.main.async {
            if self.isInitialNfcSessionStart {
                self.message = String.messageToTapNfcDeviceToCheckCapabilities
                self
                    .startNFCTagReaderSession(
                        withAlertMessage: .messageToTapNfcDeviceToCheckCapabilities
                    )
                self.isInitialNfcSessionStart = false
            }
        }
    }
}
