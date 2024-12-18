//
//  HomeScreenViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 14/12/24.
//
import UIKit
struct Team {
    let name: String
    let image: UIImage
    let twoPointFieldGoals: Int
    let threePointFieldGoals: Int
    let freeThrows: Int
}


class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ppgLabel: UILabel!
    @IBOutlet weak var bpgLabel: UILabel!
    @IBOutlet weak var astLabel: UILabel!
    
    @IBOutlet weak var pointsScoredImageView: UIView!
    @IBOutlet weak var seeAnalyticsButton: UILabel!
    @IBOutlet weak var pointsScoredBarGraphView: UIView!
    
    @IBOutlet weak var pinnedMatchesView: UIView!
    @IBOutlet weak var pinnedMatchesCardView: UIView!
    @IBOutlet weak var team2ImageView: UIImageView!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1ImageView: UIImageView!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var team12ptfgs: UILabel!
    @IBOutlet weak var team13ptfgs: UILabel!
    @IBOutlet weak var team1FreeThrows: UILabel!
    @IBOutlet weak var team22ptfgs: UILabel!
    @IBOutlet weak var team23ptfgs: UILabel!
    @IBOutlet weak var team2FreeThrows: UILabel!
    
    
    @IBOutlet weak var highlightCardView: UIView!
    @IBOutlet weak var highlightImageView: UIImageView!
    @IBOutlet weak var highlightGameName: UILabel!
    @IBOutlet weak var highlightDate: UILabel!
    
    
    @IBOutlet weak var athletesCollectionView: UICollectionView!
    
    @IBOutlet weak var matchesPlayedvsPointsScoredView: UIView!
    
    @IBOutlet weak var teamgraphview: UIView!

    let loggedInUserID = "2"
    
    //@IBOutlet weak var teamPerformanceBarChartView: TeamPerformanceBarGamePlayChartView!
    
    
    // MARK: viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer.cornerRadius = 16
        // Do any additional setup after loading the view.
        
        setupPointsScoredGraph(for: loggedInUserID)
        //setupMatchesPlayedVsPointsScoredGraph()
        
        let viewsToStyle = [pointsScoredImageView, pinnedMatchesCardView, matchesPlayedvsPointsScoredView]
        
        for view in viewsToStyle {
            view?.layer.borderColor = UIColor.lightGray.cgColor
            view?.layer.borderWidth = 1.0 // Thickness of the border
            view?.layer.cornerRadius = 8 // Optional: Rounded corners
            view?.clipsToBounds = true
        }
        
        
        // Example Teams MARK: previous implementation BEST MATCH
        //                 let team1 = Team(name: "LA Lakers",
        //                                  image: UIImage(named: "team4")!,
        //                                  twoPointFieldGoals: 47,
        //                                  threePointFieldGoals: 10,
        //                                  freeThrows: 6)
        //
        //                 let team2 = Team(name: "BFI",
        //                                  image: UIImage(named: "team5")!,
        //                                  twoPointFieldGoals: 47,
        //                                  threePointFieldGoals: 7,
        //                                  freeThrows: 3)
        //
        //                 // Configure UI
        //                 configurePinnedMatch(team1: team1, team2: team2)
        
        // MARK: NEW
        // Fetch the best match data and update UI
        if let bestMatch = fetchBestMatch(forPlayerID: loggedInUserID) {
            updatePinnedMatchView(with: bestMatch)
        }
        
        
        // MARK: FLOATING BUTTON
        let floatingButton = UIButton(type: .system)
        floatingButton.frame = CGRect(x: view.frame.width - 30 - 70, y: view.frame.height - 120 - 70, width: 70, height: 70)
        floatingButton.layer.cornerRadius = 35 // Half of width/height to make it circular
        floatingButton.backgroundColor = UIColor(red: 253/255, green: 100/255, blue: 48/255, alpha: 1.0) // FD6430 color
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        floatingButton.setTitleColor(.white, for: .normal)

        // Add shadow for better visibility
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingButton.layer.shadowRadius = 4

        // Add target action for the button
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)

        // Add the button to the view
        view.addSubview(floatingButton)

        setupHeader()
        setupPointsScoredSection()
        // setupPinnedMatches()
        setupHighlightSection()
        setupAthletesCollectionView()
        setupTeamPerformanceChart()
        //setupMatchesPlayedvsPointsScoredSection()
        //setupMatchesPlayedvsPointsScoredSection()
    }
    
    
    func configurePinnedMatch(team1: Team, team2: Team) {
        // Set Team 1 details
        team1ImageView.image = team1.image
        team1Name.text = team1.name
        team12ptfgs.text = "\(team1.twoPointFieldGoals)"
        team13ptfgs.text = "\(team1.threePointFieldGoals)"
        team1FreeThrows.text = "\(team1.freeThrows)"
        
        // Set Team 2 details
        team2ImageView.image = team2.image
        team2Name.text = team2.name
        team22ptfgs.text = "\(team2.twoPointFieldGoals)"
        team23ptfgs.text = "\(team2.threePointFieldGoals)"
        team2FreeThrows.text = "\(team2.freeThrows)"
    }
    
    // MARK: - Setup Header
    private func setupHeader() {
        guard let athlete = users.first(where: { $0.userID == "2" }) else {
            print("No user stats available.")
            return
        }
        
        // Find the corresponding athlete profile using athleteID
        guard let athleteProfile = athleteProfiles.first(where: { $0.athleteID == athlete.userID }) else {
            print("No athlete profile found.")
            return
        }
        
        // Configure the header view
        headerView.layer.cornerRadius = 16
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        // Set data dynamically from `userStats` and `athleteProfile`
        userNameLabel.text = athlete.name
        ppgLabel.text = String(format: "%.1f", athleteProfile.averagePointsPerGame)
        bpgLabel.text = String(format: "%.1f", athleteProfile.averageReboundsPerGame)
        astLabel.text = String(format: "%.1f", athleteProfile.averageAssistsPerGame)
        
        // Set profile picture (ensure the image exists in your assets)
        if let profileImage = UIImage(named: athlete.profilePicture) {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = UIImage(named: "placeholder") // Fallback image
        }
    }
    
    // MARK: - Points Scored Section
    private func setupPointsScoredSection() {
        //            pointsScoredBarGraphView.backgroundColor = UIColor.orange.withAlphaComponent(0.2) // Placeholder bar graph
        pointsScoredBarGraphView.layer.cornerRadius = 8
    }
    
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        guard let matchHistoryVC = storyboard.instantiateViewController(withIdentifier: "MatchHistoryViewController") as? MatchHistoryViewController else {
            print("MatchHistoryViewController not found!")
            return
        }
        
        // Push the MatchHistoryViewController onto the navigation stack
        self.navigationController?.pushViewController(matchHistoryVC, animated: true)
    }
    
    
    // MARK: - Pinned Matches
    // MARK: - Fetch Best Match
    func fetchBestMatch(forPlayerID playerID: String) -> Game? {
        // Filter games where the player participated
        let playerGameLogs = gameLogs.filter { $0.playerID == playerID }
        let playerGameIDs = Set(playerGameLogs.map { $0.gameID })
        let playerGames = games.filter { playerGameIDs.contains($0.gameID) }
        
        // Select the best match (e.g., highest total points scored by the player's team)
        var bestGame: Game?
        var maxPoints = 0
        
        for game in playerGames {
            let teamLogs = playerGameLogs.filter { $0.gameID == game.gameID }
            let teamPoints = teamLogs.reduce(0) { $0 + $1.totalPoints }
            
            if teamPoints > maxPoints {
                maxPoints = teamPoints
                bestGame = game
            }
        }
        
        return bestGame
    }
    
    // MARK: - Update UI
    func updatePinnedMatchView(with game: Game) {
        // Fetch team details
        guard let team1 = teams.first(where: { $0.teamID == game.team1ID }),
              let team2 = teams.first(where: { $0.teamID == game.team2ID }) else { return }
        
        // Update labels
        team1Name.text = team1.teamName
        team2Name.text = team2.teamName
        
        // Update images (use a placeholder or a utility for image loading)
        team1ImageView.image = UIImage(named: team1.teamLogo)
        team2ImageView.image = UIImage(named: team2.teamLogo)
        
        // Fetch game logs for the match
        let team1Logs = gameLogs.filter { $0.gameID == game.gameID && $0.teamID == game.team1ID }
        let team2Logs = gameLogs.filter { $0.gameID == game.gameID && $0.teamID == game.team2ID }
        
        // Calculate stats
        team12ptfgs.text = "\(team1Logs.reduce(0) { $0 + $1.points2 })"
        team13ptfgs.text = "\(team1Logs.reduce(0) { $0 + $1.points3 })"
        team1FreeThrows.text = "\(team1Logs.reduce(0) { $0 + $1.freeThrows })"
        
        team22ptfgs.text = "\(team2Logs.reduce(0) { $0 + $1.points2 })"
        team23ptfgs.text = "\(team2Logs.reduce(0) { $0 + $1.points3 })"
        team2FreeThrows.text = "\(team2Logs.reduce(0) { $0 + $1.freeThrows })"
    }
    
    //         private func setupPinnedMatches() {
    //             pinnedMatchesCardView.layer.cornerRadius = 12
    //             pinnedMatchesCardView.layer.shadowColor = UIColor.black.cgColor
    //             pinnedMatchesCardView.layer.shadowOpacity = 0.1
    //             pinnedMatchesCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
    //             pinnedMatchesCardView.layer.shadowRadius = 8
    //         }
    
    // MARK: - Highlight Section
    // Step 2: Filter posts to show only the logged-in user's posts
    private func setupHighlightSection() {
          // Use the logged-in user ID dynamically
        
        // Filter posts to show only the logged-in user's posts
        let userPosts = posts.filter { $0.createdBy == loggedInUserID }
        
        guard let post = userPosts.first else {
            print("No posts available to display highlights.")
            return
        }
        
        highlightCardView.layer.cornerRadius = 12
        highlightCardView.layer.shadowColor = UIColor.black.cgColor
        highlightCardView.layer.shadowOpacity = 0.1
        highlightCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        highlightCardView.layer.shadowRadius = 8
        
        // Dynamically set the highlight image and other details
        if let highlightImage = UIImage(named: post.image1) {
            highlightImageView.image = highlightImage
        } else {
            highlightImageView.image = UIImage(named: "placeholder") // Add a default placeholder image
        }
        
        highlightGameName.text = post.content // Example: Use the content of the post
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM '24"
        highlightDate.text = dateFormatter.string(from: post.dateCreated) // Format date
    }

    
    // MARK: - Athletes Collection View
    private func setupAthletesCollectionView() {
        athletesCollectionView.delegate = self
        athletesCollectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AthletesCell", for: indexPath) as! athletesCollectionViewCell
            let user = users[indexPath.row]  // Fetch the user at the given index
            
         
            cell.configure(with: user)  // Assuming your cell has a configure method that accepts a `User`
            
            return cell
    }
    
    
    // MARK: GRAPHS
    func setupPointsScoredGraph(for userID: String) {
        guard !gameLogs.isEmpty else { return }
        
        pointsScoredBarGraphView.subviews.forEach { $0.removeFromSuperview() } // Clear previous views
        
        pointsScoredBarGraphView.clipsToBounds = true
        let barWidth: CGFloat = 20
        let spacing: CGFloat = 10
        let graphHeight: CGFloat = pointsScoredBarGraphView.bounds.height - 20
        let maxPoints: CGFloat = 150 // Maximum points for scaling
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        // Filter logs for the user and group by month
        let calendar = Calendar.current
        var monthlyPoints = [Int](repeating: 0, count: 12)
        
        for log in gameLogs where log.playerID == userID {
            let month = calendar.component(.month, from: games.first { $0.gameID == log.gameID }?.dateOfGame ?? Date()) - 1
            monthlyPoints[month] += log.totalPoints
        }
        
        // Add grid lines
        let numberOfGridLines = 5
        for i in 0...numberOfGridLines {
            let yPosition = graphHeight - (graphHeight / CGFloat(numberOfGridLines) * CGFloat(i))
            
            let gridLine = UIView(frame: CGRect(x: 0, y: yPosition, width: pointsScoredBarGraphView.bounds.width, height: 1))
            gridLine.backgroundColor = .lightGray.withAlphaComponent(0.3)
            pointsScoredBarGraphView.addSubview(gridLine)
            
            let valueLabel = UILabel(frame: CGRect(x: 0, y: yPosition - 8, width: 30, height: 15))
            valueLabel.text = "\(Int(maxPoints / CGFloat(numberOfGridLines) * CGFloat(i)))"
            valueLabel.font = UIFont.systemFont(ofSize: 10)
            valueLabel.textAlignment = .right
            valueLabel.textColor = .gray
            pointsScoredBarGraphView.addSubview(valueLabel)
        }
        
        // Add bars and month labels
        let graphWidth = pointsScoredBarGraphView.bounds.width
        let totalSpacing = CGFloat(monthlyPoints.count - 1) * spacing
        let totalBarWidth = CGFloat(monthlyPoints.count) * barWidth
        let totalWidth = totalSpacing + totalBarWidth
        let xOffset = (graphWidth - totalWidth) / 2
        
        for (index, points) in monthlyPoints.enumerated() where points > 0 {
            let barHeight = graphHeight * CGFloat(points) / maxPoints
            let barX = xOffset + CGFloat(index) * (barWidth + spacing)
            
            let barView = UIView(frame: CGRect(x: barX, y: graphHeight - barHeight, width: barWidth, height: barHeight))
            barView.backgroundColor = .systemOrange
            barView.layer.cornerRadius = 4
            pointsScoredBarGraphView.addSubview(barView)
            
            let monthLabel = UILabel(frame: CGRect(x: barX - 5, y: graphHeight + 5, width: barWidth + 10, height: 15))
            monthLabel.text = months[index]
            monthLabel.font = UIFont.systemFont(ofSize: 10)
            monthLabel.textAlignment = .center
            monthLabel.textColor = .gray
            pointsScoredBarGraphView.addSubview(monthLabel)
        }
    }
    
    // MARK: GRAPH 2
    
    // Step 1: Add the TeamPerformanceBarGamePlayChartView to teamgraphview
    func setupTeamPerformanceChart() {
        let chartView = TeamPerformanceBarGamePlayChartView()
        
        // Set frame or constraints for chartView to fit in teamgraphview
        chartView.frame = CGRect(x: 0, y: 0, width: teamgraphview.bounds.width, height: teamgraphview.bounds.height)
        chartView.backgroundColor = .clear
        
        // Add the chart view to the teamgraphview
        teamgraphview.addSubview(chartView)
    }
    
    @IBAction func navigateToHierarchy(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNavigation", sender: nil)
        
    }
    
    @IBAction func navigateTogameplay(_ sender: UIButton) {
        performSegue(withIdentifier: "gotogameplay", sender: nil)
        
    }
    
    
    @objc func floatingButtonTapped() {
        // Create an action sheet
        let actionSheet = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)
        
        // Create "Create Post" action
        let createPostAction = UIAlertAction(title: "Create Post", style: .default) { _ in
            // Handle Create Post action
            self.createPost()
        }
        
        // Create "Create Team" action
        let createTeamAction = UIAlertAction(title: "Create Team", style: .default) { _ in
            // Handle Create Team action
            self.createTeam()
        }
        
        // Create "Create Game" action
        let createGameAction = UIAlertAction(title: "Create Game", style: .default) { _ in
            // Handle Create Game action
            self.createGame()
        }
        
        // Add actions to the action sheet
        actionSheet.addAction(createPostAction)
        actionSheet.addAction(createTeamAction)
        actionSheet.addAction(createGameAction)
        
        // Add a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        present(actionSheet, animated: true, completion: nil)
    }

    // Define methods for each action
    func createPost() {
        // Code for creating a post
        let createPostVC = CreatePostViewController()
            
            // Push CreatePostViewController onto the navigation stack
            navigationController?.pushViewController(createPostVC, animated: true)
        
        
        }

        // Add this helper function if needed to refresh the home feed
        private func refreshHomeFeed() {
            print("Home feed refreshed with the new post")
            // Add logic to update the home feed with the new post
        }

    func createTeam() {
        // Code for creating a team
        print("Create Team tapped")
    }

    func createGame() {
        // Code for creating a game
        print("Create Game tapped")
    }

    
    
    private func setupMatchesPlayedvsPointsScoredSection() {
        //matchesPlayedvsPointsScoredBarGraphView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.2)
        
        // Placeholder bar graph
        // matchesPlayedvsPointsScoredBarGraphView.layer.cornerRadius = 8
    }
    
    
}
