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
    
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    
    
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
        
        let selectedRole: Role = (roleSegmentedControl.selectedSegmentIndex == 0) ? .athlete : .coach
        
        showLoadingIndicator()
        
        Task {
            do {
                let signUpResult = try await signUp(email: email, password: password, fullName: name)
                print("Signup Success id: \(signUpResult.id)")
                
                let currentDate = ISO8601DateFormatter().string(from: Date())
                
                let userData = Usertable(
                    userID: signUpResult.id,
                    createdAt: currentDate,
                    username: email.components(separatedBy: "@").first ?? "unknown",
                    name: name,
                    email: email,
                    password: password,
                    profilePicture: "person.circle",
                    coverPicture: nil,
                    bio: nil,
                    dateJoined: currentDate,
                    lastLogin: currentDate,
                    role: selectedRole
                )
                
                let response = try await supabase
                    .from("User")
                    .insert(userData)
                    .execute()
                
                print("Insert status: \(response.status)")
                
                if selectedRole == .athlete {
                    let athleteData = AthleteProfileTable(
                        athleteID: signUpResult.id,
                        height: 0,
                        weight: 0,
                        experience: 0,
                        position: .center,
                        averagePointsPerGame: 0,
                        averageReboundsPerGame: 0,
                        averageAssistsPerGame: 0
                    )
                    
                    let response1 = try await supabase
                        .from("AthleteProfile")
                        .insert(athleteData)
                        .execute()
                    
                    print("Athlete Profile Insert status: \(response1.status)")
                }
                
                await MainActor.run {
                    hideLoadingIndicator()
                    transitionToHomeScreen()
                    showAlert(title: "Signup Success", message: "You have successfully registered to Athlinix")
                }
                
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    showAlert(title: "Exception", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func transitionToHomeScreen() {
        guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") else {
            fatalError("MainTabBarController not found in storyboard")
        }
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
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
}
