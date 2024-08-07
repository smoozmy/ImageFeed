import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - UI and Lyfe Cycle
    
    lazy var rectangle: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "Rectangle")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var dateLabel: UILabel = {
        let element = UILabel()
        let date = Date()
        element.text = date.dateTimeString
        element.textAlignment = .left
        element.textColor = .white
        element.font = .systemFont(ofSize: 13)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var imageCell: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 16
        element.backgroundColor = .ypWhiteAlpha50
        element.layer.masksToBounds = true
        element.contentMode = .scaleAspectFill
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var stubImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "Stub")
        element.contentMode = .scaleAspectFit
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var likeButton: UIButton = {
        let element = UIButton(type: .custom)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .ypBlack
        self.setView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubview(imageCell)
        imageCell.addSubview(rectangle)
        imageCell.addSubview(likeButton)
        imageCell.addSubview(dateLabel)
        imageCell.addSubview(stubImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
        stubImageView.isHidden = false
    }
    
    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            imageCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            imageCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            rectangle.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            rectangle.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor),
            rectangle.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -8),
            
            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            
            stubImageView.centerXAnchor.constraint(equalTo: imageCell.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: imageCell.centerYAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 83),
            stubImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
