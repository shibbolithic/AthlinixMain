//
//  ViewController.swift
//  explore
//
//  Created by admin65 on 17/11/24.
//

import UIKit

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
   
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]

        // User setup
        if let user = users.first(where: { $0.userID == post.createdBy }) {
            cell.athleteNameLabel.text = user.name
            cell.profileImageView.image = UIImage(named: user.profilePicture.isEmpty ? "defaultProfile" : user.profilePicture)
        } else {
            cell.athleteNameLabel.text = " "
            cell.profileImageView.image = UIImage(named: "defaultProfile")
        }

        // Team setup
        if let linkedGameID = post.linkedGameID,
           let game = games.first(where: { $0.gameID == linkedGameID }),
           let team = teams.first(where: { $0.teamID == game.team1ID }) {
            cell.teamNameLabel.text = team.teamName
            cell.teamLogoImageView.image = UIImage(named: team.teamLogo.isEmpty ? "defaultTeamLogo" : team.teamLogo)
        } else {
            cell.teamNameLabel.text = "Unknown Team"
            cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
        }

        // Post images
        cell.imageView1.image = UIImage(named: post.image1)
        cell.imageView2.image = UIImage(named: post.image2)
        cell.imageView3.image = UIImage(named: post.image3)

        return cell
    }



        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 338
        }
    }
