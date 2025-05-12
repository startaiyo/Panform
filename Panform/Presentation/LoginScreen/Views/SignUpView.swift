//
//  SignUpView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss

    init(viewModel: SignUpViewModel) {
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
                    TextField("name",
                              text: $viewModel.name)
                        .frame(height: 30)
                    TextField("email",
                              text: $viewModel.email)
                        .frame(height: 30)
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
                    viewModel.signUp {
                        dismiss()
                    }
                } label: {
                    Text("Sign Up")
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
        Button(action: {
            dismiss()
        }) {
            Text("Cancel")
                .font(.subheadline)
                .padding(10)
        }
        .foregroundColor(.primary)
        .background(Color.white.opacity(0.7))
        .cornerRadius(10)
        .padding()
    }
}
