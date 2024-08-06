import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 24
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var headerStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.alignment = .center
        element.distribution = .equalSpacing
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoriteStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        element.alignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var userPhoto: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "UserPhoto") ?? UIImage(named: "UserPhotoDefault")
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = 35
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logoutButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "Logout"), for: .normal)
        element.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.text = "Александр Крапивин"
        element.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        element.textColor = .white
        element.textAlignment = .left
        element.numberOfLines = 1
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var loginLabel: UILabel = {
        let element = UILabel()
        element.text = "@smoozmy"
        element.font = UIFont.systemFont(ofSize: 13)
        element.textColor = .gray
        element.textAlignment = .left
        element.numberOfLines = 1
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var discriptionLabel: UILabel = {
        let element = UILabel()
        element.text = "Hello, World!"
        element.font = UIFont.systemFont(ofSize: 13)
        element.textColor = .white
        element.textAlignment = .left
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let element = UILabel()
        element.text = "Избранное"
        element.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        element.textColor = .white
        element.textAlignment = .left
        element.numberOfLines = 1
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var notificationLabel: UILabel = {
        let element = UILabel()
        element.backgroundColor = .ypBlue
        element.text = "0"
        element.textColor = .ypWhite
        element.font = UIFont.systemFont(ofSize: 13)
        element.textAlignment = .center
        element.layer.cornerRadius = 11
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var spacer: UIView = {
        let element = UIView()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var noPhotoImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "NoPhoto")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setView()
        setupConstraints()
        
        fetchProfile()
    }
    
    private func fetchProfile() {
        guard let token = OAuth2TokenStorage.shared.token else {
            print("Токен не найден")
            return
        }
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.updateUI(with: profile)
                }
            case .failure(let error):
                print("Ошибка получения данных профиля: \(error)")
            }
        }
    }
    
    private func updateUI(with profile: ProfileService.Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        discriptionLabel.text = profile.bio
        if let profileImageURL = profile.profileImageURL, let url = URL(string: profileImageURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.userPhoto.image = image
                    }
                }
            }
        }
    }
    
    private func setView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(favoriteStackView)
        
        favoriteStackView.addArrangedSubview(favoriteLabel)
        favoriteStackView.addArrangedSubview(notificationLabel)
        favoriteStackView.addArrangedSubview(spacer)
        
        view.addSubview(noPhotoImage)
        
        headerStackView.addArrangedSubview(userPhoto)
        headerStackView.addArrangedSubview(logoutButton)
        
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(loginLabel)
        infoStackView.addArrangedSubview(discriptionLabel)
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogoutButton() {
        
    }
    
}

// MARK: - Constraints

extension ProfileViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            headerStackView.heightAnchor.constraint(equalToConstant: 70),
            
            userPhoto.widthAnchor.constraint(equalToConstant: 70),
            userPhoto.heightAnchor.constraint(equalToConstant: 70),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            notificationLabel.widthAnchor.constraint(equalToConstant: 40),
            notificationLabel.heightAnchor.constraint(equalToConstant: 22),
            
            noPhotoImage.topAnchor.constraint(equalTo: favoriteStackView.bottomAnchor, constant: 110),
            noPhotoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPhotoImage.widthAnchor.constraint(equalToConstant: 100),
            noPhotoImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
