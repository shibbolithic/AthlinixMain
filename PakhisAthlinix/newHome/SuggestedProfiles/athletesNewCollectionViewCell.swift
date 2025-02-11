//
//  athletesCollectionViewCell.swift
//  Home
//
//  Created by admin65 on 18/11/24.
//

import UIKit

class athletesNewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var athleteProfileImageView: UIImageView!
    
    @IBOutlet weak var athleteNameLabel: UILabel!
    
    @IBOutlet weak var ProfileCardOutlet: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ProfileCardOutlet.layer.cornerRadius = 16
        ProfileCardOutlet.clipsToBounds = true
        ProfileCardOutlet.contentMode = .scaleAspectFit
    }
    
    func configure(with user: Usertable) {
           // Set user name
        athleteNameLabel.text = user.username
           
           // Set profile image (assuming you have a profile picture or a placeholder)
        if let profileImage = UIImage(named: user.profilePicture!) {
               athleteProfileImageView.image = profileImage
           } else {
               athleteProfileImageView.image = UIImage(named: "placeholder")  // Fallback image
           }
        
        athleteProfileImageView.layer.cornerRadius = 15

           
        
       }

}
