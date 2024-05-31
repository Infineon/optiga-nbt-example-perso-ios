// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view that represent the button according to IFX theme
struct IFXButton: View {
    /// Enum defines the type of button according to IFX theme
    enum ButtonType {
        /// Define the primary button
        case primary

        /// Define the secondary button with border
        case secondary

        /// Define the secondary button with no border
        case tertiary

        /// Define the danger button
        case danger
    }

    /// Holder for the title of button
    let title: String

    /// Holder for the left side icon image name
    let leftIcon: String

    /// Holder for the right side icon image name
    let rightIcon: String

    /// Holder for the button type
    let variant: ButtonType

    /// Holder for call back action
    let action: () -> Void

    /// Holder for the button type
    var isEnabled: Bool = true

    /// Initializer for IFXButton
    ///
    ///  - Parameters:
    ///   - title: String defines the tile for button, default value is ``Button``
    ///   - leftICon: String defines the eft side icon image name, default value is empty
    ///   - rightICon: String defines the eft side icon image name, default value is empty
    ///   - variant: Enum defines the type of button according to IFX theme, default value is
    /// `primary`
    ///   - action: Defines the call back action for button
    ///
    public init(
        title: String = .buttonTitleDefault,
        leftIcon: String = .empty,
        rightIcon: String = .empty,
        variant: ButtonType = .primary,
        action: @escaping () -> Void,
        isEnabled: Bool = true
    ) {
        self.title = title
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.variant = variant
        self.action = action
        self.isEnabled = isEnabled
    }

    /// The `body` property represents the main content and behaviors of the `IFXButton`.
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                if leftIcon != .empty {
                    Image(leftIcon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(
                            width: StandardPointDimension.extraSmallWidth,
                            height: StandardPointDimension.extraSmallHeight
                        )
                        .foregroundColor(
                            variant == .danger || variant == .primary ? Color
                                .white : Color.ocean500
                        )
                }

                Text(verbatim: title)
                    .foregroundColor(
                        variant == .danger || variant == .primary ? Color.white : Color
                            .ocean500
                    )
                    .font(.body3)

                if rightIcon != .empty {
                    Image(rightIcon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(
                            width: StandardPointDimension.extraSmallWidth,
                            height: StandardPointDimension.extraSmallHeight
                        )
                        .foregroundColor(
                            variant == .danger || variant == .primary ? Color
                                .white : Color.ocean500
                        )
                }
            }
            .frame(
                width: StandardPointDimension.mediumButtonWidth,
                height: StandardPointDimension.largeHeight
            )
            .padding(.horizontal, StandardPointDimension.largePadding)
        }
        .background(
            isEnabled ?
                (
                    variant == .danger ? Color.red : variant == .primary ? Color.ocean500 : Color
                        .white
                ) :
                Color.gray
        )
        .cornerRadius(StandardPointDimension.standardInsetSize)
        .overlay(
            Rectangle()
                .stroke(
                    isEnabled ? (variant == .danger ? Color.red : Color.ocean500) : Color.gray,
                    lineWidth: StandardPointDimension.onePixelWidth
                )
        )
    }
}

/// Provide previews and sample data for the ``IFXButton`` during the development process.
#Preview {
    VStack {
        ///  Default button
        IFXButton(action: {}, isEnabled: false)

        ///  Primary button with `title` `leftIcon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftIcon: Images.bluetoothIcon.rawValue,
            action: {}
        )

        ///  Primary button with `title` ,`leftIcon`, `rightICon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftIcon: Images.bluetoothIcon.rawValue,
            rightIcon: Images.bluetoothIcon.rawValue,
            action: {}
        )

        ///  Secondary button with `title`  and `action`
        IFXButton(variant: .secondary, action: {})

        ///  Secondary button with `title`, `leftIcon`  and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftIcon: Images.bluetoothIcon.rawValue,
            variant: .secondary,
            action: {}
        )

        ///  Secondary button with `title`, `leftIcon`,  `rightICon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftIcon: Images.bluetoothIcon.rawValue,
            rightIcon: Images.bluetoothIcon.rawValue,
            variant: .secondary,
            action: {}
        )

        ///  Danger  button with `title` and `action`
        IFXButton(variant: .danger, action: {})

        ///  Danger  button with `title`, `leftIcon`  and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftIcon: Images.bluetoothIcon.rawValue,
            variant: .danger,
            action: {}
        )

        ///  Danger  button with `title`, `leftIcon`,  `rightICon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftIcon: Images.bluetoothIcon.rawValue,
            rightIcon: Images.bluetoothIcon.rawValue,
            variant: .danger,
            action: {}
        )

        ///  Button on OceanDark background
        VStack {
            IFXButton(variant: .tertiary, action: {})
            IFXButton(
                title: .buttonTitleDefault,
                leftIcon: Images.bluetoothIcon.rawValue,
                variant: .tertiary,
                action: {}
            )
            IFXButton(
                title: .buttonTitleDefault,
                leftIcon: Images.bluetoothIcon.rawValue,
                rightIcon: Images.bluetoothIcon.rawValue,
                variant: .tertiary,
                action: {}
            )

            IFXButton(variant: .danger, action: {})
            IFXButton(
                title: .buttonTitleDefault,
                leftIcon: Images.bluetoothIcon.rawValue,
                variant: .danger,
                action: {}
            )

            ///  Danger  button with `title`, `leftIcon`,  `rightICon` and `action`
            IFXButton(
                title: .buttonTitleDefault,
                leftIcon: Images.bluetoothIcon.rawValue,
                rightIcon: Images.bluetoothIcon.rawValue,
                variant: .danger,
                action: {}
            )
        }
        .padding(StandardPointDimension.largePadding)
        .background(Color.ocean500)
    }
}
