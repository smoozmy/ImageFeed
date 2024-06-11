import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - UI and Lyfe Cycle
    
    private lazy var imageCell: UIImageView = {
        let element = UIImageView()
        element.largeContentImage = UIImage(named: "0")
        element.layer.cornerRadius = 16
        element.layer.masksToBounds = true
        element.contentMode = .scaleAspectFill
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubview(imageCell)
    }
    
    // MARK: - Actions
    
}

// MARK: - Constraints

extension ImagesListCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            imageCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            imageCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

