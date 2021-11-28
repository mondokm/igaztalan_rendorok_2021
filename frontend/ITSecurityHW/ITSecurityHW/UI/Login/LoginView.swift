//
//  LoginView.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @State var base64Content = ""
    @State var isFilePickerShowing = true

    var body: some View {
        NavigationView {
            VStack {
                Text($loginViewModel.author.wrappedValue?.name ?? "")
                Text(base64Content)
                    .padding()
                AnimatedImage(base64: $loginViewModel.image)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding()
                NavigationLink(destination: MainView(mainViewModel: MainViewModel())) {
                    Text("Login")
                }
            }
            .sheet(isPresented: $isFilePickerShowing, content: {
                DocumentPicker(base64Content: $base64Content)
            })
        }
        .onAppear {
            let randomName = UUID().uuidString
            let imageName = UUID().uuidString
            let keywords = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString]
            let password = "tesztJelszo"
            print("name: \(randomName)")
            let caff1 = readCaffFile(nameWithoutExtension: "3")!
            loginViewModel.signUp(name: randomName, password: password) {
                loginViewModel.login(name: randomName, password: password) {
                    loginViewModel.upload(name: imageName, keywords: keywords, image: caff1) {
                        loginViewModel.refreshImages {
                            loginViewModel.search(searchTerm: keywords.first!) {
                            }
                        }
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel())
    }
}
