// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view represent brand protection personalization screen of mobile phone application
/// for NBT devices.
struct BrandProtectionView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation. To be able to call that action, we
    /// need to read the presentation mode from the environment using the ``@Binding ``property
    /// wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Access the shared home ViewModel using ``@EnvironmentObject``
    @EnvironmentObject var homeViewModel: HomeViewModel

    /// An observed object representing the view model for ``BrandProtectionView``. This observed
    /// object property holds view model responsible for brand protection personalization.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var bpViewModelModel = BPViewModelModel()

    /// The `body` property represents the main content and behaviors of the
    /// ``BrandProtectionView``.
    var body: some View {
        NBTOperationView(
            inputText: $bpViewModelModel.url,
            isOperationIconActive: $bpViewModelModel.isBPStateConfigSuccess,
            inputTextHint: .defaultCottLink,
            title: .appName,
            operationMessage: bpViewModelModel.message,
            operationIcon: Images.certifiedIcon.rawValue,
            isInputVisible: true,
            inputMessage: .lableCottServerEditText,
            buttonTitle: .buttonTitlePersonalize,
            isRetryButtonActive:
            bpViewModelModel.url != .empty,
            action: {
                if bpViewModelModel.url != .empty {
                    bpViewModelModel
                        .startNFCTagReaderSession(
                            withAlertMessage: .MessageTapDeviceForBPPersonalize
                        )
                }
            }
        )
        .onAppear {
            // Set default state and on success call back.
            bpViewModelModel.loadDefaultUIState(onSuccessCallBack: {
                // Dismiss the current view.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.presentationMode.wrappedValue.dismiss()
                    // set the  NBT device state as personalized.
                    homeViewModel.nbtDeviceState = .useCasePersonalized
                }
            })
        }
    }
}

/// Provide previews and sample data for the `BrandProtectionView` during the development process.
#Preview {
    NavigationView {
        BrandProtectionView()
    }
}
