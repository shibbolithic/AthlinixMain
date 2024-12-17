//
//  TeamCollectionViewCell.swift
//  PakhisAthlinix
//
//  Created by admin65 on 16/12/24.
//


import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    func configure(with team: Teams) {
        // Set team name, logo, etc.
        teamName.text = team.teamName
        teamImage.image = UIImage(named: team.teamLogo)
    }

}
