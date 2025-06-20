//
//  AuthorContoller.swift
//  CoreDataUIKit
//
//  Created by 李嘉魁 on 2025/6/19.
//
import UIKit
import SnapKit
import AuthenticationServices

class AuthorContoller: UIViewController {
    private var publicPlanButton: UIButton = {
        var configuration = UIButton.Configuration.borderedTinted()
        configuration.image = UIImage(systemName: "1.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0))
        configuration.title = "点击开始"
        configuration.subtitle = ""
        configuration.imagePadding = 8.0
        configuration.titlePadding = 4.0
        configuration.cornerStyle = .large
        configuration.buttonSize = .large
        
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)

            return outgoing
        })
        
        let button = UIButton(configuration: configuration)
        button.tintColor = UIColor.systemCyan
        // button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(publicPlanButton)
        publicPlanButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        publicPlanButton.addTarget(self, action: #selector(showPublicPlanPicker), for: .touchUpInside)
    }
    
    @objc
    func showPublicPlanPicker() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AuthorContoller : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("错误")
        print("Authorization failed: \(error)")
                if let authError = error as? ASAuthorizationError {
                    switch authError.code {
                    case .canceled:
                        // 用户取消授权
                        print("User canceled authorization")
                        // 不需要显示错误，用户主动取消
                        return
                    case .failed:
                        print("Authorization failed")
                    case .invalidResponse:
                        print("Invalid response")
                    case .notHandled:
                        print("Not handled")
                    case .unknown:
                        print("Unknown error")
                    default:
                        print("Unknown authorization error")
                    }
                }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("ok")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
            KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
            KeychainItem.currentUserEmail = appleIDCredential.email
            
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            
            //Show Home View Controller
            // HomeViewController.Push()
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            print("empty")
        }
    }
}

extension AuthorContoller : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
