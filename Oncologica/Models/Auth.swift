import Foundation
import SwiftUI


struct Token: Codable {
    var refresh: String?
    var access: String?
    
    var detail: String?
    var err: String?
    var error: String?
    var code: String?
}


struct Login: Codable {
    var email: String
    var password: String
}
