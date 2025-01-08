//
//  createteamViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 01/01/25.
//

import UIKit
struct temporyteamname: Codable, Equatable{
    var tempteamID: UUID
    var playerID: UUID
    var Name: String
    var Motto: String
}


class createteamViewController: UIViewController {

        // IBOutlet connected to the UITextField in the storyboard
        @IBOutlet weak var userInputTextField: UITextField!
        
    @IBOutlet weak var userInputTeamMotto: UITextField!
    var userInput: String? // Variable to save user input
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        @IBAction func saveInputTapped(_ sender: UIButton) {
            guard let teamName = userInputTextField.text,
                  !teamName.isEmpty else {
                        print("Text field is empty")
                        return
                    }
            guard let teamMotto = userInputTeamMotto.text,
                  !teamMotto.isEmpty else {
                        print("Text field is empty")
                        return
                    }
                    
            Task {
                do {
                    // Ensure session user is set
                    guard let sessionUserID = SessionManager.shared.getSessionUser() else {
                        print("Error: No session user is set")
                        return
                    }

                    // Create an instance of the struct with the input data
                    let newTeam = temporyteamname(
                        tempteamID: UUID(),
                        playerID: sessionUserID, // Using sessionUserID
                        Name: teamName,
                        Motto: teamMotto
                    )

                    // Insert data into Supabase
                    try await supabase
                        .from("TemporaryTeam")
                        .insert(newTeam)
                        .execute()

                    print("Team successfully added: \(teamName)")
                } catch {
                    print("Error inserting data into Supabase: \(error)")
                }
            }

        }
    }

