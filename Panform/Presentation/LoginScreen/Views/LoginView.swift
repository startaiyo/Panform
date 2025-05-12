//
//  LoginView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/30.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    @State private var isSignUpShow = false

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Panform")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.skyBlue)
                    .padding()
                VStack {
                    TextField("email",
                              text: $viewModel.email)
                        .frame(height: 30)
                    TextField("password",
                              text: $viewModel.password)
                        .frame(height: 30)
                }
                    .padding()
                    .background(.lightGray)
                    .cornerRadius(5)
                    .padding()
                Button {
                    viewModel.login()
                } label: {
                    Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundStyle(.white)
                }
                    .frame(width: 140,
                           height:40)
                    .background(Color.darkPink)
                    .cornerRadius(30)
                    .padding()

                HStack {
                    Text("still not user?")
                    Button {
                        isSignUpShow.toggle()
                    } label: {
                        Text("please sign in")
                    }
                }
                Spacer()
            }
            .frame(width: 360,
                   height: 460)
            .background(Color.creme.opacity(0.9))
            .cornerRadius(30)
            .padding()
            
        }
        .background(
            Image("loginBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
        )
        .fullScreenCover(isPresented: $isSignUpShow) {
            SignUpView(viewModel: viewModel.signUpViewModel)
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(authNetworkService: AuthNetworkService.shared, onLoginSuccess: {}))
}
