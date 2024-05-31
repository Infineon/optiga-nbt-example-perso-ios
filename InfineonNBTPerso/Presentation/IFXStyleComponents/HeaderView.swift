// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A reusable component representing an header view.
///
///  This component displays an icon, a title, and optional additional content within a VStack.
///  - Parameters:
///   - title: The ``title`` instance representing the title of header
struct HeaderView: View {
    /// The ``title`` property represents the title of header view
    let title: String

    /// The ``body`` property represents the main content and behaviors of the ``HeaderView``.
    var body: some View {
        VStack(spacing: 0, content: {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: StandardPointDimension.largeHeight)
                .foregroundColor(.ocean500)
            ZStack(alignment: .topLeading) {
                Image(Images.headerBackgroundImage.rawValue)
                    .resizable()
                    .fixedSize(horizontal: false, vertical: false)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: StandardPointDimension.headerViewSize,
                        maxHeight: StandardPointDimension.headerViewSize
                    )

                VStack(alignment: .leading) {
                    Text(title)
                        .frame(maxHeight: StandardPointDimension.smallHeight)
                        .font(.heading3)
                        .foregroundColor(.white)
                        .padding(.top, StandardPointDimension.largePadding)

                    HStack {
                        Text(String.subTitleForApp)
                            .font(.headingLight4)
                            .foregroundColor(.white)

                        Spacer()
                        Image(Images.brandLogo.rawValue)
                            .resizable()
                            .renderingMode(.template)
                            .frame(
                                width: StandardPointDimension.ifxLogoWidth,
                                height: StandardPointDimension.mediumHeight
                            )
                            .foregroundColor(.white)
                            .padding(.trailing)
                    }
                }
                .padding(.leading, StandardPointDimension.mediumPadding)
            }
        })
    }
}

/// Provide previews and sample data for the ``HeaderView`` during the development process.
#Preview {
    VStack(spacing: 0) {
        HeaderView(title: .appName).ignoresSafeArea()
        Spacer()
    }
}
