//
//  PlayerTeamCollectionViewCell.swift
//  PakhisAthlinix
//
//  Created by admin65 on 09/01/25.
//

import UIKit

class PlayerTeamCollectionViewCell: UICollectionViewCell {
        
        @IBOutlet weak var teamImage: UIImageView!
        @IBOutlet weak var teamName: UILabel!
        
        func configure(with team: TeamTable) {
            // Set team name, logo, etc.
            teamName.text = team.teamName
            teamImage.image = UIImage(named: team.teamLogo!)
        }

    }

