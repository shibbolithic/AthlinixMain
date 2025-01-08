import UIKit

class LoginViewController: UIViewController {

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, statusLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            statusLabel.text = "Please enter both email and password."
            return
        }

        Task {
            do {
                let response = try await supabase
                    .from("User")
                    .select("*")
                    .eq("email", value: email)
                    .execute()
                
                let decoder = JSONDecoder()
                let users = try decoder.decode([Usertable].self, from: response.data)
                
                if let user = users.first, user.password == password {
                    // Successful login
                    SessionManager.shared.setSessionUser(with: user.userID) // Save the user ID in the singleton
                    transitionToHomeScreen()
                } else {
                    statusLabel.textColor = .red
                    statusLabel.text = "Invalid email or password."
                }
            } catch {
                statusLabel.textColor = .red
                statusLabel.text = "Error connecting to database: \(error.localizedDescription)"
            }
        }
    }

    private func transitionToHomeScreen() {
        guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") else {
            fatalError("MainTabBarController not found in storyboard")
        }
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
    }
}
