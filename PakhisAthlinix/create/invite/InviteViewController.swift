//
//  InviteViewController.swift
//  Athlinix
//
//  Created by Vivek Jaglan on 12/22/24.
//

import UIKit

class InviteViewController: UIViewController {
    
    
    
    @IBOutlet weak var InvitePeopleTableViewOutlet: UITableView!
    
    private var teams: [TeamTable] = []
    var delegate: InviteDelegate?
    
    let cellReuseIdentifier = "InivitePeopleCellTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InvitePeopleTableViewOutlet.delegate = self
        InvitePeopleTableViewOutlet.dataSource = self
        
        fetchTeams()
    }
    
    private func fetchTeams() {
        Task {
            do {
                let response: [TeamTable] = try await supabase
                    .from("teams")
                    .select()
                    .execute()
                    .value
                
                self.teams = response
                print("Fetched Teams: \(response)")
                
                DispatchQueue.main.async {
                    self.InvitePeopleTableViewOutlet.reloadData()
                }
            } catch {
                print("Failed to fetch teams: \(error.localizedDescription)")
            }
        }
    }
}

extension InviteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? InivitePeopleCellTableViewCell else {
            fatalError("Unable to dequeue InivitePeopleCellTableViewCell")
        }
        
        let team = teams[indexPath.row]
        cell.nameLabelOutlet.text = team.teamName
        cell.dateLabelOutlet.text = "Created on: \(team.createdBy)"
        
        if let logoURL = team.teamLogo {
            // Load image (e.g., with Kingfisher or another library)
            print(!logoURL.isEmpty)
            cell.logoImageOutlet.image = UIImage(named: team.teamLogo!)
        } else {
            cell.logoImageOutlet.image = UIImage(named: "team1")
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeam = teams[indexPath.row]
        delegate?.didSelectTeam(selectedTeam)
        self.dismiss(animated: true, completion: nil)
    }
}

extension InviteViewController: ButtonCelldelegate {
    
    func addButtonTapped(in cell: InivitePeopleCellTableViewCell) {
        guard let indexPath = InvitePeopleTableViewOutlet.indexPath(for: cell) else { return }
        let selectedTeam = teams[indexPath.row]
        delegate?.didSelectTeam(selectedTeam)
        print("Selected team: \(selectedTeam.teamName)")
        self.dismiss(animated: true, completion: nil)
    }
    
    func logoButtonTapped(in cell: InivitePeopleCellTableViewCell) {
        print("Logo button tapped for cell at index: \(InvitePeopleTableViewOutlet.indexPath(for: cell)?.row ?? -1)")
    }

}
