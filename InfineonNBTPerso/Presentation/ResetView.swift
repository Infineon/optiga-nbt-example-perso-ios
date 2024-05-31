// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view represent reset personalization screen of mobile phone application for NBT
/// devices.
struct ResetView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation. To be able to call that action, we
    /// need to read the presentation mode from the environment  using the @Binding property
    /// wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// An observed object representing the view model for ``ResetView``. This observed
    /// object property holds view model responsible for reset personalization.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var resetViewModel = ResetViewModel()

    /// Access the shared home ViewModel using ``@EnvironmentObject``
    @EnvironmentObject var homeViewModel: HomeViewModel

    /// The `body` property represents the main content and behaviors of the ``ResetView``.
    var body: some View {
        NBTOperationView(
            inputText: .constant(.empty),
            isOperationIconActive: .constant(false), inputTextHint: String.empty,
            title: .appName,
            operationMessage: resetViewModel.message,
            operationIcon: Images.resetIcon.rawValue,
            isInputVisible: false,
            action: {
                resetViewModel.loadDefaultUIState()
            }
        )
        .onAppear {
            // Set on success call back.
            resetViewModel.set(onSuccessCallBack: {
                // Dismiss the current view.
                DispatchQueue.main.asyncAfter(deadline: .now() + NBTPersoConstants.timeDelay) {
                    self.presentationMode.wrappedValue.dismiss()
                    // set the default state message
                    homeViewModel.message = .messageAvailableInteractions
                    // set the  NBT device state as default state.
                    homeViewModel.nbtDeviceState = .defaultState
                }
            })
            // Set default state and
            resetViewModel.loadDefaultUIState()
        }
    }
}

/// Provide previews and sample data for the `BrandProtectionView` during the development process.
#Preview {
    ResetView()
}
