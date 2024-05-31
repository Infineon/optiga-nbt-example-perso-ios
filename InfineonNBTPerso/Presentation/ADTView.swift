// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view represent asynchronous data transfer personalization screen of mobile phone
/// application
/// for NBT devices.
struct ADTView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation. To be able to call that action, we
    /// need to read the presentation mode from the environment using the ``@Binding`` property
    /// wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Access the shared home ViewModel using ``@EnvironmentObject``
    @EnvironmentObject var homeViewModel: HomeViewModel

    /// An observed object representing the view model for ``ADTView``. This observed object
    /// property holds view model responsible for ADT personalization.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var adtViewModel = ADTViewModel()

    /// The `body` property represents the main content and behaviors of the ``ADTView``.
    var body: some View {
        NBTOperationView(
            inputText: .constant(.empty),
            isOperationIconActive: $adtViewModel.isADTStateConfigSuccess, inputTextHint: .empty,
            title: .appName,
            operationMessage: adtViewModel.message,
            operationIcon: Images.adtGreyIcon.rawValue,
            isInputVisible: false,
            action: {
                adtViewModel.isADTStateConfigSuccess = false
                adtViewModel.message = .messageTapDeviceForADTPersonalize
                adtViewModel
                    .startNFCTagReaderSession(withAlertMessage: adtViewModel.message)
            }
        )
        .onAppear {
            // Set on success call back.
            adtViewModel.set(onSuccessCallBack: {
                // Dismiss the current view.
                DispatchQueue.main
                    .asyncAfter(deadline: .now() + NBTPersoConstants.timeDelay) {
                        self.presentationMode.wrappedValue.dismiss()
                        // set the  NBT device state as personalized.
                        homeViewModel.nbtDeviceState = .useCasePersonalized
                    }
            })
            // Set default state.
            adtViewModel.loadDefaultUIState()
        }
    }
}

/// Provide previews and sample data for the `ADTView` during the development process.
#Preview {
    NavigationView {
        ADTView()
    }
}
