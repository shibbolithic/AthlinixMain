//
//  AddPostViewController.swift
//  PakhisAthlinix
//
//  Created by admin65 on 09/01/25.
//

import UIKit
import Storage
import Supabase

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    
    @IBOutlet weak var linkedGameTextField1: UITextField!

    
   // @IBOutlet weak var linkedGameTextField1: UITextField?

    
    
    @IBOutlet weak var addPostButton: UIButton!
    
    var selectedImageView: UIImageView?
    var gameSuggestions: [GameTable] = [] // Populate this with games played by the user.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageTapGestures()
        setupBackButton()
        
        //        if let textField = linkedGameTextField1 {
        //               textField.delegate = self
        //           } else {
        //               print("Error: linkedGameTextField is not connected or loaded")
        //           }
    }
    
    private func setupImageTapGestures() {
        if let image1 = image1 {
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
            image1.addGestureRecognizer(tap1)
            image1.isUserInteractionEnabled = true
        }
        
        if let image2 = image2 {
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
            image2.addGestureRecognizer(tap2)
            image2.isUserInteractionEnabled = true
        }
        
        if let image3 = image3 {
            let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
            image3.addGestureRecognizer(tap3)
            image3.isUserInteractionEnabled = true
        }
    }
    

    
    @objc private func selectImage(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        selectedImageView = imageView
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImageView?.image = selectedImage
        }
    }
    
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        Task { @MainActor in
            guard validateInputs() else {
                print("Error: All required fields must be filled")
                return
            }
            
            await savePostToSupabase()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
           if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
               // Present the AddTeamViewController
               homeVC.modalPresentationStyle = .fullScreen // or .overFullScreen if you want a different style
               self.present(homeVC, animated: true, completion: nil)
           } else {
               print("Could not instantiate AddPostViewController")
           }
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
    
    private func validateInputs() -> Bool {
        if image1.image == nil && image2.image == nil && image3.image == nil {
            print("Error: At least one image must be selected")
            return false
        }
        
        if captionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            print("Error: Caption cannot be empty")
            return false
        }
        
//        if linkedGameTextField1.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
//            print("Error: Linked game must be selected")
//            return false
//        }
        
        return true
    }
    
    private func savePostToSupabase() async {
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
            print("Error: No session user is set")
            return
        }
        
        let postID = UUID() // Generate post UUID
        
        Task {
            do {
                let imagePaths = try await uploadImages(postID: postID)
                print("Uploaded image paths: \(imagePaths)")

                let newPost = PostsTable(
                    postID: postID,
                    createdBy: sessionUserID,
                    content: captionTextField.text ?? "",
                    image1: imagePaths.count > 0 ? imagePaths[0] : "",
                    image2: imagePaths.count > 1 ? imagePaths[1] : "",
                    image3: imagePaths.count > 2 ? imagePaths[2] : "",
                    linkedGameID: nil,
                    likes: 0
                )
                print("New post object created: \(newPost)")

                try await supabase
                    .from("posts")
                    .insert(newPost)
                    .execute()
                
                print("Post successfully added!")
                DispatchQueue.main.async {
                                self.showSuccessAlert()
                            }
            } catch {
                print("Error saving post: \(error)")
            }
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Post added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    private func uploadImages(postID: UUID) async throws -> [String] {
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
            throw NSError(domain: "UploadError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No session user is set"])
        }
        
        let images = [image1.image, image2.image, image3.image]
        var uploadedPaths: [String] = []
        
        for (index, image) in images.enumerated() {
            guard let image = image, let imageData = image.pngData() else {
                uploadedPaths.append("") // Append an empty string if no image is present
                continue
            }
            
            let fileName = "image\(index + 1).png"
            let path = "\(sessionUserID.uuidString)/\(postID.uuidString)/\(fileName)"
            
            try await supabase.storage
                .from("pointt")
                .upload(path: path, file: imageData, options: FileOptions(contentType: "image/png"))
            
            let publicURL = try await supabase.storage.from("pointt").getPublicURL(path: path)
            uploadedPaths.append(publicURL.absoluteString) // Convert URL to String
        }
        
        return uploadedPaths
    }

    private func uploadImages12() async throws -> [String] {
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
            print("Error: No session user is set")
            return []
        }
        
        // Fetch the number of existing posts by this user to determine postNumber
        let existingPosts = try await supabase
            .from("posts")
            .select("postID")
            .eq("createdBy", value: sessionUserID)
            .execute()
        
        let postNumber = (existingPosts.count ?? 0) + 1
        let postFolder = "public/posts/\(sessionUserID)/post\(postNumber)"
        
        let images = [image1.image, image2.image, image3.image]
        var uploadedPaths: [String] = []
        
        for (index, image) in images.enumerated() {
            guard let image = image, let imageData = image.pngData() else {
                uploadedPaths.append("") // Append an empty string if no image is present
                continue
            }
            
            let fileName = "image\(index + 1).png"
            let path = "\(postFolder)/\(fileName)"
            
            try await supabase.storage
                .from("pointt")
                .upload(path: path, file: imageData, options: FileOptions(contentType: "image/png"))
            
            let publicURL = try await supabase.storage.from("pointt").getPublicURL(path: path)
            uploadedPaths.append(publicURL.absoluteString)
        }
        
        return uploadedPaths
    }

    
    private func uploadImages101() async throws -> [String] {
        
        guard let sessionUserID = await SessionManager.shared.getSessionUser() else {
                print("Error: No session user is set")
                return []
            }

        let images = [image1.image, image2.image, image3.image]
        var uploadedPaths: [String] = []
        
        for (index, image) in images.enumerated() {
            guard let image = image, let imageData = image.pngData() else {
                uploadedPaths.append("") // Append an empty string if no image is present
                continue
            }
            
            let fileName = "image\(index + 1).png"
            let path = "public/posts/\(fileName)"
            
            try await supabase.storage
                .from("pointt")
                .upload(path: path, file: imageData, options: FileOptions(contentType: "image/png"))
            
            let publicURL = try await supabase.storage.from("pointt").getPublicURL(path: path)
            uploadedPaths.append(publicURL.absoluteString) // Convert URL to String
        }
        
        return uploadedPaths
    }

}

//extension AddPostViewController: UITableViewDelegate, UITableViewDataSource {

    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == linkedGameTextField1 {
//            // Show a dropdown or table view for suggestions
//            fetchUserGames()
//        }
//        return true
//    }
//    
//    private func fetchUserGames() {
//        Task {
//            do {
//                // Replace with actual userID from session
//                let sessionUserID = SessionManager.shared.getSessionUser()
//                
//                // Fetch games from Supabase
//                let response = try await supabase
//                    .from("GameTable")
//                    .select()
//                    .execute()
//                
//                let decoder = JSONDecoder()
//                let games = try decoder.decode([GameTable].self, from: response.data)
////                let games: [GameTable] = try response.decode()
//                gameSuggestions = games.filter { game in
//                    game.team1ID == sessionUserID || game.team2ID == sessionUserID
//                }
//                
//                // Reload your table view or dropdown with these suggestions
//            } catch {
//                print("Error fetching games: \(error)")
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return gameSuggestions.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
//        let game = gameSuggestions[indexPath.row]
//        cell.textLabel?.text = "\(game.team1ID) vs \(game.team2ID)"
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedGame = gameSuggestions[indexPath.row]
//        linkedGameTextField1.text = "\(selectedGame.team1ID) vs \(selectedGame.team2ID)"
//        linkedGameTextField1.resignFirstResponder()
//    }
//}



