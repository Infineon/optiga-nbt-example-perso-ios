// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// The entry point of the NBT's personalization mobile phone application.
/// The iOS application demonstrates how to personalize the NBT via NFC
///
/// This ``InfineonNBTPersoApp`` struct conforms to the `App` SwiftUI protocol and serves as the
/// main entry point of the iOS application.
///
/// Usage:
/// - Use the `@main` attribute to mark this struct as the entry point of the app.
/// - The struct defines the `body` property, which represents the root of the app's view
///   hierarchy.
/// - The `body` property returns a `Scene` that contains the main window of the app.
/// - The main window is created using the `WindowGroup` scene type.
/// - The content of the main window is set to an instance of the ``SplashScreenView`` view.
@main
struct InfineonNBTPersoApp: App {
    /// The body of the SwiftUI app scene.
    ///
    /// The `body` property represents the root of the app's view hierarchy and defines the content
    /// of the app scene.
    ///
    /// Usage:
    /// - The `body` property is a computed property that returns a `Scene` type.
    /// - It is used to define the structure and content of the app scene.
    /// - The `some Scene` syntax indicates an opaque result type, allowing flexibility in returning
    /// different types conforming to the `Scene` protocol.
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .top) {
                SplashScreenView()
            }
        }
    }
}
