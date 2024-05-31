// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import Security

/// Utility class for working with X509 certificate (.pem) files.
enum CertUtils {
    /// Reads the contents of a file with the given name and type from the app bundle.
    ///
    /// - Parameter forResource: The name of the file to read.
    /// - Parameter ofType: The file extension of the file to read.
    ///
    /// - Returns: The contents of the file as a string.
    ///
    /// - Throws: If the file could not be found or read, an error is thrown.
    public static func readFile(forResource: String, ofType: String) throws -> String {
        guard let filepath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
            throw CertificateError(
                description: "Failed to find the file '\(forResource).\(ofType)' in the app bundle."
            )
        }
        let contents = try String(contentsOfFile: filepath)
        return contents
    }

    /// Parses a X509 certificate from a string.
    ///
    /// - Parameter certString: A string representation of the X509 certificate.
    ///
    /// - Returns: The parsed X509 certificate as a `Data` object.
    ///
    /// - Throws: If the X509 certificate string is invalid or could not be parsed, an error is
    /// thrown.
    public static func parseCert(from certString: String) throws -> Data {
        // Remove delimiters and whitespace from the input string
        let cert = certString
            .replacingOccurrences(of: "-----BEGIN CERTIFICATE-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "-----END CERTIFICATE-----", with: "")

        // Decode the Base64-encoded X509 certificate string
        guard let decodedData = Data(base64Encoded: cert) else {
            throw CertificateError(description: "Failed to decode X509 certificate")
        }
        // Create a SecCertificateRef object from the decoded data
        guard let certificate = SecCertificateCreateWithData(nil, decodedData as CFData) else {
            throw CertificateError(
                description: "Failed to create X509 certificate from decoded data"
            )
        }
        // Convert the certificate to a Data object and return it
        return SecCertificateCopyData(certificate) as Data
    }

    /// Parses an Elliptic Curve private key from a string.
    ///
    /// - Parameter ecKeyfromFile: A string representation of the Elliptic Curve private key.
    ///
    /// - Returns: The parsed key as a `Data` object.
    ///
    /// - Throws: If the input string is invalid or could not be parsed, an error is thrown.
    public static func parseEcKey(from ecKeyfromFile: String) throws -> Data {
        // Remove delimiters and whitespace from the input string
        let ecKey = ecKeyfromFile.replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")

        // Convert the ec key from base64 to a byte array
        guard Data(base64Encoded: ecKey) != nil else {
            throw CertificateError(description: "Failed to decode base64 string: \(ecKey)")
        }
        // Note: Need to implement Parse the EC private key from the file contents for
        // now we have return static EC-Key
        return Data([
            0x3A, 0x31, 0xAE, 0xE7, 0x0E, 0x5E, 0xB5, 0xFD,
            0xDE, 0x06, 0xB3, 0xBC, 0x83, 0x73, 0x3E, 0x32,
            0xDA, 0xAE, 0x7F, 0x1D, 0xA3, 0x97, 0x31, 0xE5,
            0xC1, 0x44, 0x40, 0xF3, 0xC4, 0x3E, 0x92, 0xB5
        ])
    }

    /// Retrieves a certificate from a file with the specified name and type, and parses it into a
    /// `Data` object.
    ///
    /// - Parameter resourceName: The name of the resource file containing the X509 certificate.
    /// - Parameter resourceType: The file type of the resource file containing the X509
    /// certificate.
    ///
    /// - Returns: The parsed X509 certificate as a `Data` object.
    ///
    /// - Throws: If the resource file cannot be read or the X509 certificate cannot be parsed, an
    /// error
    /// is thrown.
    public static func getCertificate(
        fromResource resourceName: String,
        ofType resourceType: String
    ) throws -> Data {
        // Read the contents of the resource file into a string
        let fileContent = try CertUtils.readFile(forResource: resourceName, ofType: resourceType)

        // Parse the X509 certificate from the file contents & Return the parsed X509 certificate
        // data
        return try CertUtils.parseCert(from: fileContent)
    }

    /// Retrieves an Elliptic Curve private key from a file with the specified name and type, and
    /// parses it into a `Data` object.
    ///
    /// - Parameter resourceName: The name of the resource file containing the key.
    /// - Parameter resourceType: The file type of the resource file containing the key.
    ///
    /// - Returns: The parsed key as a `Data` object.
    ///
    /// - Throws: If the resource file cannot be read or the key cannot be parsed, an error is
    /// thrown.
    public static func getECPrivateKey(
        fromResource resourceName: String,
        ofType resourceType: String
    ) throws -> Data {
        // Read the contents of the resource file into a string
        let fileContent = try CertUtils.readFile(forResource: resourceName, ofType: resourceType)
        // & Return the parsed private key data
        return try CertUtils.parseEcKey(from: fileContent)
    }
}
