// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view represent connection handover personalization screen of mobile phone application
/// for NBT devices.
struct ConnectionHandoverView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation. To be able to call that action, we
    /// need to read the presentation mode from the environment  using the ``@Binding`` property
    /// wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Access the shared home ViewModel using ``@EnvironmentObject``
    @EnvironmentObject var homeViewModel: HomeViewModel

    /// An observed object representing the view model for ``ConnectionHandoverView``. This observed
    /// object property holds view model responsible for connection handover personalization.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var chViewModelModel = CHViewModelModel()

    /// The `body` property represents the main content and behaviors of the
    /// ``ConnectionHandoverView``.
    var body: some View {
        NBTOperationView(
            inputText: $chViewModelModel.macAddress,
            isOperationIconActive: $chViewModelModel.isCHStateConfigSuccess,
            inputTextHint: .hintDefaultBELMacAddress,
            title: .appName,
            operationMessage: chViewModelModel.message,
            operationIcon: Images.bluetoothIcon.rawValue,
            isInputVisible: true,
            inputMessage: .lableBLEMacEditText,
            buttonTitle: .buttonTitlePersonalize,
            isRetryButtonActive:
            chViewModelModel.macAddress.count == NBTPersoConstants.bluetoothMacAddressSize,
            action: {
                if chViewModelModel.macAddress.count == NBTPersoConstants.bluetoothMacAddressSize {
                    chViewModelModel
                        .startNFCTagReaderSession(
                            withAlertMessage: .messageTapDeviceForCHPersonalize
                        )
                }
            },
            isHexInputEnable: true
        )
        .onAppear {
            // set on success call back.
            chViewModelModel.set(onSuccessCallBack: {
                // Dismiss the current view.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.presentationMode.wrappedValue.dismiss()
                    // set the  NBT device state as personalized.
                    homeViewModel.nbtDeviceState = .useCasePersonalized
                }
            })
            // Set default state for UI
            chViewModelModel.loadDefaultUIState()
        }
    }
}

/// Provide previews and sample data for the `ConnectionHandoverView` during the development
/// process.
#Preview {
    NavigationView {
        ConnectionHandoverView()
    }
}
