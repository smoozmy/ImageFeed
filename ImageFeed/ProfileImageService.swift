import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() { }
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
        
        struct ProfileImage: Codable {
            let small: String
        }
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.data(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                    self.avatarURL = userResult.profileImage.small
                    completion(.success(userResult.profileImage.small))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
