import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() { }
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        guard let request = authTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.task = nil
                self?.lastCode = nil
                
                if let error = error {
                    completion(.failure(NetworkError.urlRequestError(error)))
                    return
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(NetworkError.invalidRequest))
                    return
                }
                
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let authToken = responseBody.accessToken
                    OAuth2TokenStorage.shared.token = authToken
                    completion(.success(authToken))
                } catch {
                    completion(.failure(NetworkError.invalidRequest))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}

