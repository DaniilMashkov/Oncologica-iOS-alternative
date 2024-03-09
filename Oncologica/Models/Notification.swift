import Foundation


struct Notification: Codable {
    var id: String?
    var datetime_str: String?
    var text: String?
    var entity_title: String?
    var entity_model: EntityModel?
    var status: String?
    
    var detail: String?
}

struct EntityModel: Codable {
    var id: String?
    var name: String?
    var description: String?
}
