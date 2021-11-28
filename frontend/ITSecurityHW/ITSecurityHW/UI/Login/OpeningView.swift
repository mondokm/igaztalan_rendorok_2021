//
//  Navigation.swift
//  ITSecurityHW
//
//  Created by Geza Konczos on 2021. 11. 27..
//

import SwiftUI

struct OpeningView: View {
    @EnvironmentObject var appState: AppState
    @State var loginViewModel = LoginViewModel()
    @State var index = 0
    @Namespace var name

    var body: some View {
        ScrollView {
            VStack {
                Image("itSec")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 180)

                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            index = 0
                        }
                    }) {
                        VStack {
                            Text("Login")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(index == 0 ? Color(UIColor(named: "titleColor")!) : .gray)
                            ZStack {
                                Capsule()
                                    .fill(Color.black.opacity(0.04))
                                    .frame(height: 4)
                                if index == 0 {
                                    Capsule()
                                        .fill(Color.accentColor)
                                        .frame(height: 4)
                                        .matchedGeometryEffect(id: "Tab", in: name)
                                }
                            }
                        }
                    }

                    Button(action: {
                        withAnimation(.spring()) {
                            index = 1
                        }
                    }) {
                        VStack {
                            Text("Register")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(index == 1 ? Color(UIColor(named: "titleColor")!) : .gray)

                            ZStack {
                                Capsule()
                                    .fill(Color.black.opacity(0.04))
                                    .frame(height: 4)
                                if index == 1 {
                                    Capsule()
                                        .fill(Color.accentColor)
                                        .frame(height: 4)
                                        .matchedGeometryEffect(id: "Tab", in: name)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 30)
                if index == 0 {
                    Login(loginViewModel: loginViewModel).environmentObject(appState)
                } else if index == 1 {
                    Register(loginViewModel: loginViewModel)
                        .environmentObject(appState)
                }
            }
            .padding(.top, 50)
        }
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView()
    }
}
