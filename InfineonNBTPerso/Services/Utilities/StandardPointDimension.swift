// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import UIKit

/// A collection of standard point sizes used for padding, margin, height, width, and more.
public enum StandardPointDimension {
    // MARK: - Paddings

    /// The point size for small padding.
    static let smallPadding: CGFloat = 4

    /// The point size for medium padding.
    static let mediumPadding: CGFloat = 8

    /// The point size for large padding.
    static let largePadding: CGFloat = 16

    /// The point size for extra large padding.
    static let extraLargePadding: CGFloat = 24

    // MARK: - Margins

    /// The point size for small margin.
    static let smallMargin: CGFloat = 4

    /// The point size for medium margin.
    static let mediumMargin: CGFloat = 8

    /// The point size for large margin.
    static let largeMargin: CGFloat = 16

    /// The point size for extra large margin.
    static let extraLargeMargin: CGFloat = 24

    // MARK: - Heights

    /// The point size for small height.
    static let extraSmallHeight: CGFloat = 16

    /// The point size for small height.
    static let smallHeight: CGFloat = 24

    /// The point size for medium height.
    static let mediumHeight: CGFloat = 32

    /// The point size for large height.
    static let largeHeight: CGFloat = 48

    /// The point size for extra large height.
    static let extraLargeHeight: CGFloat = 64

    /// The height value for 1 pixels.
    static let onePixelHeight: CGFloat = 1.0

    /// The height value for 4 pixels.
    static let fourPixelHeight: CGFloat = 4.0

    /// The height value for 42 pixels.
    static let editTextHeight: CGFloat = 42

    // MARK: - Widths

    /// The point size for small width.
    static let extraSmallWidth: CGFloat = 16

    /// The point size for small width.
    static let smallWidth: CGFloat = 24

    /// The point size for medium width.
    static let mediumWidth: CGFloat = 32

    /// The point size for large width.
    static let largeWidth: CGFloat = 48

    /// The point size for extra large width.
    static let extraLargeWidth: CGFloat = 64

    /// The width value for 12 pixels.
    static let twelvePixelWidth: CGFloat = 12.0

    /// The width value for 1 pixels.
    static let onePixelWidth: CGFloat = 1.0

    /// The size of a infineon icon width in pixels.
    static let ifxLogoWidth: CGFloat = 80.0

    // MARK: - Button Widths

    /// The size of a small button width in pixels.
    static let smallButtonWidth: CGFloat = 100.0

    /// The size of a medium button width in pixels.
    static let mediumButtonWidth: CGFloat = 140.0

    // MARK: - Sizes

    /// The size of a medium button width in pixels.
    static let infineonIconWidth: CGFloat = 145.6

    /// Represents the size of header view.
    static let headerViewSize: CGFloat = 150

    /// The size of a small image in pixels.
    static let smallImageSize: CGFloat = 60.0

    /// The size of a small image in pixels.
    static let extraSmallImageSize: CGFloat = 40.0

    /// The size of a operation image in pixels.
    static let operationImageSize: CGFloat = 80.0

    /// The size of grid Item for small screen size in pixels.
    static let gridItemSize: CGFloat = 150

    /// The point size for small border width.
    static let smallBorderSize: CGFloat = 1

    /// The point size for standard border radius.
    static let standardBorderRadiusSize: CGFloat = 1

    /// The point size for standard Inset.
    static let standardInsetSize: CGFloat = 1

    static var isSmallDevice: Bool {
        if UIScreen.main.bounds.width <= 380 { // Check for iPhone SE width
            return true // for iPhone SE
        } else {
            return false // for other iPhone models
        }
    }
}
