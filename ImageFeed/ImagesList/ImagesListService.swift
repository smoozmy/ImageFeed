import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private init() { }
    
    private let urlSession = URLSession.shared
    private var lastLoadedPage: Int?
    private var isFetchingPhotos = false
    private (set) var photos: [Photo] = []
    
    private let perPage = 10

    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard !isFetchingPhotos else { return }
        isFetchingPhotos = true

        let nextPage = (lastLoadedPage ?? 0) + 1
        var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)photos")
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]

        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidRequest))
            isFetchingPhotos = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(from: $0) }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["newPhotos": newPhotos])
                completion(.success(newPhotos))
            case .failure(let error):
                completion(.failure(error))
            }
            self.isFetchingPhotos = false
        }
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let method = isLike ? "POST" : "DELETE"
        var request = URLRequest(url: URL(string: "\(Constants.defaultBaseURL)photos/\(photoId)/like")!)
        request.httpMethod = method
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 || response.statusCode == 201 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let photoResult = try JSONDecoder().decode(PhotoResult.self, from: data)
                let updatedPhoto = Photo(from: photoResult)
                
                self.photos[index] = updatedPhoto
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
