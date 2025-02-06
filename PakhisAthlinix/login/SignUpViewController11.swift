////
////  SignUpViewControlelr.swift
////  PakhisAthlinix
////
////  Created by admin65 on 21/12/24.
////
//
//import UIKit
////
//class SignUpViewController: UIViewController{
//    
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var LoginButton: UIButton!
//
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            setupUI()
//        }
//
//        private func setupUI() {
//            LoginButton.layer.cornerRadius = 8
//            LoginButton.addTarget(self, action: #selector(loginButtonTapped1), for: .touchUpInside)
//        }
//    
//    @IBAction func loginButtonTapped1(_ sender: UIButton) {
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else {
//            showAlert(title: "Error", message: "Please enter both email and password.")
//            return
//        }
//
//        Task {
//            await loginUser(email: email, password: password)
//        }
//    }
//    
//
//        private func loginUser(email: String, password: String) async {
//            do {
//                // Query the database for the user with the given email
//                let userResponse = try await supabase
//                    .from("User")
//                    .select("*")
//                    .eq("email", value: email)
//                    .single()
//                    .execute()
//                
//                let userDecoder = JSONDecoder()
//                let fetchedUser = try userDecoder.decode(Usertable.self, from: userResponse.data)
//
//                // Verify the password
//                if fetchedUser.password == password {
//                    // Navigate to the next screen
//                    DispatchQueue.main.async {
//                        self.navigateToHomeScreen(user: fetchedUser)
//                    }
//                } else {
//                    // Invalid password
//                    DispatchQueue.main.async {
//                        self.showAlert(title: "Error", message: "Invalid email or password.")
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.showAlert(title: "Error", message: "Unable to log in. Please check your credentials.")
//                }
//                print("Login error: \(error)")
//            }
//        }
//
//        private func navigateToHomeScreen(user: Usertable) {
//            sessionuser = user.userID
//            // Example: Navigate to the home screen and pass the user object
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
//                //homeViewController.loggedInUser = user
//                navigationController?.pushViewController(homeViewController, animated: true)
//            }
//        }
//
//        private func showAlert(title: String, message: String) {
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
//    }
//
//
