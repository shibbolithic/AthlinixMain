//
//  AddGameViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 09/01/25.
//

import UIKit

class AddGameViewController: UIViewController {
  
    
    var teams11:[TeamTable] = []
    
    @IBOutlet weak var gameName: UITextField!
    @IBOutlet weak var gameVenue: UITextField!
    @IBOutlet weak var playersTeamCollectionView: UICollectionView!
    
    @IBOutlet weak var opponentTeamTextView: UITextField!
    @IBOutlet weak var opponentTeamLogoImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            if let sessionUserID = await SessionManager.shared.getSessionUser() {
                fetchTeamsForUserSupabase(userID: sessionUserID)
            }
        }
        
        playersTeamCollectionView.delegate = self
        playersTeamCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    //MARK: Fetch memberships for the current user
    func fetchTeamsForUserSupabase(userID: UUID?) {
        guard let userID = userID else {
            print("User ID is nil")
            return
        }
        
        Task {
            do {
                let membershipsResponse = try await supabase
                    .from("teamMembership")
                    .select("*")
                    .eq("userID", value: userID.uuidString)
                    .execute()
                
                let decoder = JSONDecoder()
                let memberships = try decoder.decode([TeamMembershipTable].self, from: membershipsResponse.data)
                
                // Extract teamIDs from memberships
                let teamIDs = memberships.map { $0.teamID.uuidString }
                
                // Fetch teams matching the teamIDs
                let teamsResponse = try await supabase
                    .from("teams")
                    .select("*")
                    .in("teamID", values: teamIDs)
                    .execute()
                
                let teams2 = try decoder.decode([TeamTable].self, from: teamsResponse.data)
                
                print("Teams for user: \(teams2)")
                
                // Handle the fetched teams (update UI, etc.)
                teams11 = teams2
                playersTeamCollectionView.reloadData()
            } catch {
                print("Error fetching teams: \(error)")
            }
        }
    }

    

}

extension AddGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams11.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerTeamCell", for: indexPath) as! PlayerTeamCollectionViewCell
        cell.configure(with: teams11[indexPath.row])
        return cell
    }
}
