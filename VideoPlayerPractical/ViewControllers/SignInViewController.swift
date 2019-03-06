//
//  SignInViewController.swift
//  VideoPlayerPractical
//
//  Created by Muvi on 04/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var showNextPage: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    var signInButton = GIDSignInButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        signInButton.center = view.center
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            self.signInButton.isHidden = true
            self.signOutButton.isHidden = false
            self.showNextPage.isHidden = false
        }
        else {
            self.signInButton.isHidden = false
            self.signOutButton.isHidden = true
            self.showNextPage.isHidden = true
        }
    }
    
    @objc func signInTapped() {
    }
    @IBAction func signOutTapped(_ sender: Any) {
        signOut()
    }
    @IBAction func nextPageTapped(_ sender: UIButton) {
        self.goToHomePage()
    }
    
    func goToHomePage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homePageVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        self.navigationController?.pushViewController(homePageVC, animated: false)
    }
}

extension SignInViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            else {
                self.signInButton.isHidden = true
                self.signOutButton.isHidden = false
                self.showNextPage.isHidden = false
                self.goToHomePage()
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.signInButton.isHidden = false
            self.signOutButton.isHidden = true
            self.showNextPage.isHidden = true
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
