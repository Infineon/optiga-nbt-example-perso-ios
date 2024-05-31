// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view reusable component representing an action menu item view.
///
///  This component displays an icon, a title, and optional additional content within a VStack.
///  - Parameters:
///   - action: The ``ActionMenu`` instance representing the action menu item.
struct ActionMenuItemView: View {
    /// Instance of action menu item use to hold the name and title with state of menu etc.
    /// information.
    let action: ActionMenu

    /// The `body` property represents the main content and behaviors of the ``ActionMenuItemView``.
    var body: some View {
        VStack {
            // Display Action menu only if title is not empty
            if action.title != .empty {
                Image(action.icon)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: StandardPointDimension.isSmallDevice ? StandardPointDimension
                            .extraSmallImageSize : StandardPointDimension.smallImageSize,
                        height: StandardPointDimension.isSmallDevice ? StandardPointDimension
                            .extraSmallImageSize : StandardPointDimension.smallImageSize
                    )
                    .foregroundColor(action.isActive ? Color.ocean500 : Color.engineering200)
                Text(action.title)
                    .font(.deviceBody)
                    .multilineTextAlignment(.center)
                    .foregroundColor(action.isActive ? Color.baseBlack : Color.engineering300)
            }
        }
        .padding(StandardPointDimension.largePadding)
    }
}

/// Provide previews and sample data for the `ActionMenuItemView` during the development process.
#Preview {
    VStack {
        ActionMenuItemView(action: ActionMenu(
            title: .hintInactiveButton,
            icon: Images.adtGreyIcon.rawValue,
            destination: AnyView(Text(verbatim: .empty)),
            isActive: false
        ))
    }
}
