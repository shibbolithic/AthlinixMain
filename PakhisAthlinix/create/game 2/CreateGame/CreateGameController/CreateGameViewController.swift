//
//  CreateGameViewController.swift
//  Athlinix
//
//  Created by Vivek Jaglan on 12/30/24.
//

import UIKit

class CreateGameViewController: UIViewController{
    
    
    @IBOutlet weak var GameHeaderViewOutlet: UIView!
    //All the Outlets
    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var yourTeamCollectionView: UICollectionView!
    @IBOutlet weak var yourTeamMembersCollectionView: UICollectionView!
    @IBOutlet weak var addOpponentTeamButton: UIButton!
    @IBOutlet weak var opponentTeamMembersCollectionView: UICollectionView!
    @IBOutlet weak var createButton: UIButton!
    
    
    
    var teams: [TeamTable] = []
    var members: [TeamMembershipTable] = []
    var selectedTeam: TeamTable?
    var selectedOppoTeam: TeamTable?
    var opponentTeam: TeamTable?
    var opponentMembers: [TeamMembershipTable] = []
    var allUsers: [Usertable] = []
    
    
    
    private let teamCellId = "TeamCellCollectionViewCell"
    private let memberCellId = "TeamMemberCellCollectionViewCell"
    private let opponentCellId = "OpponentTeamMemberCellCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTeams()
        setupCollectionViews()
        setupUI()
        //fetchSingleMemberProfile(for: allUsers.userID)
//        if let firstUserID = userIDs.first {
//            fetchSingleMemberProfile(for: firstUserID)
//        }
    }
    
    private func setupUI() {
        GameHeaderViewOutlet.layer.cornerRadius = 25
        addOpponentTeamButton.layer.cornerRadius = 16
    }
    
    private func setupCollectionViews() {
        // Configure collection view delegates and data sources
        let collectionViews = [
            yourTeamCollectionView,
            yourTeamMembersCollectionView,
            opponentTeamMembersCollectionView
        ]
        
        collectionViews.forEach { collectionView in
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
        
        if let layout = yourTeamCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 69, height: 79)
        }
        
        if let layout = opponentTeamMembersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 69, height: 94)
        }
        
        if let layout = yourTeamMembersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 69, height: 94)
        }
    }
    
    @IBAction func opponentTeamButtonTapped(_ sender: Any) {
        // Present modal for selecting opponent team
        
        //open InviteViewController as Modal
//        let vc = InviteViewController()
//            vc.delegate = self
//            present(vc, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let inviteVC = storyboard.instantiateViewController(withIdentifier: "InviteViewController") as? InviteViewController {
                inviteVC.delegate = self
                // Present the ViewController modally
                present(inviteVC, animated: true, completion: nil)
            }

    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard
            validateInputs() else { return }
        createGame()
    }
    //Navigate to Next Screen for adding scores
    
    private func validateInputs() -> Bool {
        guard let gameName = gameNameTextField.text, !gameName.isEmpty else {
            showAlert(message: "Please enter a game name")
            return false
        }
        
        guard let location = locationTextField.text, !location.isEmpty else {
            showAlert(message: "Please enter a location")
            return false
        }
        
        guard selectedTeam != nil else {
            showAlert(message: "Please select your team")
            return false
        }
        
        guard opponentTeam != nil else {
            showAlert(message: "Please add an opponent team")
            return false
        }
        
        return true
    }
    
    private func createGame() {
        // Ensure both teams are selected
        guard let selectedTeam = selectedTeam,
              let opponentTeam = opponentTeam else {
            showAlert(message: "Teams are not properly selected.")
            return
        }
        
        // Instantiate AddMemberDetailsViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addMemberVC = storyboard.instantiateViewController(withIdentifier: "AddMemberDetailsViewController") as? AddMemberDetailsViewController else {
            print("Failed to instantiate AddMemberDetailsViewController")
            return
        }
        
        // Pass data to AddMemberDetailsViewController
        addMemberVC.yourTeam = selectedTeam
        addMemberVC.yourTeamMembers = members
        addMemberVC.opponentTeam = opponentTeam
        addMemberVC.opponentTeamMembers = opponentMembers
        
        // Navigate to AddMemberDetailsViewController
        navigationController?.pushViewController(addMemberVC, animated: true)
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    private func fetchTeams() {
        Task {
            do {
                let response: [TeamTable] = try await supabase
                    .from("teams")
                    .select()
                    .execute()
                    .value
                
                Task { @MainActor in
                    print("Success Data fetched Successfully")
                    self.teams = response
                    self.yourTeamCollectionView.reloadData()
                }
                
            } catch {
                print("Failed to fetch teams: \(error.localizedDescription)")
            }
            
        }
    }
    //MARK: FETCH TEAMS
    private func fetchTeamMembers(for teamID: UUID) {
        Task {
            do {
                let response = try await supabase
                    .from("teamMembership")
                    .select("*")
                    .eq("teamID", value: teamID)
                    .execute()

                let decoder = JSONDecoder()
                members = try decoder.decode([TeamMembershipTable].self, from: response.data)
                
                print(members)
                
                let userIDs = members.map { $0.userID }
                
                print(userIDs)
                
                fetchMemberProfiles(for: userIDs) // Fetch all user profiles at once
                
                // Reload UI on the main thread
                DispatchQueue.main.async {
                    self.yourTeamMembersCollectionView.reloadData()
                }
            } catch {
                print("Error fetching team members: \(error.localizedDescription)")
            }
        }
    }

    
