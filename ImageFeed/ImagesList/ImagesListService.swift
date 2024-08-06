import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
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
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")
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
                completion(.success(newPhotos))
            case .failure(let error):
                completion(.failure(error))
            }
            self.isFetchingPhotos = false
        }
        task.resume()
    }
}
