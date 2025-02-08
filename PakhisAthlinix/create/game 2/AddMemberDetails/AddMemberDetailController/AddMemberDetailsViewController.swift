//
//  AddMemberDetailsViewController.swift
//  Athlinix
//
//  Created by Vivek Jaglan on 1/7/25.
//

import UIKit
import Supabase

class AddMemberDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var yourTeam: TeamTable?
    var yourTeamMembers: [TeamMembershipTable] = []
    var opponentTeam: TeamTable?
    var opponentTeamMembers: [TeamMembershipTable] = []

    @IBOutlet weak var undoButtonContainer: UIView!
    @IBOutlet weak var team2score: UILabel!
    @IBOutlet weak var team1score: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var actionButtons: [UIButton]!
    @IBOutlet weak var teamName2Label: UILabel!
    @IBOutlet weak var teamName1Label: UILabel!
    @IBOutlet weak var teamLogo2: UIImageView!
    @IBOutlet weak var teamLogo1: UIImageView!
    
    private lazy var undoButton: UIButton = {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
            let image = UIImage(systemName: "arrow.uturn.backward.circle.fill", withConfiguration: config)
            button.setImage(image, for: .normal)
            button.setTitle("Undo", for: .normal) // Adding text label
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .white
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(undoLastAction), for: .touchUpInside)
            button.isEnabled = false
            return button
        }()
    
    private var lastAction: Action?
        private var lastHighlightedIndexPath: IndexPath?
        private let highlightDuration: TimeInterval = 1.0
    
    
    private func setupUndoButton() {
            // Add to view hierarchy
        undoButtonContainer.addSubview(undoButton)
            
            // Setup constraints - position next to the action buttons
        NSLayoutConstraint.activate([
            undoButton.centerXAnchor.constraint(equalTo: undoButtonContainer.centerXAnchor),
            undoButton.centerYAnchor.constraint(equalTo: undoButtonContainer.centerYAnchor),
            undoButton.heightAnchor.constraint(equalTo: undoButtonContainer.heightAnchor, multiplier: 0.7), // 70% of container height
            undoButton.widthAnchor.constraint(equalTo: undoButtonContainer.widthAnchor, multiplier: 0.5)  // 50% of container width
                ])
        }
    
    @objc private func undoLastAction() {
            guard let action = lastAction else { return }
            
            scoreUpdateQueue.sync {
                // Revert player stats
                if action.team == .team1 {
                    team1.players[action.indexPath.row] = action.previousState
                    team1Score -= action.scoreChange
                } else {
                    team2.players[action.indexPath.row] = action.previousState
                    team2Score -= action.scoreChange
                }
                
                // Clear the last action
                lastAction = nil
                updateUndoButtonState()
                
                DispatchQueue.main.async { [weak self] in
                                self?.tableView.reloadData()
                                self?.updateHeaderUI()
                            }
            }
        }
    
    private func updateUndoButtonState() {
            DispatchQueue.main.async { [weak self] in
                self?.undoButton.isEnabled = self?.lastAction != nil
                self?.undoButton.alpha = self?.lastAction != nil ? 1.0 : 0.5
            }
        }
    
    private struct Action {
            let player: Player
            let previousState: Player
            let team: TeamIdentifier
            let indexPath: IndexPath
            let scoreChange: Int
        }
    
    var team1Score = 0
    var team2Score = 0
    
    var team1 = Team(name: "Lakers", players: [
        Player(name: "Player 1", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 2", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 3", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 4", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 5", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0)
    ])
    
    var team2 = Team(name: "Raptors", players: [
        Player(name: "Player 1", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 2", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 3", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 4", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0),
        Player(name: "Player 5", reb: 0, ast: 0, stl: 0, foul: 0, pts: 0)
    ])
    
    var selectedAction: String?
    
    private var team1AnimationLabel: UILabel?
    private var team2AnimationLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        setupUndoButton()
        setupAnimationLabels()
        
        // Populate team1 and team2 with actual data
        initializeTeams()
        
        // Update the UI with the passed data
        updateHeaderUI()
        
    }
    //MARK: ANIMATIONS

    private func setupAnimationLabels() {
           // Setup floating animation label for team 1
           team1AnimationLabel = UILabel()
           team1AnimationLabel?.textAlignment = .center
           team1AnimationLabel?.font = .boldSystemFont(ofSize: 24)
           team1AnimationLabel?.textColor = .systemGreen
           team1AnimationLabel?.alpha = 0
           view.addSubview(team1AnimationLabel!)
           
           // Setup floating animation label for team 2
           team2AnimationLabel = UILabel()
           team2AnimationLabel?.textAlignment = .center
           team2AnimationLabel?.font = .boldSystemFont(ofSize: 24)
           team2AnimationLabel?.textColor = .systemGreen
           team2AnimationLabel?.alpha = 0
           view.addSubview(team2AnimationLabel!)
       }
    private func animateScoreUpdate(for team: TeamIdentifier, points: Int) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let animationLabel = team == .team1 ? self.team1AnimationLabel : self.team2AnimationLabel
                let scoreLabel = team == .team1 ? self.team1score : self.team2score
                
                guard let startFrame = scoreLabel?.frame else { return }
                
                // Configure animation label
                animationLabel?.text = "+\(points)"
                animationLabel?.frame = startFrame
                animationLabel?.alpha = 1
                
                // Scale up the score label briefly
                scoreLabel?.transform = .identity
                UIView.animate(withDuration: 0.3, animations: {
                    scoreLabel?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                }) { _ in
                    UIView.animate(withDuration: 0.1) {
                        scoreLabel?.transform = .identity
                    }
                }
                
                // Animate the floating score
                UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
                    // Move up and fade out
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
                        animationLabel?.frame = startFrame.offsetBy(dx: 0, dy: -70)
                        animationLabel?.alpha = 0.8
                    }
                    
                    // Complete fade out
                    UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                        animationLabel?.alpha = 0
                    }
                }) { _ in
                    // Reset the animation label position
                    animationLabel?.frame = startFrame
                }
            }
        }
    
