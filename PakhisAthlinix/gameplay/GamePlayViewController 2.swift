//
//  ViewController.swift
//  GamePlay
//
//  Created by admin65 on 19/11/24.
//

import UIKit
import Charts
import SwiftUI

class GamePlayViewController1: UIViewController, TeamPickerDelegate {
    
    let loggedInPlayerID = "2" // Replace with the actual logged-in player ID
    
    let teamid = UUID(uuidString: "89227764-5b18-4723-b140-35dc161d6541")
    
    var teamID: UUID?
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var teamPicker: UIButton!
    
    @IBOutlet weak var totalPointsScoredView: UIView!
    @IBOutlet weak var totalPointsScoredLabel: UILabel!
    
    @IBOutlet weak var gamesPlayedView: UIView!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    
    @IBOutlet weak var scoringEfficiencyView: UIView!
    @IBOutlet weak var pointsPerGame: UILabel!
    @IBOutlet weak var percentageIncrease: UILabel!
    @IBOutlet weak var scoringEfficiencyLineGraphView: UIView!
    
    
    @IBOutlet weak var reboundsView: UIView!
    @IBOutlet weak var reboundsNumber: UILabel! //number of rebounds
    @IBOutlet weak var reboundsPercentageIncrease: UILabel!
    @IBOutlet weak var reboundsIncreaseLinceGraphView: UIView!
    
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var assistsToTurnoverLabel: UILabel! //will have ratio in "9:3" format
   
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    //@IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    
    @IBOutlet weak var graphView1: UIView!
    @IBOutlet weak var graphView2: UIView!
    @IBOutlet weak var graphView3: UIView!
    @IBOutlet weak var graphView4: UIView!
    @IBOutlet weak var graphView6: UIView!
    
    @IBOutlet weak var graphView7: UIView!
    
    @IBOutlet weak var graphView8: UIView!
    
    
    @IBOutlet weak var gView1: UIView!
    @IBOutlet weak var gView2: UIView!
    @IBOutlet weak var gView3: UIView!
    @IBOutlet weak var gView4: UIView!
    @IBOutlet weak var gView5: UIView!
    @IBOutlet weak var gView6: UIView!
        
    
    
    
    
    @IBOutlet weak var pointsScoredView: UIView!
    //@IBOutlet weak var pointsScoredBarChartView: UIView!
    @IBOutlet weak var pointsScoredBarChartView: PointsScoredBarChartView! //year wise points scored by a player, in gradient shades of #962DFF.
    
    
    @IBOutlet weak var goalsVsBricksView: UIView!
    @IBOutlet weak var goalsPieChartView: GoalsPieChartView!
    

    @IBOutlet weak var gamePerformanceView: UIView!
    
    @IBOutlet weak var gamePerformanceBarChartView: GamePerformanceBarChartView!
    
    
    @IBOutlet weak var teamPerformanceView: UIView!
    
    @IBOutlet weak var teamPerformanceBarChartView: TeamPerformanceBarChartViewClass!

    
    @IBOutlet weak var teamPerformanceLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIButton!
    
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //MARK: Style views
              styleOuterCardView(totalPointsScoredView)
              styleOuterCardView(gamesPlayedView)
              styleOuterCardView(scoringEfficiencyView)
              styleOuterCardView(reboundsView)
              styleOuterCardView(statisticsView)
            styleOuterCardView(view1)
            styleOuterCardView(view2)
            styleOuterCardView(view3)
            styleOuterCardView(view4)
            
