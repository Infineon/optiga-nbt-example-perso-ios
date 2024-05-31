// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view for `OPTIGA™ Authenticate NFC (NBT) - Personalization` use
/// case example of an iOS applications for select personalization operations options.
struct HomeView: View {
    /// An observed object representing the view model for ``HomeView``.  This observed object
    /// property hold ViewModel responsible for NBT personalization operations.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var homeViewModel = HomeViewModel()

    /// Grid layout with three equally-sized columns, both capable of expanding and contracting
    /// based on the available space.
    let gridLayout = [
        GridItem(.flexible(
            minimum: .zero,
            maximum: StandardPointDimension.isSmallDevice ? .infinity : StandardPointDimension
                .gridItemSize
        )),
        GridItem(.flexible(
            minimum: .zero,
            maximum: StandardPointDimension.isSmallDevice ? .infinity : StandardPointDimension
                .gridItemSize
        )),
        GridItem(.flexible(
            minimum: .zero,
            maximum: StandardPointDimension.isSmallDevice ? .infinity : StandardPointDimension
                .gridItemSize
        ))
    ]

    /// The ``body`` property represents the main content and behaviors of the ``HomeView``.
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header View
                HeaderView(title: .appName)
                Spacer()
                // NFC session Message
                Text(homeViewModel.message)
                    .padding(.leading)
                    .padding(.trailing)
                    .multilineTextAlignment(.center)
                    .font(.deviceBody)
                    .foregroundColor(Color.baseBlack)

                // NBT personalization supported operations
                LazyVGrid(
                    columns: gridLayout,
                    spacing: StandardPointDimension.isSmallDevice ? .zero : StandardPointDimension
                        .largePadding
                ) {
                    ForEach(homeViewModel.actionMenu, id: \.self) { action in
                        NavigationLink(destination: action.destination) {
                            ActionMenuItemView(action: action)
                        }
                        .disabled(!action.isActive)
                    }
                }
                .padding(StandardPointDimension.smallPadding)
                Spacer()

                IFXButton(title: .buttonTitleRetry, action: {
                    // Start the NFC session with message to readNBT personalization
                    // capabilities
                    homeViewModel.nbtDeviceState = .unknown
                    homeViewModel.message = String.messageToTapNfcDeviceToCheckCapabilities
                    homeViewModel.startNFCTagReaderSession(
                        withAlertMessage: .messageToTapNfcDeviceToCheckCapabilities
                    )
                })

                Spacer()
                Image(Images.homeScreenBottomImage.rawValue)
                    .resizable()
                    .scaledToFit()
            }
            .navigationBarHidden(true)
            .background(Color.background)
            .onAppear {
                homeViewModel.loadDefaultUIState()
            }.ignoresSafeArea()
        }
        .preferredColorScheme(.light)
        .environmentObject(homeViewModel)
    }
}

/// Provide previews and sample data for the `HomeView` during the development process.
#Preview {
    HomeView()
}

/// Provide previews and sample data for the `HomeView` during the development process.
#Preview {
    HomeView()
}
