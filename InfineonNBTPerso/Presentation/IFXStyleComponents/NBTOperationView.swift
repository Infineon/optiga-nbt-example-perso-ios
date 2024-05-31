// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view to the used for different NBT operation use case
struct NBTOperationView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation. To be able to call that action, we
    /// need to read the presentation mode from the environment using the ``@Binding`` property
    /// wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Represents the text input entered by the user.
    @Binding public var inputText: String

    /// Indicates whether a icon or image used in the user interface is active/inactive.
    @Binding public var isOperationIconActive: Bool

    /// Represents the text input entered by the user.
    public var inputTextHint: String

    /// Represents the title displayed in the user interface.
    public var title: String

    /// Represents a message associated with a specific operation to be perform.
    public var operationMessage: String

    /// Represents the name or identifier of an icon or image used in the user interface.
    public var operationIcon: String

    /// Indicates whether a User input specific UI element is visible or hidden.
    public var isInputVisible: Bool

    /// Represents a message associated with a specific input operation to be perform.
    public var inputMessage: String = .empty

    /// Represents a title for button default is set to Retry
    public var buttonTitle: String = .buttonTitleRetry

    /// Represents a state of button
    public var isRetryButtonActive: Bool = true

    /// Optional holder for call back action
    public var action: (() -> Void)?

    ///  Restrict the use to enter only HEX string if it set
    public var isHexInputEnable = false

    /// The ``body`` property represents the main content and behaviors of the ``NbtOperationView``.
    var body: some View {
        VStack(spacing: 0) {
            // Header view
            HeaderView(title: title)

            // Operation message
            Text(operationMessage)
                .font(.body3)
                .foregroundColor(Color.baseBlack)
                .padding(.leading)
                .padding(.trailing)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: StandardPointDimension.extraLargeHeight)

            // User Input UI elements
            if isInputVisible {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(inputMessage)
                        .font(.body2SemiBold)
                        .foregroundColor(Color.baseBlack)

                    TextField(inputTextHint, text: $inputText)
                        .autocapitalization(.allCharacters)
                        .frame(
                            minWidth: .zero,
                            maxHeight: StandardPointDimension.editTextHeight
                        )
                        .onChange(of: inputText, perform: { newValue in
                            if isHexInputEnable {
                                inputText = extractHexString(input: newValue)
                                if newValue.count > NBTPersoConstants.bluetoothMacAddressSize {
                                    inputText = String(
                                        newValue
                                            .prefix(NBTPersoConstants.bluetoothMacAddressSize)
                                    )
                                }
                            }
                        })

                    // Add a border at the bottom
                    Rectangle()
                        .frame(height: StandardPointDimension.onePixelHeight)
                        .background(Color.gray)
                }
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
            }
            Spacer()

            // Operation icon or image
            Image(operationIcon)
                .resizable()
                .renderingMode(.template)
                .frame(
                    width: StandardPointDimension.operationImageSize,
                    height: StandardPointDimension.operationImageSize
                )
                .foregroundColor(isOperationIconActive ? Color.ocean500 : Color.gray)
            Spacer()
            if let callback = action {
                IFXButton(title: buttonTitle, action: callback, isEnabled: isRetryButtonActive)
                    .disabled(!isRetryButtonActive)
            }
            Spacer()

            // Back or Cancel button
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(Images.closeIcon.rawValue)
                    .resizable()
                    .frame(
                        width: StandardPointDimension.smallImageSize,
                        height: StandardPointDimension.smallImageSize
                    )
                    .foregroundColor(Color.ocean500)
                    .padding(StandardPointDimension.extraLargePadding)
            })
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

    func extractHexString(input: String) -> String {
        let hexCharacterSet = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
        let hexString = input.components(separatedBy: hexCharacterSet).joined()
        return hexString
    }
}

/// Provide previews and sample data for the ``NBTOperationView`` during the development process.
#Preview {
    NBTOperationView(
        inputText: .constant(.empty),
        isOperationIconActive: .constant(true), inputTextHint: .defaultCottLink,
        title: .appName,
        operationMessage: .MessageTapDeviceForBPPersonalize,
        operationIcon: Images.certifiedIcon.rawValue,
        isInputVisible: true,
        inputMessage: .lableCottServerEditText
    )
}
