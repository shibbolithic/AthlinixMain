//
import Foundation
import UIKit
//
//// Athlinix Data Model Implementation in Swift
//enum UserRole {
//    case athlete
//    case coach
//}
//
//// MARK: - User
//class User {
//    let userID: String
//    var username: String
//    var name: String
//    var email: String
//    var password: String
//    var role: UserRole // "Athlete" or "Coach"
//    var profilePicture: String
//    var coverPicture: String?
//    var bio: String
//    var dateJoined: Date
//    var lastLogin: Date?
//
//    init(userID: String, username: String, name: String, email: String, password: String, role: UserRole, profilePicture: String, coverPicture: String? = nil, bio: String, dateJoined: Date, lastLogin: Date? = nil) {
//        self.userID = userID
//        self.username = username
//        self.name = name
//        self.email = email
//        self.password = password
//        self.role = role
//        self.profilePicture = profilePicture
//        self.coverPicture = coverPicture
//        self.bio = bio
//        self.dateJoined = dateJoined
//        self.lastLogin = lastLogin
//    }
//}
//
//// MARK: - Athlete Profile
//class AthleteProfile {
//    let athleteID: String // User ID
//    var height: Double
//    var weight: Double
//    var experience: Int
//    var position: String
//    var averagePointsPerGame: Double
//    var averageReboundsPerGame: Double
//    var averageAssistsPerGame: Double
//
//// MARK: - User
//class User {
//    let userID: String
//    var username: String
//    var name: String
//    var email: String
//    var password: String
//    var role: UserRole // "Athlete" or "Coach"
//    var profilePicture: String
//    var coverPicture: String?
//    var bio: String
//    var dateJoined: Date
//    var lastLogin: Date?
//
//    init(userID: String, username: String, name: String, email: String, password: String, role: UserRole, profilePicture: String, coverPicture: String? = nil, bio: String, dateJoined: Date, lastLogin: Date? = nil) {
//        self.userID = userID
//        self.username = username
//        self.name = name
//        self.email = email
//        self.password = password
//        self.role = role
//        self.profilePicture = profilePicture
//        self.coverPicture = coverPicture
//        self.bio = bio
//        self.dateJoined = dateJoined
//        self.lastLogin = lastLogin
//    }
//}
//
//// MARK: - Athlete Profile
//class AthleteProfile {
//    let athleteID: String // User ID
//    var height: Double
//    var weight: Double
//    var experience: Int
//    var position: String
//    var averagePointsPerGame: Double
//    var averageReboundsPerGame: Double
//    var averageAssistsPerGame: Double
//
//// MARK: - User
//class User {
//    let userID: String
//    var username: String
//    var name: String
//    var email: String
//    var password: String
//    var role: UserRole // "Athlete" or "Coach"
//    var profilePicture: String
//    var coverPicture: String?
//    var bio: String
//    var dateJoined: Date
//    var lastLogin: Date?
//
//    init(userID: String, username: String, name: String, email: String, password: String, role: UserRole, profilePicture: String, coverPicture: String? = nil, bio: String, dateJoined: Date, lastLogin: Date? = nil) {
//        self.userID = userID
//        self.username = username
//        self.name = name
//        self.email = email
//        self.password = password
//        self.role = role
//        self.profilePicture = profilePicture
//        self.coverPicture = coverPicture
//        self.bio = bio
//        self.dateJoined = dateJoined
//        self.lastLogin = lastLogin
//    }
//}
//
//// MARK: - Athlete Profile
//class AthleteProfile {
//    let athleteID: String // User ID
//    var height: Double
//    var weight: Double
//    var experience: Int
//    var position: String
//    var averagePointsPerGame: Double
//    var averageReboundsPerGame: Double
//    var averageAssistsPerGame: Double
//
//// MARK: - User
//class User {
//    let userID: String
//    var username: String
//    var name: String
//    var email: String
//    var password: String
//    var role: UserRole // "Athlete" or "Coach"
//    var profilePicture: String
//    var coverPicture: String?
//    var bio: String
//    var dateJoined: Date
//    var lastLogin: Date?
//
//    init(userID: String, username: String, name: String, email: String, password: String, role: UserRole, profilePicture: String, coverPicture: String? = nil, bio: String, dateJoined: Date, lastLogin: Date? = nil) {
//        self.userID = userID
//        self.username = username
//        self.name = name
//        self.email = email
//        self.password = password
//        self.role = role
//        self.profilePicture = profilePicture
//        self.coverPicture = coverPicture
//        self.bio = bio
//        self.dateJoined = dateJoined
//        self.lastLogin = lastLogin
//    }
//}
//
//// MARK: - Athlete Profile
//class AthleteProfile {
//    let athleteID: String // User ID
//    var height: Double
//    var weight: Double
//    var experience: Int
//    var position: String
//    var averagePointsPerGame: Double
//    var averageReboundsPerGame: Double
//    var averageAssistsPerGame: Double
//
//// MARK: - User
//class User {
//    let userID: String
//    var username: String
//    var name: String
//    var email: String
//    var password: String
//    var role: UserRole // "Athlete" or "Coach"
//    var profilePicture: String
//    var coverPicture: String?
//    var bio: String
//    var dateJoined: Date
//    var lastLogin: Date?
//
//    init(userID: String, username: String, name: String, email: String, password: String, role: UserRole, profilePicture: String, coverPicture: String? = nil, bio: String, dateJoined: Date, lastLogin: Date? = nil) {
//        self.userID = userID
//        self.username = username
//        self.name = name
//        self.email = email
//        self.password = password
//        self.role = role
//        self.profilePicture = profilePicture
//        self.coverPicture = coverPicture
//        self.bio = bio
//        self.dateJoined = dateJoined
//        self.lastLogin = lastLogin
//    }
//}
//
//// MARK: - Athlete Profile
//class AthleteProfile {
//    let athleteID: String // User ID
//    var height: Double
//    var weight: Double
//    var experience: Int
//    var position: String
//    var averagePointsPerGame: Double
//    var averageReboundsPerGame: Double
//    var averageAssistsPerGame: Double
//
//    init(athleteID: String, height: Double, weight: Double, experience: Int, position: String, averagePointsPerGame: Double, averageReboundsPerGame: Double, averageAssistsPerGame: Double) {
//        self.athleteID = athleteID
//        self.height = height
//        self.weight = weight
//        self.experience = experience
//        self.position = position
//        self.averagePointsPerGame = averagePointsPerGame
//        self.averageReboundsPerGame = averageReboundsPerGame
//        self.averageAssistsPerGame = averageAssistsPerGame
//    }
//}
//
//// MARK: - Coach Profile
//class CoachProfile {
//    let coachID: String // User ID
//    var yearsOfExperience: Int
//    var specialization: String
//    var certification: String // Image URL or File Path
//
//    init(coachID: String, yearsOfExperience: Int, specialization: String, certification: String) {
//        self.coachID = coachID
//        self.yearsOfExperience = yearsOfExperience
//        self.specialization = specialization
//        self.certification = certification
//    }
//}
//
//// MARK: - Team
//class Teams {
//    let teamID: String
//    var teamName: String
//    var teamMotto: String
//    var teamLogo: String
//    var createdBy: String // Coach User ID
//    var dateCreated: Date
//
//    init(teamID: String, teamName: String, teamMotto: String, teamLogo: String, createdBy: String, dateCreated: Date) {
//        self.teamID = teamID
//        self.teamName = teamName
//        self.teamMotto = teamMotto
//        self.teamLogo = teamLogo
//        self.createdBy = createdBy
//        self.dateCreated = dateCreated
//    }
//}
//
struct Match {
    let homeTeamLogo: UIImage
    let awayTeamLogo: UIImage
    let homeTeamName: String
    let awayTeamName: String
    let fieldGoals: (home: Int, away: Int)
    let threePointers: (home: Int, away: Int)
    let freeThrows: (home: Int, away: Int)
    let date: Date
}
func createDate(day: Int, month: Int, year: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.day = day
    dateComponents.month = month
    dateComponents.year = year
    let calendar = Calendar.current
    return calendar.date(from: dateComponents) ?? Date()
}
var matches: [Match] = [
    Match(
        homeTeamLogo: UIImage(named: "team1")!,
        awayTeamLogo: UIImage(named: "team2")!,
        homeTeamName: "76ers",
        awayTeamName: "Raptors",
        fieldGoals: (34, 24),
        threePointers: (10, 7),
        freeThrows: (6, 3),
        date: createDate(day: 10, month: 9, year: 2024)
    ),
    Match(
        homeTeamLogo: UIImage(named: "team3")!,
        awayTeamLogo: UIImage(named: "team4")!,
        homeTeamName: "Lakers",
        awayTeamName: "Knicks",
        fieldGoals: (47, 47),
        threePointers: (10, 7),
        freeThrows: (6, 3),
        date: createDate(day: 18, month: 8, year: 2022)
    )
]

