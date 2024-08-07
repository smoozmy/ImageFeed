import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []

    private lazy var tableView: UITableView = {
        let element = UITableView()
        element.backgroundColor = .ypBlack
        element.separatorStyle = .none
        element.dataSource = self
        element.delegate = self
        element.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        element.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        setView()
        setupConstraints()
        
        fetchPhotosNextPage()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangePhotos),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func didChangePhotos(_ notification: Notification) {
        guard let newPhotos = notification.userInfo?["newPhotos"] as? [Photo] else { return }
        let startIndex = photos.count
        photos.append(contentsOf: newPhotos)
        let endIndex = photos.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: indexPaths, with: .automatic)
        }, completion: nil)
    }
    
    private func setView() {
        view.addSubview(tableView)
    }

    private func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            switch result {
            case .success(let newPhotos):
                print("Успешно загружено \(newPhotos.count) новых изображений")
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Actions
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        let lowQualityURL = URL(string: photo.thumbImageURL)
        let highQualityURL = URL(string: photo.smallImageURL)
        
        cell.rectangle.isHidden = true
        cell.likeButton.isHidden = true
        cell.dateLabel.isHidden = true
        
        cell.imageCell.kf.setImage(with: lowQualityURL, placeholder: nil, options: nil, completionHandler: { result in
            switch result {
            case .success:
                cell.imageCell.kf.setImage(with: highQualityURL) { result in
                    switch result {
                    case .success:
                        cell.rectangle.isHidden = false
                        cell.likeButton.isHidden = false
                        cell.dateLabel.isHidden = false
                        cell.stubImageView.isHidden = true
                    case .failure(let error):
                        print("Ошибка загрузки изображения: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
            }
        })
        
        cell.selectionStyle = .none
        
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        if let date = photo.createdAt {
            cell.dateLabel.text = date.dateTimeString
        } else {
            cell.dateLabel.text = ""
        }
    }

}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        let singleImageViewController = SingleImageViewController()
        if let url = URL(string: photo.largeImageURL) {
            singleImageViewController.setImage(url: url)
        }
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchPhotosNextPage()
        }
    }
}

// MARK: - Constraints

extension ImagesListViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
