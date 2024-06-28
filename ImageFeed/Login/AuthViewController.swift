import UIKit

final class AuthViewController: UIViewController {
    
    
    private lazy var logoUnsplash: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "LogoUnsplash")
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var loginButton: UIButton = {
        let element = UIButton(type: .system)
        element.backgroundColor = .ypWhite
        element.setTitle("Войти", for: .normal)
        element.setTitleColor(.ypBlack, for: .normal)
        element.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        element.layer.cornerRadius = 16
        element.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - UI and Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        setView()
        setupConstraints()
    }
    private func setView() {
        view.addSubview(logoUnsplash)
        view.addSubview(loginButton)
    }
    
    // MARK: - Actions
    
    @objc private func didTapLoginButton() {
        print("login")
    }
    
}

// MARK: - Constraints

extension AuthViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoUnsplash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoUnsplash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoUnsplash.widthAnchor.constraint(equalToConstant: 60),
            logoUnsplash.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
            
        ])
    }
}