            segmentChanged(segmentedController)

        }
    
    //MARK: MAIN CONTROLLER
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                // Load data for the first tab
                loadFirstTabData()
            
            scoringEfficiencyLineGraphView.isHidden = false
                reboundsIncreaseLinceGraphView.isHidden = false
                graphView1.isHidden = false
                graphView2.isHidden = false
                graphView4.isHidden = false
                graphView7.isHidden = false
                graphView8.isHidden = false
            
                gView1.isHidden = true
                gView2.isHidden = true
                gView3.isHidden = true
                gView4.isHidden = true
                gView5.isHidden = true
            
                reloadInputViews()
            case 1:
                // Load data for the second tab
                loadSecondTabData()
                scoringEfficiencyLineGraphView.isHidden = true
                reboundsIncreaseLinceGraphView.isHidden = true
                graphView1.isHidden = true
                graphView2.isHidden = true
                graphView4.isHidden = true
                graphView7.isHidden = true
                graphView8.isHidden = true
            
                gView1.isHidden = false
                gView2.isHidden = false
                gView3.isHidden = false
                gView4.isHidden = false
                gView5.isHidden = false
                
                reloadInputViews()
            default:
                // Handle unexpected cases (e.g., if more segments are added in the future)
                loadFirstTabData()
            
                scoringEfficiencyView.isHidden = false
                reboundsIncreaseLinceGraphView.isHidden = false
                graphView1.isHidden = false
                graphView2.isHidden = false
                graphView4.isHidden = false
                graphView7.isHidden = false
                graphView8.isHidden = false
            
                gView1.isHidden = true
                gView2.isHidden = true
                gView3.isHidden = true
                gView4.isHidden = true
                gView5.isHidden = true
                reloadInputViews()
            }
        reloadInputViews()
        
        }
    
    func loadFirstTabData() {
        // Fetch & display first tab's data
        fetchGameData()
        fetchGameData1()
        rendergraphs()
        Task{
            await fetchPlayerGameLogs()
        }
        let containerView = GoalsPieChartContainerView(frame: CGRect(x: 0, y: 0, width: 345, height: 255.67))
        graphView8.addSubview(containerView)

               // Set up constraints
               NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: graphView8.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: graphView8.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: graphView8.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: graphView8.bottomAnchor)
               ])
    }

    func loadSecondTabData() {
        renderteamgraphs()
        Task{
            await fetchTeamGameLogs(for: teamid!)
        }
        fetchteamGameData()
        fetchteamGameData1()
        let containerView = teamGoalsPieChartContainerView(frame: CGRect(x: 0, y: 0, width: 345, height: 255.67))
        graphView8.addSubview(containerView)

               // Set up constraints
               NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: graphView8.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: graphView8.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: graphView8.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: graphView8.bottomAnchor)
               ])
    }

    
    func rendergraphs(){
        //MARK: GRAPH 1
        let graph1 = GamePointsChartView()
        
//        let graph1 = teamGamePointsChartView(teamID: teamid!)

        // Create a UIHostingController with the SwiftUI view
        let hostingController1 = UIHostingController(rootView: graph1)
        // Add the hosting controller as a child view controller
        addChild(hostingController1)
        // Set the frame of the hosting controller's view to match someView
        hostingController1.view.frame = graphView1.bounds
        // Add the hosting controller's view to someView
        graphView1.addSubview(hostingController1.view)
        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController1.didMove(toParent: self)
        
        //MARK: GRAPH 2
        let graph2 = FieldGoalChartView()
        // Create a UIHostingController with the SwiftUI view
        let hostingController2 = UIHostingController(rootView: graph2)
        // Add the hosting controller as a child view controller
        addChild(hostingController2)
        // Set the frame of the hosting controller's view to match someView
        hostingController2.view.frame = graphView7.bounds
        // Add the hosting controller's view to someView
        graphView7.addSubview(hostingController2.view)
        
        hostingController2.view.translatesAutoresizingMaskIntoConstraints = false

        // Set Auto Layout constraints to match the bounds of graphView2
        NSLayoutConstraint.activate([
            hostingController2.view.leadingAnchor.constraint(equalTo: graphView7.leadingAnchor),
            hostingController2.view.trailingAnchor.constraint(equalTo: graphView7.trailingAnchor),
            hostingController2.view.topAnchor.constraint(equalTo: graphView7.topAnchor),
            hostingController2.view.bottomAnchor.constraint(equalTo: graphView7.bottomAnchor)
        ])

        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController2.didMove(toParent: self)
        
        //MARK: GRAPH 3
        let graph3 = FoulsBarChartView()
        // Create a UIHostingController with the SwiftUI view
        let hostingController3 = UIHostingController(rootView: graph3)
        // Add the hosting controller as a child view controller
        addChild(hostingController3)
        // Set the frame of the hosting controller's view to match someView
        hostingController3.view.frame = graphView4.bounds
        // Add the hosting controller's view to someView
        graphView4.addSubview(hostingController3.view)
        
        hostingController3.view.translatesAutoresizingMaskIntoConstraints = false

        // Set Auto Layout constraints to match the bounds of graphView2
        NSLayoutConstraint.activate([
            hostingController3.view.leadingAnchor.constraint(equalTo: graphView4.leadingAnchor),
            hostingController3.view.trailingAnchor.constraint(equalTo: graphView4.trailingAnchor),
            hostingController3.view.topAnchor.constraint(equalTo: graphView4.topAnchor),
            hostingController3.view.bottomAnchor.constraint(equalTo: graphView4.bottomAnchor)
        ])
        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController3.didMove(toParent: self)
    }
    
        //MARK: Styling function remains the same
        func styleOuterCardView(_ view: UIView) {
            view.layer.cornerRadius = 10
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
        }
    
    
    //MARK: GRAPH 4
    func fetchGameData() {
            Task {
                guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                    print("Error: No session user is set")
                    return
                }
                
                do {
                    let gameLogsResponse = try await supabase
                        .from("GameLog")
                        .select("*")
                        .eq("playerID", value: sessionUserID.uuidString)
                        .execute()
                    let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)

                    let gamesResponse = try await supabase
                        .from("Game")
                        .select("*")
                        .execute()
                    let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)

                    DispatchQueue.main.async {
                        self.addSwiftUIChart(gameLogs: gameLogs, games: games)
                    }
                } catch {
                    print("Error fetching data: \(error)")
                }
            }
        }

        func addSwiftUIChart(gameLogs: [GameLogtable], games: [GameTable]) {
            let chartView = UIHostingController(rootView: PointsScoredChart(gameLogs: gameLogs, games: games))
            addChild(chartView)
            chartView.view.frame = scoringEfficiencyLineGraphView.bounds
            chartView.view.translatesAutoresizingMaskIntoConstraints = false
            scoringEfficiencyLineGraphView.addSubview(chartView.view)
            
            NSLayoutConstraint.activate([
                chartView.view.leadingAnchor.constraint(equalTo: scoringEfficiencyLineGraphView.leadingAnchor),
                chartView.view.trailingAnchor.constraint(equalTo: scoringEfficiencyLineGraphView.trailingAnchor),
                chartView.view.topAnchor.constraint(equalTo: scoringEfficiencyLineGraphView.topAnchor),
                chartView.view.bottomAnchor.constraint(equalTo: scoringEfficiencyLineGraphView.bottomAnchor)
            ])
            
            chartView.didMove(toParent: self)
        }
    //MARK: GRAPH 5
    func fetchGameData1() {
        Task {
            guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                print("Error: No session user is set")
                return
            }

            do {
                let gameLogsResponse = try await supabase
                    .from("GameLog")
                    .select("*")
                    .eq("playerID", value: sessionUserID.uuidString)
                    .execute()
                let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)

                let gamesResponse = try await supabase
                    .from("Game")
                    .select("*")
                    .execute()
                let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)

                DispatchQueue.main.async {
                    self.addSwiftUIChart1(gameLogs: gameLogs, games: games)
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }

    func addSwiftUIChart1(gameLogs: [GameLogtable], games: [GameTable]) {
        let chartView = UIHostingController(rootView: ReboundsTakenChart(gameLogs: gameLogs, games: games)) // Use ReboundsTakenChart
        addChild(chartView)
        chartView.view.frame = reboundsIncreaseLinceGraphView.bounds // ✅ Change view to "reboundsIncreaseLinceGraphView"
        //chartView.view.translatesAutoresizingMaskIntoConstraints = false
        reboundsIncreaseLinceGraphView.addSubview(chartView.view)

        NSLayoutConstraint.activate([

            chartView.view.topAnchor.constraint(equalTo: reboundsIncreaseLinceGraphView.topAnchor),
            chartView.view.bottomAnchor.constraint(equalTo: reboundsIncreaseLinceGraphView.bottomAnchor)
        ])

        chartView.didMove(toParent: self)
    }
    
    //MARK: TEAM PICKER
    @IBAction func teamPickerButtonTapped(_ sender: Any) {
            Task {
                
                let sessionUserID =  await SessionManager.shared.getSessionUser()
                
                do {
                    let sessionUserID =  await SessionManager.shared.getSessionUser()
                    
                    let membershipsResponse = try await supabase
                        .from("teamMembership")
                        .select("*")
                        .eq("userID", value: sessionUserID!.uuidString)
                        .execute()
                    
                    let decoder = JSONDecoder()
                    let memberships = try decoder.decode([TeamMembershipTable].self, from: membershipsResponse.data)
                    
                    let teamIDs = memberships.map { $0.teamID.uuidString }
                    
                    let teamsResponse = try await supabase
                        .from("teams")
                        .select("*")
                        .in("teamID", values: teamIDs)
                        .execute()
                    
                    let teams = try decoder.decode([TeamTable].self, from: teamsResponse.data)
                    
                    DispatchQueue.main.async {
                        self.presentTeamPicker(teams: teams)
                    }
                } catch {
                    print("Error fetching teams: \(error)")
                }
            }
        }
    
            
            func presentTeamPicker(teams: [TeamTable]) {
                let teamPickerVC = TeamPickerViewController()
                teamPickerVC.teams = teams
                teamPickerVC.delegate = self
                present(teamPickerVC, animated: true, completion: nil)
            }
            
            func didSelectTeam(_ teamID: UUID) {
                self.teamID = teamID
                print("Selected Team ID: \(teamID)")
            }
    
    
    private func fetchPlayerGameLogs() async {
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
            print("Error: No session user is set")
            return
        }
    
        do {
            // Fetch game logs for the logged-in player
            let response = try await supabase
                .from("GameLog")
                .select("*")
                .eq("playerID", value: sessionUserID.uuidString)
                .execute()
    
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let playerGameLogs = try decoder.decode([GameLogtable].self, from: response.data)
    
            guard !playerGameLogs.isEmpty else { return }
    
            // MARK: Calculate metrics
            let totalPoints = playerGameLogs.reduce(0) { $0 + ($1.points2 + $1.points3 + $1.freeThrows) }
            //MARK: CODED
            let gamesPlayed = playerGameLogs.count - 1
            let pointsPerGameValue = Double(totalPoints) / Double(gamesPlayed)
    
            let firstGamePoints = playerGameLogs.first.map { $0.points2 + $0.points3 + $0.freeThrows } ?? 0
            let lastGamePoints = playerGameLogs.last.map { $0.points2 + $0.points3 + $0.freeThrows } ?? 0
            let scoringPercentageIncrease = firstGamePoints == 0 ? 0 : (Double(lastGamePoints - firstGamePoints) / Double(firstGamePoints)) * 100
    
            let totalRebounds = playerGameLogs.reduce(0) { $0 + $1.rebounds }
            let avgRebounds = Double(totalRebounds) / Double(gamesPlayed)
    
            let firstGameRebounds = playerGameLogs.first?.rebounds ?? 0
            let lastGameRebounds = playerGameLogs.last?.rebounds ?? 0
            let reboundsPercentageIncrease1 = firstGameRebounds == 0 ? 0 : (Double(lastGameRebounds - firstGameRebounds) / Double(firstGameRebounds)) * 100
    
            let totalAssists = playerGameLogs.reduce(0) { $0 + $1.assists }
            let totalTurnovers = playerGameLogs.reduce(0) { $0 + $1.fouls }
            let assistsToTurnoverRatio = totalTurnovers == 0 ? "N/A" : "\(totalAssists):\(totalTurnovers)"
    
            // MARK: Update UI on the main thread
            DispatchQueue.main.async {
                self.totalPointsScoredLabel.text = "\(totalPoints)"
                self.gamesPlayedLabel.text = "\(gamesPlayed)"
                self.pointsPerGame.text = String(format: "%.1f", pointsPerGameValue)
                self.percentageIncrease.text = String(format: "%.2f%%", scoringPercentageIncrease)
                self.percentageIncrease.textColor = scoringPercentageIncrease < 0 ? .red : .green
    
                self.reboundsNumber.text = String(format: "%.1f", avgRebounds)
                self.reboundsPercentageIncrease.text = String(format: "%.2f%%", reboundsPercentageIncrease1)
                self.reboundsPercentageIncrease.textColor = reboundsPercentageIncrease1 < 0 ? .red : .green
    
                self.assistsToTurnoverLabel.text = assistsToTurnoverRatio
    
                // MARK: Graphs
                let pointsData = playerGameLogs.map { CGFloat($0.points2 + $0.points3 + $0.freeThrows) }
                let reboundsData = playerGameLogs.map { CGFloat($0.rebounds) }
    
                //self.drawLineGraph(in: self.scoringEfficiencyLineGraphView, dataPoints: pointsData)
                //self.drawLineGraph(in: self.reboundsIncreaseLinceGraphView, dataPoints: reboundsData)
            }
        } catch {
            print("Error fetching player game logs: \(error)")
        }
    }
    //MARK: TEAM FUNCTIONS
    func renderteamgraphs(){
        //MARK: GRAPH 1
        let graph1 = teamGamePointsChartView(teamID: (teamID ?? teamid)!)
        
//        let graph1 = teamGamePointsChartView(teamID: teamid!)

        // Create a UIHostingController with the SwiftUI view
        let hostingController1 = UIHostingController(rootView: graph1)
        // Add the hosting controller as a child view controller
        addChild(hostingController1)
        // Set the frame of the hosting controller's view to match someView
        hostingController1.view.frame = gView3.bounds
        // Add the hosting controller's view to someView
        gView3.addSubview(hostingController1.view)
        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController1.didMove(toParent: self)
        
        //MARK: GRAPH 2
        let graph2 = teamFieldGoalChartView(teamID: (teamID ?? teamid)!)
        // Create a UIHostingController with the SwiftUI view
        let hostingController2 = UIHostingController(rootView: graph2)
        // Add the hosting controller as a child view controller
        addChild(hostingController2)
        // Set the frame of the hosting controller's view to match someView
        hostingController2.view.frame = gView4.bounds
        // Add the hosting controller's view to someView
        gView4.addSubview(hostingController2.view)
        
        hostingController2.view.translatesAutoresizingMaskIntoConstraints = false

        // Set Auto Layout constraints to match the bounds of graphView2
        NSLayoutConstraint.activate([
            hostingController2.view.leadingAnchor.constraint(equalTo: gView4.leadingAnchor),
            hostingController2.view.trailingAnchor.constraint(equalTo: gView4.trailingAnchor),
            hostingController2.view.topAnchor.constraint(equalTo: gView4.topAnchor),
            hostingController2.view.bottomAnchor.constraint(equalTo: gView4.bottomAnchor)
        ])

        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController2.didMove(toParent: self)
        
        //MARK: GRAPH 3
        let graph3 = teamFoulsBarChartView(teamID: (teamID ?? teamid)!)
        // Create a UIHostingController with the SwiftUI view
        let hostingController3 = UIHostingController(rootView: graph3)
        // Add the hosting controller as a child view controller
        addChild(hostingController3)
        // Set the frame of the hosting controller's view to match someView
        hostingController3.view.frame = gView6.bounds
        // Add the hosting controller's view to someView
        gView6.addSubview(hostingController3.view)
        
        hostingController3.view.translatesAutoresizingMaskIntoConstraints = false

        // Set Auto Layout constraints to match the bounds of graphView2
        NSLayoutConstraint.activate([
            hostingController3.view.leadingAnchor.constraint(equalTo: gView6.leadingAnchor),
            hostingController3.view.trailingAnchor.constraint(equalTo: gView6.trailingAnchor),
            hostingController3.view.topAnchor.constraint(equalTo: gView6.topAnchor),
            hostingController3.view.bottomAnchor.constraint(equalTo: gView6.bottomAnchor)
        ])
        // Notify the hosting controller that it has been moved to the parent view controller
        hostingController3.didMove(toParent: self)
    }
    
    private func fetchTeamGameLogs(for teamID: UUID) async {
        do {
            // Fetch game logs for the specified team
            let response = try await supabase
                .from("GameLog")
                .select("*")
                .eq("teamID", value: teamID.uuidString)
                .execute()

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let teamGameLogs = try decoder.decode([GameLogtable].self, from: response.data)

            guard !teamGameLogs.isEmpty else { return }

            // MARK: Calculate team metrics
            let totalPoints = teamGameLogs.reduce(0) { $0 + ($1.points2 * 2 + $1.points3 * 3 + $1.freeThrows) }
            let gamesPlayed = Set(teamGameLogs.map { $0.gameID }).count
            let pointsPerGameValue = gamesPlayed > 0 ? Double(totalPoints) / Double(gamesPlayed) : 0

            let firstGamePoints = teamGameLogs.first.map { $0.points2 * 2 + $0.points3 * 3 + $0.freeThrows } ?? 0
            let lastGamePoints = teamGameLogs.last.map { $0.points2 * 2 + $0.points3 * 3 + $0.freeThrows } ?? 0
            let scoringPercentageIncrease = firstGamePoints == 0 ? 0 : (Double(lastGamePoints - firstGamePoints) / Double(firstGamePoints)) * 100

            let totalRebounds = teamGameLogs.reduce(0) { $0 + $1.rebounds }
            let avgRebounds = gamesPlayed > 0 ? Double(totalRebounds) / Double(gamesPlayed) : 0

            let firstGameRebounds = teamGameLogs.first?.rebounds ?? 0
            let lastGameRebounds = teamGameLogs.last?.rebounds ?? 0
            let reboundsPercentageIncrease = firstGameRebounds == 0 ? 0 : (Double(lastGameRebounds - firstGameRebounds) / Double(firstGameRebounds)) * 100

            let totalAssists = teamGameLogs.reduce(0) { $0 + $1.assists }
            let totalTurnovers = teamGameLogs.reduce(0) { $0 + $1.fouls }
            let assistsToTurnoverRatio = totalTurnovers == 0 ? "N/A" : "\(totalAssists):\(totalTurnovers)"

            // MARK: Update UI on the main thread
            DispatchQueue.main.async {
                self.totalPointsScoredLabel.text = "\(totalPoints)"
                self.gamesPlayedLabel.text = "\(gamesPlayed)"
                self.pointsPerGame.text = String(format: "%.1f", pointsPerGameValue)
                self.percentageIncrease.text = String(format: "%.2f%%", scoringPercentageIncrease)
                self.percentageIncrease.textColor = scoringPercentageIncrease < 0 ? .red : .green

                self.reboundsNumber.text = String(format: "%.1f", avgRebounds)
                self.reboundsPercentageIncrease.text = String(format: "%.2f%%", reboundsPercentageIncrease)
                self.reboundsPercentageIncrease.textColor = reboundsPercentageIncrease < 0 ? .red : .green

                self.assistsToTurnoverLabel.text = assistsToTurnoverRatio

                // self.drawLineGraph(in: self.scoringEfficiencyLineGraphView, dataPoints: pointsData)
                // self.drawLineGraph(in: self.reboundsIncreaseLineGraphView, dataPoints: reboundsData)
            }
        } catch {
            print("Error fetching team game logs: \(error)")
        }
    }
    
    func fetchteamGameData() {
            Task {
                guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                    print("Error: No session user is set")
                    return
                }
                
                do {
                    let gameLogsResponse = try await supabase
                        .from("GameLog")
                        .select("*")
                        .eq("playerID", value: sessionUserID.uuidString)
                        .execute()
                    let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)

                    let gamesResponse = try await supabase
                        .from("Game")
                        .select("*")
                        .execute()
                    let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)

                    DispatchQueue.main.async {
                        self.addSwiftUIChart(gameLogs: gameLogs, games: games)
                    }
                } catch {
                    print("Error fetching data: \(error)")
                }
            }
        }

        func addteamSwiftUIChart(gameLogs: [GameLogtable], games: [GameTable]) {
            let chartView = UIHostingController(rootView: teamPointsScoredChart(gameLogs: gameLogs, games: games, teamID: (teamID ?? teamid)!))
            addChild(chartView)
            chartView.view.frame = gView1.bounds
            chartView.view.translatesAutoresizingMaskIntoConstraints = false
            gView1.addSubview(chartView.view)
            
            NSLayoutConstraint.activate([
                chartView.view.leadingAnchor.constraint(equalTo: gView1.leadingAnchor),
                chartView.view.trailingAnchor.constraint(equalTo: gView1.trailingAnchor),
//                chartView.view.topAnchor.constraint(equalTo: scoringEfficiencyLineGraphView.topAnchor),
//                chartView.view.bottomAnchor.constraint(equalTo: scoringEfficiencyLineGraphView.bottomAnchor)
            ])
            
            chartView.didMove(toParent: self)
        }
    
    func fetchteamGameData1() {
        Task {
            guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                print("Error: No session user is set")
                return
            }

            do {
                let gameLogsResponse = try await supabase
                    .from("GameLog")
                    .select("*")
                    .eq("playerID", value: sessionUserID.uuidString)
                    .execute()
                let gameLogs = try JSONDecoder().decode([GameLogtable].self, from: gameLogsResponse.data)

                let gamesResponse = try await supabase
                    .from("Game")
                    .select("*")
                    .execute()
                let games = try JSONDecoder().decode([GameTable].self, from: gamesResponse.data)

                DispatchQueue.main.async {
                    self.addSwiftUIChart1(gameLogs: gameLogs, games: games)
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }

    func addteamSwiftUIChart1(gameLogs: [GameLogtable], games: [GameTable]) {
        let chartView = UIHostingController(rootView: teamReboundsTakenChart(gameLogs: gameLogs, games: games, teamID: teamID!)) // Use ReboundsTakenChart
        addChild(chartView)
        chartView.view.frame = gView2.bounds // ✅ Change view to "reboundsIncreaseLinceGraphView"
        //chartView.view.translatesAutoresizingMaskIntoConstraints = false
        gView2.addSubview(chartView.view)

        NSLayoutConstraint.activate([

            chartView.view.topAnchor.constraint(equalTo: gView2.topAnchor),
            chartView.view.bottomAnchor.constraint(equalTo: gView2.bottomAnchor)
        ])
        chartView.didMove(toParent: self)
    }

}


//
////MARK: Graph drawing function remains the same
//func drawLineGraph(in view: UIView, dataPoints: [CGFloat]) {
//// Ensure the graph is clipped within the view bounds
//view.clipsToBounds = true
//
//// Clear existing layers and subviews
//view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//view.subviews.forEach { $0.removeFromSuperview() }
//
//guard !dataPoints.isEmpty else { return } // Avoid errors with empty data
//
//let path = UIBezierPath()
//let width = view.bounds.width
//let height = view.bounds.height
//let padding: CGFloat = 10.0 // Padding for the graph
//
//// Normalize data to fit within the view
//let maxDataPoint = dataPoints.max() ?? 1
//let minDataPoint = dataPoints.min() ?? 0
//let range = maxDataPoint - minDataPoint
//let scaleFactor = range > 0 ? (height - 2 * padding) / range : 1.0
//
//// Start the path
//path.move(to: CGPoint(
//    x: padding,
//    y: height - padding - ((dataPoints[0] - minDataPoint) * scaleFactor)
//))
//
//for (index, value) in dataPoints.enumerated() {
//    let x = CGFloat(index) * (width - 2 * padding) / CGFloat(dataPoints.count - 1) + padding
//    let y = height - padding - ((value - minDataPoint) * scaleFactor)
//    path.addLine(to: CGPoint(x: x, y: y))
//}
//
//// Create and style the shape layer
//let shapeLayer = CAShapeLayer()
//shapeLayer.path = path.cgPath
//shapeLayer.strokeColor = UIColor.systemRed.cgColor
//shapeLayer.lineWidth = 2
//shapeLayer.fillColor = UIColor.clear.cgColor
//
//// Add animation
//let animation = CABasicAnimation(keyPath: "strokeEnd")
//animation.fromValue = 0
//animation.toValue = 1
//animation.duration = 1.5
//shapeLayer.add(animation, forKey: "lineAnimation")
//
//view.layer.addSublayer(shapeLayer)
//
//// Add dots at data points
//for (index, value) in dataPoints.enumerated() {
//    let x = CGFloat(index) * (width - 2 * padding) / CGFloat(dataPoints.count - 1) + padding
//    let y = height - padding - ((value - minDataPoint) * scaleFactor)
//    let dot = UIView(frame: CGRect(x: x - 2.5, y: y - 2.5, width: 5, height: 5))
//    dot.backgroundColor = UIColor.systemRed
//    dot.layer.cornerRadius = 2.5
//    view.addSubview(dot)
//}
//}
//
//
////MARK: New scatter plot function
//func drawScatterPlot(in view: UIView, dataPoints: [(CGFloat, CGFloat)]) {
//let width = view.bounds.width
//let height = view.bounds.height
//
//// Determine max values for scaling
//let maxAssists = dataPoints.map { $0.0 }.max() ?? 1
//let maxTurnovers = dataPoints.map { $0.1 }.max() ?? 1
//
//// Add dots for each assist-turnover pair
//for (assists, turnovers) in dataPoints {
//    let x = assists / maxAssists * width
//    let y = height - (turnovers / maxTurnovers * height) // Invert Y-axis for UI coordinate system
//    let dot = UIView(frame: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
//    dot.backgroundColor = UIColor.systemBlue
//    dot.layer.cornerRadius = 4
//    view.addSubview(dot)
//}
//
//// Add axes
//addAxes(to: view)
//}
//
////MARK: Helper function to add axes
//func addAxes(to view: UIView) {
//let width = view.bounds.width
//let height = view.bounds.height
//
//let xAxis = UIView(frame: CGRect(x: 0, y: height - 1, width: width, height: 1))
//xAxis.backgroundColor = .black
//view.addSubview(xAxis)
//
//let yAxis = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: height))
//yAxis.backgroundColor = .black
//view.addSubview(yAxis)
//}
////MARK: FETCH PLAYERS