//// MARK: - Team Membership
//struct TeamMembership {
//    let membershipID: String
//    let teamID: String
//    let userID: String
//    var roleInTeam: String // "Player" or "Coach"
//    var dateJoined: Date
//}
//
//// MARK: - Game
//class Game {
//    let gameID: String
//    var team1ID: String
//    var team2ID: String
//    var dateOfGame: Date
//    var venue: String
//    var finalScore: String
//
//    init(gameID: String, team1ID: String, team2ID: String, dateOfGame: Date, venue: String, finalScore: String) {
//        self.gameID = gameID
//        self.team1ID = team1ID
//        self.team2ID = team2ID
//        self.dateOfGame = dateOfGame
//        self.venue = venue
//        self.finalScore = finalScore
//    }
//    // Function to update final score based on team and game logs
//        func updateFinalScore(teamID: String, gameLogs: [GameLog]) {
//            let teamLogs = gameLogs.filter { $0.gameID == gameID && $0.teamID == teamID }
//            
//            let totalPointsForTeam = teamLogs.reduce(0) { $0 + $1.totalPoints }
//            
//            // Here, the final score is saved as a string representing the team's total points.
//            self.finalScore = "\(totalPointsForTeam)"
//        }
//}
//
//// MARK: - Game Log
//struct GameLog {
//    let logID: String
//    let gameID: String
//    let teamID: String
//    let playerID: String
//    var points2: Int
//    var points3: Int
//    var freeThrows: Int
//    var rebounds: Int
//    var assists: Int
//    var steals: Int
//    var fouls: Int
//    var missed2Points: Int
//    var missed3Points: Int
//    var totalPoints: Int {
//        return points2 * 2 + points3 * 3
//    }
//}
//
//// MARK: - Post
//struct Post {
//    let postID: String
//    let createdBy: String // User ID
//    var content: String
//    var image1: String
//    var image2: String
//    var image3: String
//    var linkedGameID: String? // Nullable
//    var dateCreated: Date
//    var likes: Int
//}
//
//enum ApprovalStatus{
//  case Pending
//  case Approved
//  case Rejected
//}
//// MARK: - Score Approval
//struct ScoreApproval {
//    let approvalID: String
//    let gameID: String
//    let requestedBy: String // Athlete ID
//    let approvedBy: String // Coach ID
//    var approvalStatus: ApprovalStatus
//    var dateRequested: Date
//    var dateApproved: Date?
//}
//func createGames() -> [Game] {
//    // Define a custom date formatter for creating definite dates
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    
//    // Create specific dates for each game
//    let game1Date = dateFormatter.date(from: "2024-08-01")!
//    let game2Date = dateFormatter.date(from: "2024-09-02")!
//    let game3Date = dateFormatter.date(from: "2024-10-03")!
//    let game4Date = dateFormatter.date(from: "2024-11-04")!
//    let game5Date = dateFormatter.date(from: "2024-12-05")!
//    
//    // Initialize game instances with definite dates
//    return [
//        Game(gameID: "game1", team1ID: "1", team2ID: "2", dateOfGame: game1Date, venue: "Arena 1", finalScore: "20"),
//        Game(gameID: "game2", team1ID: "3", team2ID: "4", dateOfGame: game2Date, venue: "Stadium 1", finalScore: "40"),
//        Game(gameID: "game3", team1ID: "5", team2ID: "1", dateOfGame: game3Date, venue: "Arena 2", finalScore: "162"),
//    ]
//}
//
//let games = createGames()
//func updateScoresForAllGames() {
//    for game in games {
//        // Update final score for both teams in each game
//        game.updateFinalScore(teamID: game.team1ID, gameLogs: gameLogs)
//        game.updateFinalScore(teamID: game.team2ID, gameLogs: gameLogs)
//    }
//}
//// Sample Data for GameLogs (using player IDs, team IDs, and game IDs from earlier)
//var gameLogs: [GameLog] = [
//    // Game 1: Red Warriors vs Blue Sharks
//    GameLog(logID: "log1", gameID: "game1", teamID: "1", playerID: "1", points2: 10, points3: 2, freeThrows: 3, rebounds: 4, assists: 2, steals: 1, fouls: 1, missed2Points: 2, missed3Points: 1),
//
//    // Game 2: Golden Eagles vs Silver Lions
//    GameLog(logID: "log5", gameID: "game2", teamID: "3", playerID: "1", points2: 9, points3: 0, freeThrows: 2, rebounds: 6, assists: 2, steals: 3, fouls: 0, missed2Points: 1, missed3Points: 1),
//    GameLog(logID: "log8", gameID: "game2", teamID: "4", playerID: "4", points2: 11, points3: 0, freeThrows: 1, rebounds: 5, assists: 4, steals: 1, fouls: 1, missed2Points: 0, missed3Points: 1),
//
//    // Game 3: Green Panthers vs Red Warriors
//    GameLog(logID: "log9", gameID: "game3", teamID: "5", playerID: "1", points2: 6, points3: 2, freeThrows: 5, rebounds: 3, assists: 1, steals: 2, fouls: 1, missed2Points: 0, missed3Points: 0),
//
//    // Game 4: Blue Sharks vs Golden Eagles
//   
//    GameLog(logID: "log16", gameID: "game4", teamID: "3", playerID: "4", points2: 8, points3: 1, freeThrows: 3, rebounds: 3, assists: 2, steals: 0, fouls: 0, missed2Points: 0, missed3Points: 0),
//
//    // Game 5: Silver Lions vs Green Panther
//    GameLog(logID: "log18", gameID: "game5", teamID: "4", playerID: "2", points2: 40, points3: 1, freeThrows: 2, rebounds: 5, assists: 3, steals: 0, fouls: 0, missed2Points: 0, missed3Points: 1),
//    GameLog(logID: "log19", gameID: "game5", teamID: "5", playerID: "3", points2: 7, points3: 0, freeThrows: 3, rebounds: 2, assists: 1, steals: 2, fouls: 2, missed2Points: 1, missed3Points: 1),
//    GameLog(logID: "log20", gameID: "game5", teamID: "5", playerID: "4", points2: 6, points3: 1, freeThrows: 4, rebounds: 3, assists: 2, steals: 1, fouls: 0, missed2Points: 0, missed3Points: 0)
//]
//
//var posts: [Post] = [
//    Post(postID: "1", createdBy: "1", content: "Excited to have won the game today!", image1: "game_win1.jpg", image2: "celebration.jpg", image3: "team_photo.jpg", linkedGameID: "1", dateCreated: Date(), likes: 10),
//    Post(postID: "2", createdBy: "2", content: "Had a great workout today! Feeling stronger.", image1: "workout1.jpg", image2: "workout2.jpg", image3: "gym1.jpg", linkedGameID: nil, dateCreated: Date(), likes: 5),
//]
//
//var scoreApprovals: [ScoreApproval] = [
//    // Score Approvals
//    ScoreApproval(approvalID: "scoreApproval1", gameID: "game1", requestedBy: "1", approvedBy: "6", approvalStatus: .Pending, dateRequested: Date()),
//    ScoreApproval(approvalID: "scoreApproval2", gameID: "game2", requestedBy: "2", approvedBy: "7", approvalStatus: .Approved, dateRequested: Date(), dateApproved: Date()),
//    
//]
//var teams: [Teams] = [
//    Teams(teamID: "1", teamName: "Red Warriors", teamMotto: "Victory Awaits", teamLogo: "redWarriorsLogo.jpg", createdBy: "6", dateCreated: Date()),
//    Teams(teamID: "2", teamName: "Blue Sharks", teamMotto: "Unstoppable Force", teamLogo: "blueSharksLogo.jpg", createdBy: "7", dateCreated: Date()),
//  
//]
//
//// MARK: Team Membership Data
//
//var teamMemberships: [TeamMembership] = [
//    // Red Warriors (5 athletes, 1 coach)
//    TeamMembership(membershipID: "1", teamID: "1", userID: "1", roleInTeam: "Player", dateJoined: Date()),
//    TeamMembership(membershipID: "2", teamID: "1", userID: "2", roleInTeam: "Player", dateJoined: Date()),
//   
//    
//    // Blue Sharks (5 athletes, 1 coach)
//    TeamMembership(membershipID: "7", teamID: "2", userID: "1", roleInTeam: "Player", dateJoined: Date()),...
//
//]
//
//var users: [User] = [
//    User(userID: "1", username: "arvind12", name: "Arvind Kumar", email: "arvind@example.com", password: "password123", role: .athlete, profilePicture: "1", bio: "Basketball enthusiast", dateJoined: Date()),
//    User(userID: "2", username: "ravi27", name: "Ravi Shankar", email: "ravi@example.com", password: "password123", role: .athlete, profilePicture: "2", bio: "Aspiring footballer", dateJoined: Date()),
//    User(userID: "3", username: "neha18", name: "Neha Sharma", email: "neha@example.com", password: "password123", role: .athlete, profilePicture: "4", bio: "Track and field athlete", dateJoined: Date()),
//]
//
//var athleteProfiles: [AthleteProfile] = [
//    AthleteProfile(athleteID: "1", height: 5.9, weight: 75.0, experience: 5, position: "Guard", averagePointsPerGame: 12.3, averageReboundsPerGame: 4.5, averageAssistsPerGame: 3.2),
//    AthleteProfile(athleteID: "2", height: 6.0, weight: 80.0, experience: 4, position: "Midfielder", averagePointsPerGame: 15.4, averageReboundsPerGame: 6.3, averageAssistsPerGame: 4.1)
//]
//
//var coachProfiles: [CoachProfile] = [
//    CoachProfile(coachID: "6", yearsOfExperience: 8, specialization: "Basketball", certification: "coachCert1.jpg"),
//    CoachProfile(coachID: "7", yearsOfExperience: 10, specialization: "Football", certification: "coachCert2.jpg")
//]
