import UIKit

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        setView()
        setupConstraints()
    }
    private func setView() {
        // Здесь добавляются новые элементы для отображения на экране
    }
    
    // MARK: - Actions
    
}

// MARK: - Constraints

extension ProfileViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Здесь прописываются констрейнты для элементов
        ])
    }
}

