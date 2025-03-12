//
//  TeamPickerDelegate.swift
//  PakhisAthlinix
//
//  Created by admin65 on 11/03/25.
//

import UIKit

protocol TeamPickerDelegate: AnyObject {
    func didSelectTeam(_ teamID: UUID)
}

class TeamPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: TeamPickerDelegate?
    var teams: [TeamTable] = []
    var selectedTeamID: UUID?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 120) // Adjust size
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TeamPickerCell.self, forCellWithReuseIdentifier: "TeamPickerCell")
        
        view.addSubview(collectionView)
        view.addSubview(doneButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func doneButtonTapped() {
        if let selectedTeamID = selectedTeamID {
            delegate?.didSelectTeam(selectedTeamID)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamPickerCell", for: indexPath) as! TeamPickerCell
        let team = teams[indexPath.item]
        
        cell.teamNameLabel.text = team.teamName
        cell.teamLogoImageView.image = UIImage(named: team.teamLogo!)
        
        // Show checkmark if this team is selected
        cell.checkmarkImageView.isHidden = (team.teamID != selectedTeamID)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTeamID = teams[indexPath.item].teamID
        collectionView.reloadData() // Refresh the UI to show checkmark
    }
}

class TeamPickerCell: UICollectionViewCell {
    
    let teamLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        imageView.isHidden = true  // Initially hidden
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(teamLogoImageView)
        contentView.addSubview(teamNameLabel)
        contentView.addSubview(checkmarkImageView)
        
        teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            teamLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            teamLogoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            teamLogoImageView.widthAnchor.constraint(equalToConstant: 80),
            teamLogoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            teamNameLabel.topAnchor.constraint(equalTo: teamLogoImageView.bottomAnchor, constant: 5),
            teamNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            teamNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            checkmarkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
