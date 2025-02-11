//
//  SettingsViewController.swift
//  PakhisAthlinix
//
//  Created by Vivek Jaglan on 2/11/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var ProfileAvatarOutlet: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        ProfileAvatarOutlet.layer.cornerRadius = ProfileAvatarOutlet.frame.size.width / 2
        ProfileAvatarOutlet.clipsToBounds = true
    }
    @IBAction func handleLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.performLogout()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    private func performLogout() {
        Task { @MainActor in
            do {
                try await supabase.auth.signOut()
                
                // Navigate to Login Screen
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") // Ensure this ID is set in Storyboard
                    let navController = UINavigationController(rootViewController: loginVC)
                    sceneDelegate.window?.rootViewController = navController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            } catch {
                print("Logout failed: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func BackButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let UserVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            UserVC.modalPresentationStyle = .fullScreen
            self.present(UserVC, animated: true, completion: nil)
        } else {
            print("Could not instantiate EditProfileNavViewController")
        }
    }
    
}
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


