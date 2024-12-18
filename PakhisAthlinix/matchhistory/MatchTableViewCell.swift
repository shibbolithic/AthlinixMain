//
//  MatchTableViewCell.swift
//  MatchHistory
//
//  Created by admin65 on 14/11/24.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeFieldGoalsLabel: UILabel!
    @IBOutlet weak var homeThreePointersLabel: UILabel!
    @IBOutlet weak var homeFreeThrowsLabel: UILabel!
    @IBOutlet weak var awayFieldGoalsLabel: UILabel!
    @IBOutlet weak var awayThreePointersLabel: UILabel!
    @IBOutlet weak var awayFreeThrowsLabel: UILabel!
    
    
    
    func configure(with gameStats: (team1Name: String, team1Logo: String, team2Name: String, team2Logo: String, team1Stats: [String: Int], team2Stats: [String: Int])) {
           homeTeamNameLabel.text = gameStats.team1Name
           awayTeamNameLabel.text = gameStats.team2Name
           
           // Assuming you have a method to load images from URLs or asset names
           homeTeamLogo.image = UIImage(named: gameStats.team1Logo)
           awayTeamLogo.image = UIImage(named: gameStats.team2Logo)
           
           // Set stats from gameStats
           homeFieldGoalsLabel.text = "\(gameStats.team1Stats["2pt Field Goals"] ?? 0)"
           homeThreePointersLabel.text = "\(gameStats.team1Stats["3pt Field Goals"] ?? 0)"
           homeFreeThrowsLabel.text = "\(gameStats.team1Stats["Free Throws"] ?? 0)"
           
           awayFieldGoalsLabel.text = "\(gameStats.team2Stats["2pt Field Goals"] ?? 0)"
           awayThreePointersLabel.text = "\(gameStats.team2Stats["3pt Field Goals"] ?? 0)"
           awayFreeThrowsLabel.text = "\(gameStats.team2Stats["Free Throws"] ?? 0)"
       }
    
}
