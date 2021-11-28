import SwiftUI

struct CustomTextField: View {
    var placeHolder = "MyPlaceholder"
    @Binding var inputValue: String

    var body: some View {
        TextField(placeHolder, text: $inputValue)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: -5)
    }
}

struct TextField_Previews: PreviewProvider {
    @State static var value = ""
    static var previews: some View {
        CustomTextField(inputValue: $value)
    }
}
