////
////  ProfilePostCell.swift
////  PakhisAthlinix
////
////  Created by admin65 on 16/12/24.
////
//
//
//
import UIKit
//
class ViewProfilePostCell: UITableViewCell {
    
    
    @IBOutlet weak var athleteNameLabel: UILabel!      // Displays the athlete's name
    @IBOutlet weak var profileImageView: UIImageView!  // Displays the athlete's profile picture
    @IBOutlet weak var teamNameLabel: UILabel!         // Displays the team name
    @IBOutlet weak var teamLogoImageView: UIImageView! // Displays the
    
    @IBOutlet weak var imageView1: UIImageView!        // First feed image
    @IBOutlet weak var imageView2: UIImageView!        // Second feed image
    @IBOutlet weak var imageView3: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
        }
    
}
