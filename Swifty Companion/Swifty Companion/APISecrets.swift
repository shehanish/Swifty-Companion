import Foundation

struct APISecrets {
    static let shared = APISecrets()
    
    let uid: String
    let secret: String
    
    init() {
        guard let secretsPath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let secrets = NSDictionary(contentsOfFile: secretsPath) as? [String: String],
              let uid = secrets["UID"],
              let secret = secrets["SECRET"] else {
            fatalError("Could not load API secrets from Secrets.plist")
        }
        
        self.uid = uid
        self.secret = secret
    }
}
