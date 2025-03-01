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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        teamImage.layer.cornerRadius = teamImage.frame.height / 2
        teamImage.clipsToBounds = true
    }
    
    func configure(with team: TeamTable) {
        // Set team name, logo, etc.
        teamName.text = team.teamName
        teamImage.image = UIImage(named: team.teamLogo!)
    }

}
