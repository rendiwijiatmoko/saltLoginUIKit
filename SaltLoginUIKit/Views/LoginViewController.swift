//
//  LoginViewController.swift
//  SaltLoginUIKit
//
//  Created by Rendi Wijiatmoko on 18/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Variable Properties
    var viewModel: LoginViewModel = LoginViewModel()
    
    // MARK: - UI Component
    private let activeIndicator = UIActivityIndicatorView()
    private let headerView = LoginHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    private let loginErrorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Error"
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.placeholder = "Password"
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
        bindData()
        setupButton()
        setDelegates()
        activeIndicatorUI()
        
        self.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // MARK: - Header Login
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ),
            headerView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // MARK: - Form Login
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 55),
            emailTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            passwordTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
        ])
        
        // MARK: - Submit Button Login
        self.view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 48),
            loginButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
        ])
        
        // MARK: - Label Error
        self.view.addSubview(loginErrorDescriptionLabel)
        loginErrorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginErrorDescriptionLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            loginErrorDescriptionLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor),
            loginErrorDescriptionLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)
        ])
    }
    
    // MARK: - Functions
    func bindData() {
        viewModel.isLoading.bind { loading in
            if loading {
                self.activeIndicator.startAnimating()
            } else {
                self.activeIndicator.stopAnimating()
            }
        }
        viewModel.isLogin.bind { success in
            if success {
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
            }
        }
        
        viewModel.credentialsInputErrorMessage.bind { [weak self] in
            self?.loginErrorDescriptionLabel.isHidden = false
            self?.loginErrorDescriptionLabel.text = $0
        }
        
        viewModel.isEmailTextFieldHighLighted.bind { [weak self] in
            if $0 { self?.highlightTextField(self!.emailTextField)}
        }
        
        viewModel.isPasswordTextFieldHighLighted.bind { [weak self] in
            if $0 { self?.highlightTextField(self!.passwordTextField)}
        }
        
        viewModel.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Warning",
                                          message: "\(errorMessage)",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { _ in
                self.viewModel.isLoading.value = false
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupButton() {
        loginButton.layer.cornerRadius = 5
    }
    
    func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func activeIndicatorUI() {
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        activeIndicator.center = self.view.center
        activeIndicator.style = UIActivityIndicatorView.Style.large
        activeIndicator.hidesWhenStopped = true
        
        container.addSubview(activeIndicator)
        self.view.addSubview(container)
    }
    
    func highlightTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 3
    }
    
    // MARK: - Selectors
    @objc private func loginButtonPressed() {
        viewModel.updateCredentials(email: emailTextField.text!, password: passwordTextField.text!)
        
        switch viewModel.credentialsInput() {
        case .Correct :
            viewModel.login()
        case .Incorrect:
            return
        }
    }
}

//MARK: - Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginErrorDescriptionLabel.isHidden = true
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
