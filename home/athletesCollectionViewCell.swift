//
//  athletesCollectionViewCell.swift
//  Home
//
//  Created by admin65 on 18/11/24.
//

import UIKit

class athletesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var athleteProfileImageView: UIImageView!
    
    @IBOutlet weak var athleteNameLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        athleteProfileImageView.layer.cornerRadius = athleteProfileImageView.frame.width / 2
        athleteProfileImageView.clipsToBounds = true
        }
    
    func configure(with stats: AthleteMainStats) {
        athleteProfileImageView.image = UIImage(named: stats.profilePicture)
        athleteNameLabel.text = stats.username
        athleteNameLabel.text = stats.name
    }

}
