//
//  SignUpViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 03/02/25.
//

import UIKit
import Auth

class SignUpViewController: UIViewController {

    @IBOutlet weak var googleButtonOutlet: UIButton!
    @IBOutlet weak var appleButtonOutlet: UIButton!
    @IBOutlet weak var nameTFOutlet: UITextField!
    @IBOutlet weak var hidePasswordBtnOutlet: UIButton!
    @IBOutlet weak var passwordTFOutlet: UITextField!
    @IBOutlet weak var emailTFOutlet: UITextField!
    
    @IBOutlet weak var fullNameStack: UIStackView!
    
    @IBOutlet weak var emailStack: UIStackView!
    
    @IBOutlet weak var passwordStack: UIStackView!
    @IBAction func handleLoginWithGoogle(_ sender: Any) {
    }
    
    @IBAction func handleLoginWithApple(_ sender: Any) {
    }
    
    
    //actions
    @IBAction func handleHidePassword(_ sender: Any) {
    }
    @IBAction func handleRegister(_ sender: Any) {
            guard let name = nameTFOutlet.text,
                  let email = emailTFOutlet.text,
                  let password = passwordTFOutlet.text else {
                showAlert(title: "Signup Error", message: "Please fill all fields")
                return
            }
            
            showLoadingIndicator()
            
            Task {
                do {
                    let signUpResult = try await signUp(email: email, password: password, fullName: name)
                    
                    print("Signup Success id: \(signUpResult.id)")
                    
                    // Getting current timestamp in ISO 8601 format
                    let currentDate = ISO8601DateFormatter().string(from: Date())
                    
                    // Creating user data to store in Supabase
                    let userData = Usertable(
                        userID: UUID(),
                        createdAt: currentDate,
                        username: email.components(separatedBy: "@").first ?? "unknown",
                        name: name,
                        email: email,
                        password: password,  // Consider hashing passwords before storing
                        profilePicture: nil,
                        coverPicture: nil,
                        bio: nil,
                        dateJoined: currentDate,
                        lastLogin: currentDate,
                        role: .athlete  // Change to .coach if required
                    )
                    
                    // Inserting data into the Supabase User table
                    let response = try await supabase
                        .from("User")
                        .insert(userData)
                        .execute()
                    
                    print("Insert status: \(response.status)")
                    
                    await MainActor.run {
                        hideLoadingIndicator()
                        showAlert(title: "Signup Success", message: "You have successfully Registered to Athlinix")
                        performSegue(withIdentifier: "NavigateToLogin", sender: nil)
                        
                    }
                } catch {
                    await MainActor.run {
                        hideLoadingIndicator()
                        showAlert(title: "Exception", message: error.localizedDescription)
                    }
                }
            }
        }

    @IBAction func handleRegisterWithGoogle(_ sender: Any) {
    }
    @IBAction func handleRegisterWithApple(_ sender: Any) {
    }
    
    func showAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
    }
    
    func hideLoadingIndicator() {
        self.view.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func signUp(email: String, password: String, fullName: String) async throws-> User{
        let auth = try await supabase.auth.signUp(email: email, password: password, data: ["display_name": .string(fullName)] )
        return auth.user
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
        let buttons = [googleButtonOutlet, appleButtonOutlet]
        buttons.forEach {
            $0?.layer.cornerRadius = 15
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        let inputBoxes = [fullNameStack, emailStack, passwordStack]
        inputBoxes.forEach {
            $0?.layer.cornerRadius = 15
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
