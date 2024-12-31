import UIKit
import Supabase

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchUserProfile()
        Task{
            await fetchUserProfile()
        }
    }

    func fetchUserProfile() async {
        Task {
            do {
                let userresponse = try await supabase.database
                    .from("User")
                    .select("*")
                    .eq("userID", value: sessionuser)
                    .single()
                    .execute()

                if let user = userresponse.data as? Usertable {
                    // Update UI
                    nameLabel.text = user.username
                    emailLabel.text = user.email
                    roleLabel.text = "\(user.role)"

                    if let profilePictureURL = user.profilePicture, let url = URL(string: profilePictureURL) {
                        loadImage(from: url, into: profileImageView)
                    }
                    print(user)
                }
            } catch {
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }
    }

    }

    func loadImage(from url: URL, into imageView: UIImageView) {
        Task {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    imageView.image = image
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }

