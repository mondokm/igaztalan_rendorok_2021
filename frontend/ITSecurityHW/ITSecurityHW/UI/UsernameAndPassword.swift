import SwiftUI

struct UsernameAndPassword: View {
    @Binding var userName: String
    @Binding var password: String

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            BlueText(text: "Username")
            CustomTextField(placeHolder: "Username", inputValue: $userName)
            BlueText(text: "Password")
            CustomSecureTextField(placeHolder: "Password", inputValue: $password)
        }
        .padding(.top, 25)
    }
}

struct UsernameAndPassword_Previews: PreviewProvider {
    @State static var value1 = ""
    @State static var value2 = ""
    static var previews: some View {
        UsernameAndPassword(userName: $value1, password: $value2)
    }
}
