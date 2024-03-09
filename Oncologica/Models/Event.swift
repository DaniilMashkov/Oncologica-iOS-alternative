import Foundation


struct Theme: Codable {
    var id: String?
    var color: String?
    var background: String?
    var font: String?
}


struct Category: Codable {
    var id: String?
    var title: String?
    var description: String?
    var theme: Theme?
}

struct EntryStatus: Codable {
    var recorded: Int?
    var available_seats: Int?
    var reserve: Int?
    var queue: Int?
}


struct UsersEventStatus: Codable {
    var status: String?
}


struct Venue: Codable {
    var id: String?
    var venue: String?
    var location: String?
}


class Filters: Codable {
    var statuses: Dictionary<String, String>?
    var categories: [String]?
    var venues: [String]?
    var speakers: Dictionary<String, String>?
}


struct CalendarEvents: Codable, Identifiable {
    var id = UUID()
    var date: String?
    var category: Category?
    
    private enum CodingKeys : String, CodingKey { case date, category}
}


struct Address: Codable {
    var address: String?
    var latitude: String?
    var longtitude: String?
}


struct Event: Codable, Identifiable {
    var id: String?
    var online: Bool?
    var title: String?
    var heading: String?
    var place: String?
    var description: String?
    var address_offline: Address?
    var number_of_participants: Int?
    var banner: String?
    var date: String?
    var time: String?
    var duration: String?
    var status: String?
    var feedback: String?
    var reserve: Bool?
    var reserve_end_time: String?
    var category: Category?
    var venue_online: String?
    var speaker: [Speaker]?
    var user_status: String?
    var entry_status: EntryStatus?
    var venue: Venue?
    
    func localizedDate() -> Date {
        let serverDate = "\(date ?? "2001-01-01") \(time?.prefix(5) ?? "00:00") +0300"
        return serverDate.toDate("yyyy-MM-dd HH:mm Z")
    }
    
    var formattedTime: String {
        String(time != nil ? time!.prefix(5) : "")
    }
}
