import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() { }
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    struct UserProfileResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
        
        struct ProfileImage: Codable {
            let medium: String
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String?
        let profileImageURL: String?
        
        init(from profileResult: ProfileResult, userProfileResult: UserProfileResult?) {
            self.username = profileResult.username
            self.name = "\(profileResult.firstName) \(profileResult.lastName)"
            self.loginName = "@\(profileResult.username)"
            self.bio = profileResult.bio
            self.profileImageURL = userProfileResult?.profileImage.medium
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard let profileRequest = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.data(for: profileRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    self.fetchUserProfileImage(username: profileResult.username, token: token) { userProfileResult in
                        let profile = Profile(from: profileResult, userProfileResult: userProfileResult)
                        completion(.success(profile))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    private func fetchUserProfileImage(username: String, token: String, completion: @escaping (UserProfileResult?) -> Void) {
        guard let userProfileRequest = makeUserProfileRequest(username: username, token: token) else {
            completion(nil)
            return
        }
        
        urlSession.data(for: userProfileRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let userProfileResult = try JSONDecoder().decode(UserProfileResult.self, from: data)
                    completion(userProfileResult)
                } catch {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeUserProfileRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
