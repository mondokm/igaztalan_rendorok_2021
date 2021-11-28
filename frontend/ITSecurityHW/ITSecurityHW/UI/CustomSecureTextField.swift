import SwiftUI
import Combine

struct CustomSecureTextField: View {
    var placeHolder = "MyPlaceholder"
    @Binding var inputValue: String

    var body: some View {
        SecureField(placeHolder, text: $inputValue)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: -5)
    }
}

struct CustomSecureTextField_Previews: PreviewProvider {
    @State static var value = ""
    static var previews: some View {
        CustomSecureTextField(inputValue: $value)
    }
}
