import Foundation


struct User: Codable {
    var id: Int?
    var first_name: String?
    var last_name: String?
    var patronymic: String?
    var birth: Date?
    var phone: String?
    var phone_confirmed: Bool?
    var email: String?
    var country: String?
    var region: String?
    var city: String?
    var avatar: String?
    
    var detail: String?
}
