//
//  AdministratorView.swift
//  ITSecurityHW
//
//  Created by Geza Konczos on 2021. 12. 02..
//

import SwiftUI

struct AdministratorView: View {
    @StateObject var administratorViewModel: AdministratorViewModel
    @State var userId = ""
    @State var userName = ""
    @State var password = ""

    var body: some View {
        VStack {
            TextField("User ID", text: $userId)
                .padding()
            TextField("Username", text: $userName)
                .padding()
            SecureField("Password", text: $password)
                .padding()
            Button("Change") {
                administratorViewModel.change(id: Int(userId) ?? -1, name: userName, password: password)
            }
            .padding()

            Button {
                administratorViewModel.delete(id: Int(userId) ?? -1)
            } label: {
                Image(systemName: "trash")
            }
            .padding()

        }
        .overlay {
            if !$administratorViewModel.isNotLoading.wrappedValue {
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

struct AdministratorView_Previews: PreviewProvider {
    static var previews: some View {
        AdministratorView(administratorViewModel: AdministratorViewModel())
    }
}
