// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view represent pass through personalization screen of mobile phone application
/// for NBT devices.
struct PassThroughView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation. To be able to call that action, we
    /// need to read the presentation mode from the environment using the ``@Binding`` property
    /// wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Access the shared home ViewModel using ``@EnvironmentObject``
    @EnvironmentObject var homeViewModel: HomeViewModel

    /// An observed object representing the view model for ``PassThroughView``. This observed
    /// object property holds view model responsible for pass through personalization.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var passThroughViewModel = PassThroughViewModel()

    /// The `body` property represents the main content and behaviors of the
    /// ``BrandProtectionView``.
    var body: some View {
        NBTOperationView(
            inputText: .constant(.empty),
            isOperationIconActive: $passThroughViewModel
                .isPTStateConfigSuccess, inputTextHint: .empty,
            title: .appName,
            operationMessage: passThroughViewModel.message,
            operationIcon: Images.passthroughIcon.rawValue,
            isInputVisible: false,
            action: {
                passThroughViewModel.loadDefaultUIState()
            }
        )
        .onAppear {
            // Set on success call back.
            passThroughViewModel.set(onSuccessCallBack: {
                // Dismiss the current view.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.presentationMode.wrappedValue.dismiss()
                    // set the  NBT device state as personalized.
                    homeViewModel.nbtDeviceState = .useCasePersonalized
                }
            })

            // Set default state
            passThroughViewModel.loadDefaultUIState()
        }
    }
}

/// Provide previews and sample data for the `PassThroughView` during the development process.
#Preview {
    NavigationView {
        PassThroughView()
    }
}
