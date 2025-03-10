//
//  OpponentTeamMemberCellCollectionViewCell.swift
//  Athlinix
//
//  Created by Vivek Jaglan on 12/31/24.
//

import UIKit

class OpponentTeamMemberCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var NameOutlet: UILabel!
    @IBOutlet weak var UsernameOutlet: UILabel!
    @IBOutlet weak var ProfilePicOutlet: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        // Initialization code
    }
    
    func setupUI() {
        ProfilePicOutlet.layer.cornerRadius = 10
        ProfilePicOutlet.clipsToBounds = true
    }
    
    func configure101(with member: TeamMembershipTable, users: [Usertable]) {
        if let user = users.first(where: { $0.userID == member.userID }) {
            
            NameOutlet.text = user.name
            UsernameOutlet.text = user.username
            ProfilePicOutlet.image = UIImage(named: user.profilePicture!)

        } else {
            NameOutlet.text = "Unknown"
            UsernameOutlet.text = ""
            ProfilePicOutlet.image = UIImage(named: "defaultAvatar")
        }
    }
    
//    func configure(with member: TeamMembershipTable) {
//            // Configure your cell here
//        NameOutlet.text = member.membershipID.uuidString // Assuming TeamMembership has a name property
//            // Configure other UI elements based on your TeamMembership model
//        }

}

//MARK: URL

//            if let profilePictureURL = user.profilePicture, let url = URL(string: profilePictureURL) {
//                // Load image asynchronously
//                DispatchQueue.global().async {
//                    if let data = try? Data(contentsOf: url) {
//                        DispatchQueue.main.async {
//                            self.MemberAvatarOutlet.image = UIImage(data: data)
//                        }
//                    }
//                }
//            } else {
//                // Set a placeholder image if no profile picture
//                self.MemberAvatarOutlet.image = UIImage(named: "defaultAvatar")
//            }
