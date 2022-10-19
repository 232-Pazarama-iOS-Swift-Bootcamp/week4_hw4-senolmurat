//
//  AuthViewController.swift
//  Crypto App
//
//  Created by Pazarama iOS Bootcamp on 9.10.2022.
//

import UIKit
import Toast

final class AuthViewController: UIViewController {
    
    enum AuthType: String {
        case signIn = "Sign In"
        case signUp = "Sign Up"
        
        init(text: String) {
            switch text {
            case "Sign In":
                self = .signIn
            case "Sign Up":
                self = .signUp
            default:
                self = .signIn
            }
        }
    }
    
    var authType: AuthType = .signIn {
        didSet {
            titleLabel.text = authType.rawValue
            confirmButton.setTitle(authType.rawValue, for: .normal)
            usernameTextField.isHidden = authType != .signUp // should be hidden in signIn
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var credentionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Auth"
        viewModel.delegate = self
        
        self.showLoadingIndicator()
        viewModel.fetchRemoteConfig { isSignUpDisabled in
            self.segmentedControl.isHidden = isSignUpDisabled
            self.dismissLoadingIndicator()
        }
    }
    
    @IBAction private func didTapLoginButton(_ sender: UIButton) {
        guard let credential = credentionTextField.text,
              let password = passwordTextField.text else {
            return
        }
        switch authType {
        case .signIn:
            viewModel.signIn(credential, password)
        case .signUp:
            guard let username = usernameTextField.text else {return}
            viewModel.signUp(credential, password, username: username)
        }
    }
    
    @IBAction private func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        let authTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        authType = AuthType(text: authTitle ?? "Sign In")
    }
}

extension AuthViewController: AuthDelegate {
    func didErrorOccurred(_ error: Error) {
        AlertManager.showInfoAlertBox(for: error as NSError, in: self, handler: nil)
    }
    
    func didSignedUp() {
        self.view.makeToast("Signed up Successfully...", duration: 3.0, position: .bottom)
        //AlertManager.showInfoAlertBox(with: "Signed up Successfully...", errorTitle: "Success", in: self, handler: nil)
    }
    
    func didSignedIn() {
        if let recentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController{
            recentViewController.modalPresentationStyle = .fullScreen
            self.present(recentViewController, animated: true)
        }
    }
    
    
}
