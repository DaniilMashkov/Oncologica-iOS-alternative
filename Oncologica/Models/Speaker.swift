import Foundation


struct Messages: Codable {
    var token_class: String?
    var token_type: String?
    var message: String?
}

struct Speaker: Codable, Identifiable {
    var id: String?
    var name: String?
    var surname: String?
    var patronymic: String?
    var photo: String?
    var specialization: String?
    var description: String?
    var communications: String?
    
    var event: [Event]?
    var detail: String?
    var code: String?
    var messages: [Messages]?
}
