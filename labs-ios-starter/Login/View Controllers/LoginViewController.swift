//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class LoginViewController: DefaultViewController {
    // MARK: - Outlets -
    @IBOutlet weak var signInButton: UIButton!

    // MARK: - Properties -
    let userTextField = UITextField()
    let profileController = ProfileController.shared

    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Add observers
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationSuccessful,
                                               object: nil,
                                               queue: .main,
                                               using: checkForExistingProfile)
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationExpired,
                                               object: nil,
                                               queue: .main,
                                               using: alertUserOfExpiredCredentials)

        UIApplication.shared.open(ProfileController.shared.oktaAuth.identityAuthURL()!) { result in

        }
        
    }
    
    // MARK: - Actions
    @IBAction func signIn(_ sender: Any) {

    }
    
    // MARK: - Private Methods -
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(with: "Your Okta credentials have expired",
                                    message: "Please sign in again",
                                    preferredStyle: .alert,
                                    dismissText: "Dimiss")
        }
    }
    
    // MARK: - Notification Handling -
    private func checkForExistingProfile(with notification: Notification) {
        checkForExistingProfile()
    }
    
    private func checkForExistingProfile() {
        profileController.checkForExistingAuthenticatedUserProfile { [weak self] (exists) in
            
            guard let self = self,
                self.presentedViewController == nil else { return }
                
            if exists {
                self.handleLogin()
            } else {
                print("not logged in")
                //self.performSegue(withIdentifier: .getSegueID(.modalAddProfile), sender: nil)
            }
        }
    }

    func handleLogin() {
        
    }
    
    @objc func reportTextFieldText() {
        guard let text = self.userTextField.text,
        text != "" else {
            print("invalid or empty text")
            return
        }
        self.presentSimpleAlert(with: "Textfield", message: text, preferredStyle: .alert, dismissText: "Go away")
    }

}

// MARK: - Live Previews -
#if DEBUG

import SwiftUI

struct LoginViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        return viewController?.view.livePreview.edgesIgnoringSafeArea(.all)
    }
}

#endif
