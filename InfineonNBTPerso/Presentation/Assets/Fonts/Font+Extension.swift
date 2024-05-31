// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// An extension of the Font type that defines the font suggested by Infineon
/// Digital Design System for Display, Headings & Paragraph.
extension Font {
    // MARK: - Heading - Headings are above a paragraph, topic section or picture.

    /// The IFX font (SourceSans3-SemiBold, 28pt) heading3 used are above a
    /// paragraph, topic section or picture.
    static let heading3 = Font.custom("SourceSans3-SemiBold", size: 28)

    /// The IFX font (SourceSans3-SemiBold, 24pt) heading4 used are above a
    /// paragraph, topic section or picture.
    static let heading4 = Font.custom("SourceSans3-SemiBold", size: 20)

    /// The IFX font (SourceSans3-Light, 24pt) headingLight4 used are above a
    /// paragraph, topic section or picture.
    static let headingLight4 = Font.custom("SourceSansPro-Light", size: 20)

    // MARK: - Body - Paragraphs.

    /// The IFX font (SourceSans3-SemiBold, 18pt) body2SemiBold used for paragraph.
    static let body2SemiBold = Font.custom("SourceSans3-SemiBold", size: 18)

    /// The IFX font (SourceSans3-Regular, 16pt) body3 used for paragraph.
    static let body3 = Font.custom("SourceSans3-Regular", size: 16)

    /// The IFX font (SourceSans3-Regular, 16pt) body4 used for paragraph on small device.
    static let body4 = Font.custom("SourceSans3-Regular", size: 14)

    static var deviceBody: Font {
        if StandardPointDimension.isSmallDevice { // Check for iPhone SE width
            return .body4 // Set appropriate font size for iPhone SE
        } else {
            return .body3 // Set appropriate font size for other iPhone models
        }
    }
}
