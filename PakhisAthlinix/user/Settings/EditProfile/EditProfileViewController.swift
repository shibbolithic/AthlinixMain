//
//  EditProfileViewController.swift
//  PakhisAthlinix
//
//  Created by Vivek Jaglan on 2/11/25.
//

import UIKit

class EditProfileViewController: UIViewController {


    //@IBOutlet weak var PositionDropDownOutlet: UIMenu!
    
    @IBOutlet weak var positionDropDownOutlet: UIButton!
    
    @IBOutlet weak var ExperienceTFOutlet: UITextField!
    @IBOutlet weak var WeightTFOutlet: UITextField!
    @IBOutlet weak var fullNameOutlet: UITextField!
    @IBOutlet weak var heightTFOutlet: UITextField!
    @IBOutlet weak var ProfileAvatarOutlet: UIImageView!
    
    var selectedPosition: positions?  // Store selected position
       
       override func viewDidLoad() {
           super.viewDidLoad()
           Task {
               await fetchUserData()
           }
           setupPositionDropdown()
       }
       
       // MARK: - Fetch User Data from Supabase
    
       private func fetchUserData() async {
           do {
               if let sessionUserID = await SessionManager.shared.getSessionUser() {
                   let userResponse: [Usertable] = try await supabase
                       .from("User")
                       .select()
                       .eq("userID", value: sessionUserID)
                       .execute()
                       .value
                   
                   let athleteResponse: [AthleteProfileTable] = try await supabase
                       .from("AthleteProfile")
                       .select()
                       .eq("athleteID", value: sessionUserID)
                       .execute()
                       .value
                   
                   if let user = userResponse.first {
                       fullNameOutlet.text = user.name
                   }
                   
                   if let athlete = athleteResponse.first {
                       heightTFOutlet.text = "\(athlete.height)"
                       WeightTFOutlet.text = "\(athlete.weight)"
                       ExperienceTFOutlet.text = "\(athlete.experience)"
                       selectedPosition = athlete.position
                       positionDropDownOutlet.setTitle(athlete.position.rawValue, for: .normal)
                   }
               }
           } catch {
               print("Error fetching user data: \(error)")
           }
       }
       
       // MARK: - Setup Position Dropdown
    
       private func setupPositionDropdown() {
           let menuItems = positions.allCases.map { position in
               UIAction(title: position.rawValue, handler: { _ in
                   self.selectedPosition = position
                   self.positionDropDownOutlet.setTitle(position.rawValue, for: .normal)
               })
           }
           positionDropDownOutlet.menu = UIMenu(title: "Select Position", options: .displayInline, children: menuItems)
           positionDropDownOutlet.showsMenuAsPrimaryAction = true
       }



    // MARK: - Update User Data in Supabase
    
    private func updateUserData() async {
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else { return }

        // Trim spaces and convert text to appropriate data types
        let heightText = heightTFOutlet.text?.trimmingCharacters(in: .whitespaces)
        let heightValue = Float(heightText ?? "") ?? 0.0
        
        let weightText = WeightTFOutlet.text?.trimmingCharacters(in: .whitespaces)
        let weightValue = Float(weightText ?? "") ?? 0.0
        
        let experienceText = ExperienceTFOutlet.text?.trimmingCharacters(in: .whitespaces)
        let experienceValue = Int(experienceText ?? "") ?? 0  // Convert to Int8
        
        let fullNameText = fullNameOutlet.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        print("Updating with height: \(heightValue), weight: \(weightValue), experience: \(experienceValue), name: \(fullNameText), position: \(selectedPosition?.rawValue ?? "None")")

        do {
            // Update the 'User' table (for name)
            try await supabase.from("User")
                .update([
                    "name": fullNameText
                ])
                .eq("userID", value: sessionUserID)
                .execute()

            // Update the 'AthleteProfile' table (for experience, height, weight, and position)
            try await supabase.from("AthleteProfile")
                .update([
                    "height": heightValue as Float,
                    "weight": weightValue as Float,
                    "experience": Float(experienceValue) as Float,
                ])
                .eq("athleteID", value: sessionUserID)
                .execute()
            
            try await supabase.from("AthleteProfile")
                .update([
                    "position": selectedPosition?.rawValue ?? ""
                ])
                .eq("athleteID", value: sessionUserID)
                .execute()

            print("Profile updated successfully!")
            
        } catch {
            print("Error updating profile: \(error)")
        }
    }



    
    // MARK: - Handle Save Button
    
    @IBAction func handleSave(_ sender: Any) {
        Task{
            await updateUserData()
            
            NotificationCenter.default.post(name: NSNotification.Name("profileUpdated"), object: nil)
            
            showAlert(title: "Success", message: "Your profile has been updated successfully.")
                    
            
            if let presentingVC = presentingViewController?.presentingViewController {
                presentingVC.dismiss(animated: true, completion: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }

    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
