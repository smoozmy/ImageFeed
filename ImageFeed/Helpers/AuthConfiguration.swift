import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURL: URL

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: "tI7ciXMYu0nr1dESTsBUWxgm5jMeIqlfQKW1nUIQHDs",
            secretKey: "hTOV7sOcVqqPg3MwB-cRiWaEMPEeMexofidAUTDrelQ",
            redirectURI: "urn:ietf:wg:oauth:2.0:oob",
            accessScope: "public+read_user+write_likes",
            authURLString: "https://unsplash.com/oauth/authorize",
            defaultBaseURL: URL(string: "https://api.unsplash.com/")!
        )
    }
}