//MARK: INTIALIZE TEAMS
    private var userNames: [UUID: String] = [:] // Dictionary to store userID -> player name mapping

    private func initializeTeams() {
        Task {
            do {
                // Fetch all team members
                let allMembers: [TeamMembershipTable] = try await supabase
                    .from("teamMembership")
                    .select()
                    .execute()
                    .value
                
                // Extract all userIDs
                let userIDs = allMembers.map { $0.userID }

                // Fetch users in a single query
                let users: [Usertable] = try await supabase
                    .from("User")
                    .select()
                    .in("userID", values: userIDs)
                    .execute()
                    .value
                
                // Create a dictionary of userID -> name
                for user in users {
                    userNames[user.userID] = user.name
                }

                // Assign team members to respective teams
                if let yourTeamID = yourTeam?.teamID {
                    yourTeamMembers = allMembers.filter { $0.teamID == yourTeamID }
                    team1 = Team(name: yourTeam?.teamName ?? "Team 1", players: mapMembersToPlayers(yourTeamMembers))
                }
                
                if let opponentTeamID = opponentTeam?.teamID {
                    opponentTeamMembers = allMembers.filter { $0.teamID == opponentTeamID }
                    team2 = Team(name: opponentTeam?.teamName ?? "Team 2", players: mapMembersToPlayers(opponentTeamMembers))
                }

                // Refresh UI
                DispatchQueue.main.async {
                    self.updateHeaderUI()
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching teams and players: \(error)")
            }
        }
    }

    
    // MARK: - Helper to Convert TeamMembershipTable to Player
    private func mapMembersToPlayers(_ members: [TeamMembershipTable]) -> [Player] {
        return members.map { member in
            let playerName = userNames[member.userID] ?? "Unknown Player"
            return Player(name: playerName, reb: 0, ast: 0, stl: 0, foul: 0, pts: 0)
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        saveButton.layer.cornerRadius = 10
        for button in actionButtons {
            button.layer.cornerRadius = 8
            button.backgroundColor = .lightGray
        }
    }
    
    private func updateHeaderUI() {
        teamName1Label.text = yourTeam?.teamName ?? "Your Team"
        teamName2Label.text = opponentTeam?.teamName ?? "Opponent Team"
        team1score.text = "\(team1Score)"
        team2score.text = "\(team2Score)"
        
        if let logoName = yourTeam?.teamLogo, let teamImage = UIImage(named: logoName) {
            teamLogo1.image = teamImage
        } else {
            teamLogo1.image = UIImage(named: "default_team_logo") // Provide a fallback image
        }        //teamLogo1.image = UIImage(named: "team1") // Replace with your actual image names
        //teamLogo2.image = UIImage(named: "team2")
        if let logoName2 = yourTeam?.teamLogo, let teamImage2 = UIImage(named: logoName2) {
            teamLogo2.image = teamImage2
        } else {
            teamLogo2.image = UIImage(named: "default_team_logo") // Provide a fallback image
        }
        //teamLogo2.image = UIImage(named: (opponentTeam?.teamLogo!)!)

        
        
//        if let yourTeamLogo = yourTeam?.teamLogoURL {
//                teamLogo1.loadImage(from: yourTeamLogo)
//            }
//            if let opponentTeamLogo = opponentTeam?.teamLogoURL {
//                teamLogo2.loadImage(from: opponentTeamLogo)
//            }
    }
    
    
    
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
            // Reset all buttons to default style
            for button in actionButtons {
                button.backgroundColor = .lightGray
            }
            
            // If tapping the same button again, deselect it
            if selectedAction == sender.titleLabel?.text {
                selectedAction = nil
                return
            }
            
            // Highlight the selected button
            sender.backgroundColor = .orange
            
            // Store the selected action
            selectedAction = sender.titleLabel?.text
        }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("Team 1 Stats: \(team1.players)")
            print("Team 2 Stats: \(team2.players)")
            print("Team 1 Score: \(team1Score), Team 2 Score: \(team2Score)")

            let newGame = GameTable(
                gameID: UUID(),
                team1ID: yourTeam?.teamID ?? UUID(),
                team2ID: opponentTeam?.teamID ?? UUID(),
                dateOfGame: ISO8601DateFormatter().string(from: Date()),
                venue: "Some Venue",
                team1finalScore: team1Score,
                team2finalScore: team2Score
            )

            Task {
                do {
                    // Insert the new game into the GameTable
                    try await supabase.from("Game").insert(newGame).execute()

                    // Fetch player IDs for both teams
                    let team1Members: [TeamMembershipTable] = try await supabase
                        .from("teamMembership")
                        .select()
                        .eq("teamID", value: newGame.team1ID)
                        .execute()
                        .value

                    let team2Members: [TeamMembershipTable] = try await supabase
                        .from("teamMembership")
                        .select()
                        .eq("teamID", value: newGame.team2ID)
                        .execute()
                        .value

                    let team1PlayerIDs = team1Members.map { $0.userID }
                    let team2PlayerIDs = team2Members.map { $0.userID }

                    // Insert game logs for Team 1
                    for (index, player) in team1.players.enumerated() {
                        if index < team1PlayerIDs.count { // Ensure matching ID exists
                            let gameLog = GameLogtable(
                                logID: UUID(),
                                gameID: newGame.gameID,
                                teamID: newGame.team1ID,
                                playerID: team1PlayerIDs[index],
                                points2: player.pts / 2,
                                points3: 0,
                                freeThrows: 0,
                                rebounds: player.reb,
                                assists: player.ast,
                                steals: player.stl,
                                fouls: player.foul,
                                missed2Points: 0,
                                missed3Points: 0
                            )
                            try await supabase.from("GameLog").insert(gameLog).execute()
                        }
                    }

                    // Insert game logs for Team 2
                    for (index, player) in team2.players.enumerated() {
                        if index < team2PlayerIDs.count { // Ensure matching ID exists
                            let gameLog = GameLogtable(
                                logID: UUID(),
                                gameID: newGame.gameID,
                                teamID: newGame.team2ID,
                                playerID: team2PlayerIDs[index],
                                points2: player.pts / 2,
                                points3: 0,
                                freeThrows: 0,
                                rebounds: player.reb,
                                assists: player.ast,
                                steals: player.stl,
                                fouls: player.foul,
                                missed2Points: 0,
                                missed3Points: 0
                            )
                            try await supabase.from("GameLog").insert(gameLog).execute()
                        }
                    }

                    print("Game data successfully uploaded to Supabase.")
                } catch {
                    print("Error uploading game data to Supabase: \(error)")
                }
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
           if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
               // Present the AddTeamViewController
               homeVC.modalPresentationStyle = .fullScreen // or .overFullScreen if you want a different style
               self.present(homeVC, animated: true, completion: nil)
           } else {
               print("Could not instantiate AddMember")
           }
        
        }
        
    
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections: Team 1 and Team 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? team1.players.count : team2.players.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? team1.name : team2.name
    }
    
    private let scoreUpdateQueue = DispatchQueue(label: "com.athlinix.scoreupdates")
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberScoreTableViewCell", for: indexPath) as? MemberScoreTableViewCell else {
                return UITableViewCell()
            }
            
            let player = indexPath.section == 0 ? team1.players[indexPath.row] : team2.players[indexPath.row]
            cell.configure(with: player)
            
            // Apply highlight if this is the last modified cell
            if indexPath == lastHighlightedIndexPath {
                cell.contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
            } else {
                cell.contentView.backgroundColor = .clear
            }
            
            return cell
        }
    
    private func highlightCell(at indexPath: IndexPath) {
            lastHighlightedIndexPath = indexPath
            tableView.reloadRows(at: [indexPath], with: .none)
            
            // Remove highlight after duration
            DispatchQueue.main.asyncAfter(deadline: .now() + highlightDuration) { [weak self] in
                guard let self = self else { return }
                self.lastHighlightedIndexPath = nil
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let action = selectedAction else {
                print("No action selected")
                return
            }
            
            if indexPath.section == 0 {
                updatePlayer(&team1.players[indexPath.row], with: action, forTeam: .team1, at: indexPath)
            } else {
                updatePlayer(&team2.players[indexPath.row], with: action, forTeam: .team2, at: indexPath)
            }
            
            // Deselect the action button after use
            deselectActionButton()
            
            tableView.reloadData()
            updateHeaderUI()
        }
    
    private enum TeamIdentifier {
            case team1
            case team2
    }
    
    private func deselectActionButton() {
            // Reset all buttons to default style
            for button in actionButtons {
                if button.titleLabel?.text == selectedAction {
                    button.backgroundColor = .lightGray
                }
            }
            selectedAction = nil
        }
    
    
    
    // MARK: - Player Stats Update
    private func updatePlayer(_ player: inout Player, with action: String, forTeam team: TeamIdentifier, at indexPath: IndexPath) {
            scoreUpdateQueue.sync {
                // Store previous state for undo
                let previousState = player
                var scoreChange = 0
                
                switch action {
                case "+2 PFG":
                    player.pts += 2
                    scoreChange = 2
                    updateTeamScore(for: team, points: 2)
                case "FREE THROW":
                    player.pts += 1
                    scoreChange = 1
                    updateTeamScore(for: team, points: 1)
                case "+3 PFG":
                    player.pts += 3
                    scoreChange = 3
                    updateTeamScore(for: team, points: 3)
                case "REBOUND":
                    player.reb += 1
                case "ASSIST":
                    player.ast += 1
                case "STEAL":
                    player.stl += 1
                case "FOUL":
                    player.foul += 1
                default:
                    print("Unknown action")
                }
                
                // Store the action for potential undo
                lastAction = Action(
                    player: player,
                    previousState: previousState,
                    team: team,
                    indexPath: indexPath,
                    scoreChange: scoreChange
                )
                
                DispatchQueue.main.async { [weak self] in
                                self?.updateUndoButtonState()
                                self?.highlightCell(at: indexPath)
                            }
            }
        }
    
    private func updateTeamScore(for team: TeamIdentifier, points: Int) {
            switch team {
            case .team1:
                team1Score += points
            case .team2:
                team2Score += points
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateHeaderUI()
                self?.animateScoreUpdate(for: team, points: points)
            }
        }


    
//    private func extractPoints(from action: String) -> Int {
//        if action.contains("+2") { return 2 }
//        if action.contains("+3") { return 3 }
//        if action.contains("FREE THROW") { return 1 }
//        return 0
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UIImageView
extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
