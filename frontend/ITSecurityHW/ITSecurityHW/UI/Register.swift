import SwiftUI
import Combine

struct Register: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var loginViewModel: LoginViewModel
    @State var userName = ""
    @State var password = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            BlueText(text: "Username")
            CustomTextField(placeHolder: "Username", inputValue: self.$userName)
            BlueText(text: "Password")
            CustomSecureTextField(placeHolder: "Password", inputValue: self.$password)
            BlueButton(buttonText: "Register", tapped: {
                loginViewModel.signUp(name: userName, password: password)
            })
        }
        .padding(.horizontal, 25)
        .overlay {
            if !$loginViewModel.isNotLoading.wrappedValue {
                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: 150, height: 150)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
            } else {
                EmptyView()
            }
        }
    }
}
