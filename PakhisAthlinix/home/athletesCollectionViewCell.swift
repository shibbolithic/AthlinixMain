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
    
    func configure(with user: User) {
           // Set user name
        athleteNameLabel.text = user.name
           
           // Set profile image (assuming you have a profile picture or a placeholder)
           if let profileImage = UIImage(named: user.profilePicture) {
               athleteProfileImageView.image = profileImage
           } else {
               athleteProfileImageView.image = UIImage(named: "placeholder")  // Fallback image
           }
           
        
       }

}

//import UIKit
//import Supabase
//
//class AthletesViewController: UIViewController, UICollectionViewDataSource {
//    @IBOutlet weak var collectionView: UICollectionView!
//    private var athletes: [Usertable] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.dataSource = self
//        fetchAthletes()
//    }
//
//    func fetchAthletes() {
//        Task {
//            do {
//                let fetchedAthletes = try await Supabasecl.database
//                    .from("Usertable")
//                    .select("*")
//                    .eq("role", "athlete")
//                    .decode([Usertable].self)
//
//                athletes = fetchedAthletes
//                collectionView.reloadData()
//            } catch {
//                print("Error fetching athletes: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return athletes.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "athletesCollectionViewCell", for: indexPath) as? athletesCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        let athlete = athletes[indexPath.row]
//        cell.configure(with: athlete)
//        return cell
//    }
//}