//MARK: FETCH MEMBERS
    private func fetchMemberProfiles(for userIDs: [UUID]) {
        Task {
            do {
                let response = try await supabase
                    .from("User")
                    .select("*")
                    .in("userID", values: userIDs) // Fetch multiple users at once
                    .execute()
                
                print(response)
                
                let decoder = JSONDecoder()
                
                allUsers = try decoder.decode([Usertable].self, from: response.data)
                
                print(allUsers)
                
                // Reload UI on the main thread
                DispatchQueue.main.async {
                    self.yourTeamMembersCollectionView.reloadData()
                }
            } catch {
                print("Error fetching member profiles: \(error.localizedDescription)")
            }
        }
    }

    
//    private func fetchSingleMemberProfile(for userID: UUID) {
//        Task {
//            do {
//                let response: [Usertable] = try await supabase
//                    .from("AthleteProfile")
//                    .select()
//                    .eq("athleteID", value: userID.uuidString)  // Fetch one user
//                    .execute()
//                    .value
//                
//                print("Single Member Profile: \(response)")
//            } catch {
//                print("Failed to fetch a single profile: \(error.localizedDescription)")
//            }
//        }
//    }


    
    private func fetchOpponentMembers(for teamID: UUID) {
        Task {
            do {
                let response = try await supabase
                    .from("teamMembership")
                    .select("*")
                    .eq("teamID", value: teamID)
                    .execute()

                let decoder = JSONDecoder()
                members = try decoder.decode([TeamMembershipTable].self, from: response.data)
                
                self.opponentMembers = members
                
                print("Opponent Team Members: \(response)")
                
                DispatchQueue.main.async {
                    self.opponentTeamMembersCollectionView.reloadData()
                }
            } catch {
                print("Failed to fetch opponent team members: \(error.localizedDescription)")
            }
        }
    }
}

extension CreateGameViewController: InviteDelegate {
    func didSelectTeam(_ team: TeamTable) {
        opponentTeam = team  // Assuming you only want one opponent team
        fetchOpponentMembers(for: team.teamID)
        print("Selected Opponent Team: \(team.teamName)")
    }
}

extension CreateGameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case yourTeamCollectionView:
            print("Number of teams: \(teams.count)")
            return teams.count
        case yourTeamMembersCollectionView:
            return members.count
        case opponentTeamMembersCollectionView:
            print("Opponent Members Count: \(opponentMembers.count)")
            return opponentMembers.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case yourTeamCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teamCellId, for: indexPath) as! TeamCellCollectionViewCell
            let team = teams[indexPath.row]
            print("Configuring cell for team: \(team.teamName)")
            cell.configure(with: teams[indexPath.row])
            return cell
            
        case yourTeamMembersCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memberCellId, for: indexPath) as! TeamMemberCellCollectionViewCell
            cell.configure(with: members[indexPath.row], users: allUsers)
            return cell
            
        case opponentTeamMembersCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: opponentCellId, for: indexPath) as! OpponentTeamMemberCellCollectionViewCell
            let member = opponentMembers[indexPath.row]
            cell.configure(with: member, users: allUsers)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == yourTeamCollectionView {
            
            selectedTeam = teams[indexPath.row]
            // You might want to fetch members for the selected team here
            // fetchTeamMembers(for: selectedTeam)
            print("selected team: \(String(describing: selectedTeam))")
            selectedTeam = teams[indexPath.row]
            guard let teamID = selectedTeam?.teamID else { return }
            fetchTeamMembers(for: teamID)
            
        } else if collectionView == opponentTeamMembersCollectionView {
            // Handle selection of opponent team members
            
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
    
    
}
