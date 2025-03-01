//
//  AddTeamViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 06/01/25.
//

import UIKit

class AddTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var teamLogo: UIImageView!
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamMotto: UITextField!
    
    @IBOutlet weak var addCoachButton: UIButton!
    @IBOutlet weak var addMemberButton: UIButton!
    
    @IBOutlet weak var coachCollectionView: UICollectionView!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    @IBOutlet weak var createButton: UIButton!
    
    var selectedCoaches: [Usertable] = []
    var selectedMembers: [Usertable] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                coachCollectionView.dataSource = self
                coachCollectionView.delegate = self
                memberCollectionView.delegate = self
                memberCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(teamLogoTapped))
           teamLogo.isUserInteractionEnabled = true
           teamLogo.addGestureRecognizer(tapGesture)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        setupBackButton()

    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    // Back button action
    @objc private func backButtonTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
           if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
               
               let transition = CATransition()
                      transition.duration = 0.3
                      transition.type = .push
                      transition.subtype = .fromLeft  // This makes it slide in from the left
                      view.window?.layer.add(transition, forKey: kCATransition)
               
               // Present the AddTeamViewController
               homeVC.modalPresentationStyle = .fullScreen // or .overFullScreen if you want a different style
               self.present(homeVC, animated: true, completion: nil)
           } else {
               print("Could not instantiate AddTeamViewController")
           }
    }
    
    @objc private func createButtonTapped() {
        Task {
            guard let name = teamName.text, !name.isEmpty,
                  let motto = teamMotto.text, !motto.isEmpty else {
                // Show error if required fields are empty
                showAlert(message: "Please enter a team name and motto.")
                return
            }
            
            // Ensure session user is set
            guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                showAlert(message: "Error: No session user is set.")
                return
            }

            let teamLogoName = teamLogo.accessibilityIdentifier ?? "defaultLogo" // Replace with actual logic
            let newTeamID = UUID()
            let currentDateString = ISO8601DateFormatter().string(from: Date())

            // Create the team
            let newTeam = TeamTable(
                teamID: newTeamID,
                dateCreated: currentDateString,
                teamName: name,
                teamMotto: motto,
                teamLogo: teamLogoName,
                createdBy: sessionUserID // Using sessionUserID
            )

            do {
                // Insert the team into Supabase
                try await supabase
                    .from("teams")
                    .insert(newTeam)
                    .execute()

                // Insert coaches and members into TeamMembershipTable
                try await insertTeamMemberships(teamID: newTeamID, users: selectedCoaches, role: .coach)
                try await insertTeamMemberships(teamID: newTeamID, users: selectedMembers, role: .athlete)

                // Notify success and dismiss
                showAlert1(message: "Team created successfully!") { [weak self] in
                    guard let self = self else { return }
                    
                    // Dismiss the current modal first
                    self.presentingViewController?.dismiss(animated: true) {
                        // Navigate to MainTabBarController
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
                            homeVC.modalPresentationStyle = .fullScreen
                            UIApplication.shared.keyWindow?.rootViewController = homeVC
                        } else {
                            print("Could not instantiate MainTabBarController")
                        }
                    }
                }
                
            } catch {
                // Handle errors
                showAlert(message: "Failed to create the team: \(error)")
                print(error)
            }
        }
    }

       
       private func insertTeamMemberships(teamID: UUID, users: [Usertable], role: Role) async throws {
           let currentDateString = ISO8601DateFormatter().string(from: Date())
           
           let memberships = users.map { user in
               TeamMembershipTable(
                   membershipID: UUID(),
                   teamID: teamID,
                   userID: user.userID,
                   roleInTeam: role,
                   dateJoined: currentDateString
               )
           }
           
           // Insert memberships into Supabase
           try await supabase
               .from("teamMembership")
               .insert(memberships)
               .execute()
       }
       
       private func showAlert(message: String) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           self.present(alert, animated: true)
       }
    
    func showAlert1(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

    
    
    // MARK: - Athletes Collection View
    @IBAction func addCoachButtonTapped(_ sender: UIButton) {
            let addCoachVC = AddCoachViewController()
            addCoachVC.delegate = self
            let navController = UINavigationController(rootViewController: addCoachVC)
            self.present(navController, animated: true)
        }
    
    @objc private func teamLogoTapped() {
        let logoSelectionVC = LogoSelectionViewController()
        logoSelectionVC.delegate = self
        let navController = UINavigationController(rootViewController: logoSelectionVC)
        self.present(navController, animated: true)
    }

    
    func updateCoachCollectionView() {
        DispatchQueue.main.async {
            self.coachCollectionView.reloadData()
        }
    }
    @IBAction func addMemberButtonTapped(_ sender: UIButton) {
            let addMemberVC = AddMemberViewController()
            addMemberVC.delegate = self
            let navController = UINavigationController(rootViewController: addMemberVC)
            self.present(navController, animated: true)
        }

    
    func updateMemberCollectionView() {
        DispatchQueue.main.async {
            self.memberCollectionView.reloadData()
        }
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coachCollectionView {
            return selectedCoaches.count
        } else if collectionView == memberCollectionView {
            return selectedMembers.count
        }
        return 0    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == coachCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedCoachesCollectionViewCell", for: indexPath) as! AddedCoachesCollectionViewCell
            let coach = selectedCoaches[indexPath.row]
            cell.configure(with: coach)
            return cell }
        else if collectionView == memberCollectionView {
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedMembersCollectionViewCell", for: indexPath) as! AddedMemberssCollectionViewCell
                   let member = selectedMembers[indexPath.row]
                   cell.configure(with: member)
                   return cell
               }
        return UICollectionViewCell()

    }
    
}

// Protocol for communication
extension AddTeamViewController: AddCoachDelegate {
    func didSelectCoaches(_ coaches: [Usertable]) {
        self.selectedCoaches = coaches
        self.updateCoachCollectionView()
    }
}

extension AddTeamViewController: AddMemberDelegate {
    func didSelectMembers(_ members: [Usertable]) {
        self.selectedMembers = members
        self.updateMemberCollectionView()
    }
}

extension AddTeamViewController: LogoSelectionDelegate {
    func didSelectLogo(named logoName: String) {
        teamLogo.image = UIImage(named: logoName)
        teamLogo.accessibilityIdentifier = logoName
        print(teamLogo.accessibilityIdentifier)
        
    }
}



