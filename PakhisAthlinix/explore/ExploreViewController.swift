//
//  ViewController.swift
//  explore
//
//  Created by admin65 on 17/11/24.
//

import UIKit
import SDWebImage
//import SDWebImageWebPCoder  // Import the missing module


class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts101 = [PostsTable]()

        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            
            // Fetch posts asynchronously
            Task {
                await fetchPosts()
            }
            
            //SDImageCodersManager.shared.addCoder(SDImagePNGCoder.shared)
        }

        // Function to fetch posts from Supabase
        func fetchPosts() async {
            do {
                // Fetch posts from Supabase
                let postsResponse = try await supabase.from("posts").select("*").execute()
                let postsDecoder = JSONDecoder()
                posts101 = try postsDecoder.decode([PostsTable].self, from: postsResponse.data)
                
                // Reload the table view with fetched data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching posts: \(error)")
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts101.count
        }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        let post = posts101[indexPath.row]

        // Configure cell asynchronously
        Task {
            do {
                // Fetch user data
                let userResponse = try await supabase.from("User").select("*").eq("userID", value: post.createdBy).single().execute()
                let userDecoder = JSONDecoder()
                let user = try userDecoder.decode(Usertable.self, from: userResponse.data)

                DispatchQueue.main.async {
                                       cell.athleteNameLabel.text = user.name
                                       cell.profileImageView.image = UIImage(named: (user.profilePicture!.isEmpty ? "defaultProfile" : user.profilePicture)!)
                                   }
                               } catch {
                                   print("Error fetching user data: \(error)")
                                   DispatchQueue.main.async {
                                       cell.athleteNameLabel.text = " "
                                       cell.profileImageView.image = UIImage(named: "defaultProfile")
                                   }
                               }

            // Fetch linked game and team data
            if let linkedGameID = post.linkedGameID {
                do {
                    let gameResponse = try await supabase.from("Game").select("*").eq("gameID", value: linkedGameID).single().execute()
                    let gameDecoder = JSONDecoder()
                    let game = try gameDecoder.decode(GameTable.self, from: gameResponse.data)

                    let teamResponse = try await supabase.from("teams").select("*").eq("teamID", value: game.team1ID).single().execute()
                    let teamDecoder = JSONDecoder()
                    let team = try teamDecoder.decode(TeamTable.self, from: teamResponse.data)

                    DispatchQueue.main.async {
                        cell.teamNameLabel.text = team.teamName
                        if let teamLogoURL = team.teamLogo, !teamLogoURL.isEmpty {
                            cell.teamLogoImageView.sd_setImage(with: URL(string: teamLogoURL), placeholderImage: UIImage(named: "defaultTeamLogo"))
                        } else {
                            cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
                        }
                    }
                } catch {
                    print("Error fetching game or team data: \(error)")
                    DispatchQueue.main.async {
                        cell.teamNameLabel.text = " "
                        cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.teamNameLabel.text = " "
                    cell.teamLogoImageView.image = UIImage(named: "defaultTeamLogo")
                }
            }

            // Load post images using SDWebImage
            DispatchQueue.main.async {
                if !post.image1.isEmpty {
                    cell.imageView1.sd_setImage(with: URL(string: post.image1), placeholderImage: UIImage(named: "placeholderImage"))
                }
                if !post.image2.isEmpty {
                    cell.imageView2.sd_setImage(with: URL(string: post.image2), placeholderImage: UIImage(named: "placeholderImage"))
                }
                if !post.image3.isEmpty {
                    cell.imageView3.sd_setImage(with: URL(string: post.image3), placeholderImage: UIImage(named: "placeholderImage"))
                }
            }
        }

        return cell
    }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 338
        }
    }
