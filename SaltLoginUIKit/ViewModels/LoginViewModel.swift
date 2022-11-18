//
//  LoginViewModel.swift
//  SaltLoginUIKit
//
//  Created by Rendi Wijiatmoko on 18/11/22.
//

import Foundation
import UIKit

class LoginViewModel {
    // MARK: - Stored Properties
    private let service: APIService = APIService()
    
    private var credentials = CredentialModel() {
        didSet {
            email = credentials.email
            password = credentials.password
        }
    }
    
    private var email = ""
    private var password = ""
    
    var credentialsInputErrorMessage: Observable<String> = Observable("")
    var isEmailTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    var isLogin: Observable<Bool> = Observable(false)
    var isLoading: Observable<Bool> = Observable(false)
    
    func updateCredentials(email: String, password: String, otp: String? = nil) {
        credentials.email = email
        credentials.password = password
    }
    
    
    func login() {
        self.isLoading.value = true
        service.signin(modelRequest: credentials) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(_):
                    self.isLogin.value = true
                case .failure(_):
                    self.errorMessage.value = "user not found"
                }
                self.isLoading.value = false
            }
        }
    }
    
    
    func credentialsInput() -> CredentialsInputStatus {
        if email.isEmpty && password.isEmpty {
            credentialsInputErrorMessage.value = "Please provide email and password."
            return .Incorrect
        }
        if email.isEmpty {
            credentialsInputErrorMessage.value = "email field is empty."
            isEmailTextFieldHighLighted.value = true
            return .Incorrect
        }
        if password.isEmpty {
            credentialsInputErrorMessage.value = "Password field is empty."
            isPasswordTextFieldHighLighted.value = true
            return .Incorrect
        }
        return .Correct
    }
}

extension LoginViewModel {
    enum CredentialsInputStatus {
        case Correct
        case Incorrect
    }
}
