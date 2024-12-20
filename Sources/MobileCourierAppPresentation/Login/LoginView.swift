//
//  LoginView.swift
//  mobile-courier-app
//
//  Created by Vladimir Espinola on 2024-05-04.
//

import SwiftUI

struct LoginView: View {
  public enum Field: Hashable {
    case email
    case password
  }

  @StateObject var viewModel: LoginViewModel
  @FocusState private var focusField: Field?
  @EnvironmentObject var coordinator: Coordinator

  public var body: some View {
    VStack(spacing: 16) {
      Spacer()
      Image("logo", bundle: .module)
        .resizable()
        .renderingMode(.template)
        .foregroundStyle(Color.accent)
        .aspectRatio(contentMode: .fit)
        .padding(.bottom, 16)
        .accessibilityHidden(true)

      TextField("Email", text: $viewModel.email)
        .focused($focusField, equals: .email)
        .textFieldStyle(CourierTextFieldStyle())
        .keyboardType(.emailAddress)
        .autocorrectionDisabled()
        .autocapitalization(.none)
        .submitLabel(.next)
        .onSubmit {
          focusField = .password
        }
        .accessibilityIdentifier(
          AccessibilityIdentifiers.Login.emailTextField
        )
        .accessibilityLabel("Email")

      SecureField("Password", text: $viewModel.password)
        .focused($focusField, equals: .password)
        .textFieldStyle(CourierTextFieldStyle())
        .submitLabel(.done)
        .textContentType(.password)
        .onSubmit {
          navigateToLogin()
        }
        .accessibilityIdentifier(
          AccessibilityIdentifiers.Login.passwordTextField
        )
        .accessibilityLabel("Password")

      Button("Log In") {
        navigateToLogin()
      }
      .frame(maxWidth: .infinity, minHeight: 44)
      .background(
        viewModel.buttonIsEnabled
        ? Color.accent
        : Color.accent.opacity(0.6)
      )
      .foregroundStyle(.white)
      .cornerRadius(16)
      .disabled(!viewModel.buttonIsEnabled)
      .accessibilityIdentifier(
        AccessibilityIdentifiers.Login.loginButton
      )

      Spacer()
    }
    .padding(20)
    .showRippleSpinner(isLoading: $viewModel.isLoading)
    .toast(message: $viewModel.toastMessage)
  }

  private func navigateToLogin() {
    focusField = nil

    Task {
      guard await viewModel.doLogin() else { return }
      coordinator.push(.home)
    }
  }
}

#Preview {
  LoginView(
    viewModel: .previewInstance()
  )
}
