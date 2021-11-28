import SwiftUI
import Combine

struct Login: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var loginViewModel: LoginViewModel
    @State var password: String = ""
    @State var userName: String = ""

    var body: some View {
        VStack {
            UsernameAndPassword(userName: $userName, password: $password)
                .padding(20)
            BlueButton(buttonText: "Login") {
                loginViewModel.login(name: userName, password: password)
            }
        }
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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(loginViewModel: LoginViewModel())
    }
}
