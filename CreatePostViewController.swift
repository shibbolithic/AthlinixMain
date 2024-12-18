import UIKit

// MARK: - CreatePostViewController
class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Components
    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()
    private let imageView3 = UIImageView()
    private let addImageButton = UIButton()
    private let postButton = UIButton()
    private let separatorView = UIView()
    
    // MARK: - Properties
    var postCompletionHandler: ((Post) -> Void)?
    private var selectedImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Create Post"
        
        // Image View 1
        imageView1.contentMode = .scaleAspectFill
        imageView1.clipsToBounds = true
        imageView1.backgroundColor = .lightGray
        imageView1.layer.borderWidth = 1
        imageView1.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(imageView1)
        
        // Image View 2
        imageView2.contentMode = .scaleAspectFill
        imageView2.clipsToBounds = true
        imageView2.backgroundColor = .lightGray
        imageView2.layer.borderWidth = 1
        imageView2.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(imageView2)
        
        // Image View 3
        imageView3.contentMode = .scaleAspectFill
        imageView3.clipsToBounds = true
        imageView3.backgroundColor = .lightGray
        imageView3.layer.borderWidth = 1
        imageView3.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(imageView3)
        
        // Add Image Button
        addImageButton.setTitle("Add Images", for: .normal)
        addImageButton.setTitleColor(.white, for: .normal)
        addImageButton.backgroundColor = .systemBlue
        addImageButton.layer.cornerRadius = 5
        addImageButton.addTarget(self, action: #selector(addImagesTapped), for: .touchUpInside)
        view.addSubview(addImageButton)
        
        // Post Button
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.backgroundColor = .systemGreen
        postButton.layer.cornerRadius = 5
        postButton.addTarget(self, action: #selector(postTapped), for: .touchUpInside)
        view.addSubview(postButton)
        
        // Separator View
        separatorView.backgroundColor = .gray
        view.addSubview(separatorView)
        
        setupConstraints()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        let spacing: CGFloat = 16
        let imageSize: CGFloat = (view.frame.width - spacing * 4) / 3
        
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            imageView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            imageView1.widthAnchor.constraint(equalToConstant: imageSize),
            imageView1.heightAnchor.constraint(equalToConstant: imageSize),
            
            imageView2.topAnchor.constraint(equalTo: imageView1.topAnchor),
            imageView2.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor, constant: spacing),
            imageView2.widthAnchor.constraint(equalToConstant: imageSize),
            imageView2.heightAnchor.constraint(equalToConstant: imageSize),
            
            imageView3.topAnchor.constraint(equalTo: imageView1.topAnchor),
            imageView3.leadingAnchor.constraint(equalTo: imageView2.trailingAnchor, constant: spacing),
            imageView3.widthAnchor.constraint(equalToConstant: imageSize),
            imageView3.heightAnchor.constraint(equalToConstant: imageSize),
            
            addImageButton.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: spacing),
            addImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            addImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            addImageButton.heightAnchor.constraint(equalToConstant: 50),
            
            separatorView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: spacing),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            postButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: spacing),
            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            postButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Actions
    @objc private func addImagesTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func postTapped() {
        guard !selectedImages.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please add at least one image to create a post.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let post = Post(
            postID: UUID().uuidString,
            createdBy: "user123", // Replace with logged-in user's ID
            content: nil,
            image1: selectedImages.indices.contains(0) ? selectedImages[0].description : "",
            image2: selectedImages.indices.contains(1) ? selectedImages[1].description : "",
            image3: selectedImages.indices.contains(2) ? selectedImages[2].description : "",
            linkedGameID: nil,
            dateCreated: Date(),
            likes: 0
        )
        
        postCompletionHandler?(post)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            selectedImages.append(selectedImage)
            updateImagePreviews()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func updateImagePreviews() {
        if selectedImages.indices.contains(0) {
            imageView1.image = selectedImages[0]
        }
        if selectedImages.indices.contains(1) {
            imageView2.image = selectedImages[1]
        }
        if selectedImages.indices.contains(2) {
            imageView3.image = selectedImages[2]
        }
    }
}
