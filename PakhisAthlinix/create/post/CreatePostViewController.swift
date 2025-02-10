// Global posts array
import UIKit
import Supabase

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK: - UI Components
        private let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            return view
        }()
        
        private let cancelButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Cancel", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(CreatePostViewController.self, action: #selector(didTapCancel), for: .touchUpInside)
            return button
        }()
        
        private let postButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Post", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(CreatePostViewController.self, action: #selector(didTapPost), for: .touchUpInside)
            return button
        }()
        
        private let captionTextView: UITextView = {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.text = "I'am happy to share..."
            textView.textColor = .darkGray
            return textView
        }()
        
        private let photoContainer: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            return stackView
        }()
        
        private let locationTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Add location"
            textField.borderStyle = .roundedRect
            return textField
        }()
        
        private let teamTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Tag a team (optional)"
            textField.borderStyle = .roundedRect
            return textField
        }()
        
        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            setupUI()
            setupBackButton()
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            // Header
            view.addSubview(headerView)
            headerView.addSubview(cancelButton)
            headerView.addSubview(postButton)
            
            // Caption
            view.addSubview(captionTextView)
            
            // Photos
            view.addSubview(photoContainer)
            for _ in 0..<3 {
                let imageView = UIImageView()
                imageView.backgroundColor = .systemGray5
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 8
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddPhoto)))
                photoContainer.addArrangedSubview(imageView)
            }
            
            // Location
            view.addSubview(locationTextField)
            
            // Team
            view.addSubview(teamTextField)
            
            // Constraints
            applyConstraints()
        }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    // Back button action
    @objc private func backButtonTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
           if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
               // Present the AddTeamViewController
               homeVC.modalPresentationStyle = .fullScreen // or .overFullScreen if you want a different style
               self.present(homeVC, animated: true, completion: nil)
           } else {
               print("Could not instantiate AddPostViewController")
           }
    }
    
        
        private func applyConstraints() {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            postButton.translatesAutoresizingMaskIntoConstraints = false
            captionTextView.translatesAutoresizingMaskIntoConstraints = false
            photoContainer.translatesAutoresizingMaskIntoConstraints = false
            locationTextField.translatesAutoresizingMaskIntoConstraints = false
            teamTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // Header
                headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 50),
                
                cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                postButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                postButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                // Caption
                captionTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
                captionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                captionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                captionTextView.heightAnchor.constraint(equalToConstant: 100),
                
                // Photo Container
                photoContainer.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 16),
                photoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                photoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                photoContainer.heightAnchor.constraint(equalToConstant: 80),
                
                // Location
                locationTextField.topAnchor.constraint(equalTo: photoContainer.bottomAnchor, constant: 16),
                locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                locationTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Team
                teamTextField.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 16),
                teamTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                teamTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                teamTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        // MARK: - Actions
        @objc private func didTapCancel() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc private func didTapPost() {
            // Implement post creation logic here
            print("Post button tapped")
        }
        
        @objc private func didTapAddPhoto(_ sender: UITapGestureRecognizer) {
            guard let tappedImageView = sender.view as? UIImageView else { return }
            // Implement photo selection logic here
            print("Photo tapped")
        }
    }
