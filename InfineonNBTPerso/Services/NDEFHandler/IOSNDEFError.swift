// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Exception class for NDEF message and NDEF record related exception.
public class IOSNDEFError: Error {
    /// The error description.
    public var localizedDescription: String
    public let underlyingError: Swift.Error?

    /// Creates a new Certificate Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        localizedDescription = description
        underlyingError = nil
    }

    /// Constructs an exception with the exception message and exception stack.
    ///
    /// - Parameters:
    ///   - message: Message for the exception.
    ///   - exception: Exception stack.
    ///
    public init(
        description: String,
        exception: Error
    ) {
        localizedDescription = description
        underlyingError = exception
    }
}
