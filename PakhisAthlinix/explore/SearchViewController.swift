//
//  SearchViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 07/02/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!
    
    var members: [Usertable] = []
    var filteredMembers: [Usertable] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           userTableView.delegate = self
           userTableView.dataSource = self
           searchbar.delegate = self
           
           fetchMembers()
       }
       
       private func fetchMembers() {
           Task {
               do {
                   let response = try await supabase
                       .from("User")
                       .select("*")
                       .execute()
                   
                   let decoder = JSONDecoder()
                   let users = try decoder.decode([Usertable].self, from: response.data)
                   
                   DispatchQueue.main.async {
                       self.members = users
                       self.filteredMembers = users
                       self.userTableView.reloadData()
                   }
               } catch {
                   print("Error fetching members: \(error)")
               }
           }
       }
   }

   // MARK: - UITableViewDataSource & UITableViewDelegate
   extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredMembers.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
           let user = filteredMembers[indexPath.row]
           
           cell.name.text = user.name
           cell.role.text = user.role.rawValue.capitalized
           
           // Load profile picture asynchronously
//           if let profilePicURL = user.profilePicture, let url = URL(string: profilePicURL) {
//               DispatchQueue.global().async {
//                   if let data = try? Data(contentsOf: url) {
//                       DispatchQueue.main.async {
//                           cell.pfpImageView.image = UIImage(data: data)
//                       }
//                   }
//               }
//           } else {
//               cell.pfpImageView.image = UIImage(systemName: "person.circle")
//               // Default image
//           }
           if let profilePicName = user.profilePicture {
               cell.pfpImageView.image = UIImage(named: profilePicName)
           } else {
               cell.pfpImageView.image = UIImage(systemName: "person.circle") // Default image
           }

           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let selectedUser = filteredMembers[indexPath.row]
               
               // Assuming "ViewUserVC" is the identifier of your ViewUserVC in the storyboard
               if let viewUserVC = storyboard?.instantiateViewController(withIdentifier: "ViewUserViewController") as? ViewUserViewController {
                   
                   // Pass the selected user's data
                   viewUserVC.selectedUserID = selectedUser.userID
                   
                   // Push the ViewUserVC onto the navigation stack
                   navigationController?.pushViewController(viewUserVC, animated: true)
               }
           }
       
   }

   // MARK: - UISearchBarDelegateperfor
   extension SearchViewController: UISearchBarDelegate {
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredMembers = members
           } else {
               filteredMembers = members.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.username.lowercased().contains(searchText.lowercased()) }
           }
           userTableView.reloadData()
       }
   }
