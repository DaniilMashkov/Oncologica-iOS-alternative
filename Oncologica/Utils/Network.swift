import Foundation
import SwiftUI


let baseUrl = "https://slot9b.oscarbot.ru/api/"


struct Network {
    @AppStorage("isLoading") var isLoading: Bool = false
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("accessToken") private var accessToken = " "
    @AppStorage("refreshToken") private var refreshToken = " "
    @AppStorage("isLogged") private var isLogged: Bool = false
    
    func fetchData(url: String, method: String, json: Data?, token: String?) async -> (Data, URLResponse) {
        let uri = URL(string: url)
        
        var request = URLRequest(url: uri!)
        let sessionConfiguration = URLSessionConfiguration.default
        
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            sessionConfiguration.httpAdditionalHeaders = ["Authorization": "Bearer \(token!)"]
        }
        
        let session = URLSession(configuration: sessionConfiguration)
        
        do {
            var (data, response) = try await session.upload(for: request, from: json ?? Data())
            let res = response as? HTTPURLResponse
            if res!.statusCode == 401 {
                await getAcceessToken()
                let r = await fetchData(url: url, method: method, json: json, token: accessToken)
                data = r.0
                response = r.1
                return (data, response)
            }
            return (data, response)
        } catch {
            return (Data(error.localizedDescription.utf8), URLResponse())
        }
    }
    
    
    func fetchFile(url: String, method: String, fileName: String?, token: String?) async -> (Data, URLResponse) {
        let uri = URL(string: url)
        
        var request = URLRequest(url: uri!)
        let sessionConfiguration = URLSessionConfiguration.default
        
        request.httpMethod = method
        if ["POST", "PATCH"].contains(method)  {
            request.setValue("attachment; filename=\(fileName!)", forHTTPHeaderField: "Content-Disposition")
        }
        
        if token != nil {
            sessionConfiguration.httpAdditionalHeaders = ["Authorization": "Bearer \(token!)"]
        }
        
        let session = URLSession(configuration: sessionConfiguration)
        
        do {
            var (data, response) = try await session.upload(for: request, from: Data())
            let res = response as? HTTPURLResponse
            if res!.statusCode == 401 {
                await getAcceessToken()
                let r = await fetchFile(url: url, method: method, fileName: fileName, token: accessToken)
                data = r.0
                response = r.1
                return (data, response)
            }
            return (data, response)
        } catch {
            return (Data(error.localizedDescription.utf8), URLResponse())
        }
    }
    
    
    func getComingEvents() async -> [Event] {
        var events = [Event]()
        
        do {
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)events/coming/", method: "GET", json: nil, token: accessToken)
            events = (try JSONDecoder().decode([Event].self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return events
    }
    
    
    func getEvents(filters: eventsFilters, dates: [Date]) async -> [Event] {
        var events = [Event]()
        let statusesQuery = filters.statuses[1...].map{"user_status=\($0)"}.joined(separator: "&")
        let categoiesQuery = filters.categories[1...].map{"category=\($0)"}.joined(separator: "&")
        let venuesQuery = filters.venues[1...].map{"venues=\($0)"}.joined(separator: "&")
        let speakersQuery = filters.speakers[1...].map{"speakers=\($0)"}.joined(separator: "&")
        let query = "\(statusesQuery)&\(categoiesQuery)&\(venuesQuery)&\(speakersQuery)".trimmingCharacters(in: .punctuationCharacters)

        isLoading = true
        do{
            let url = "\(baseUrl)events/?date_after=\(dates.first?.toString("y-MM-dd") ?? "")&date_before=\(dates.last?.toString("y-MM-dd") ?? "")&\(query)"
            let (data, _) = await fetchData(url: url, method: "GET", json: nil, token: accessToken)
            events = (try JSONDecoder().decode([Event].self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return events
    }
    
    
    func getEvent(eventId: String) async -> Event {
        var event = Event()
        isLoading = true
        do{
            let url = "\(baseUrl)events/\(eventId)"
            let (data, _) = await fetchData(url: url, method: "GET", json: nil, token: accessToken)
            event = (try JSONDecoder().decode(Event.self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return event
    }
    
    
    func getEntryStatus(eventId: String) async -> EntryStatus {
        var entryStatus = EntryStatus()
        isLoading = true
        do{
            let url = "\(baseUrl)events/get_entry_status/\(eventId)"
            let (data, _) = await fetchData(url: url, method: "GET", json: nil, token: accessToken)
            entryStatus = (try JSONDecoder().decode(EntryStatus.self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return entryStatus
    }
    
    
    func discardUsersEventStatus(eventId: String) async -> UsersEventStatus {
        var usersEventStatus = UsersEventStatus()
        isLoading = true
        do{
            let url = "\(baseUrl)events/status/annul/\(eventId)/"
            let (data, _) = await fetchData(url: url, method: "PUT", json: nil, token: accessToken)
            usersEventStatus = (try JSONDecoder().decode(UsersEventStatus.self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return usersEventStatus
    }
    
    
    func getUsersEventStatus(eventId: String) async -> UsersEventStatus {
        var usersEventStatus = UsersEventStatus()
        isLoading = true
        do{
            let url = "\(baseUrl)events/status/add/\(eventId)/"
            let (data, _) = await fetchData(url: url, method: "PUT", json: nil, token: accessToken)
            usersEventStatus = (try JSONDecoder().decode(UsersEventStatus.self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return usersEventStatus
    }
    
    
    func getSpeakerWithEvents(speakerId:String) async -> (Speaker, [Event]) {
        var speaker = Speaker()
        var events = [Event]()
        
        do {
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)speaker/\(speakerId)/", method: "GET", json: nil, token: accessToken)
            
            speaker = try JSONDecoder().decode(Speaker.self, from: data)
            events = speaker.event ?? [Event]()
        }catch{
            print(error)
        }
        isLoading = false
        return(speaker, events)
    }
    
    
    func getSpeakerList() async -> [Speaker] {
        var speakers = [Speaker]()
        do {
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)speaker/list/", method: "GET", json: nil, token: accessToken)
            speakers = try JSONDecoder().decode([Speaker].self, from: data)
        }catch{
            print(error)
        }
        isLoading = false
        return speakers
    }
    
    func getMedicalData(userId: Int) async -> MedicalData {
        var medicalData = MedicalData()
        do {
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)users/\(userId)/medical-data/", method: "GET", json: nil, token: accessToken)
            medicalData = try JSONDecoder().decode(MedicalData.self, from: data)
            
            for doc in medicalData.usermedicaldocument_set!{
                let ind = medicalData.usermedicaldocument_set?.firstIndex{$0.id == doc.id}
                medicalData.usermedicaldocument_set?.remove(at: ind!)
                
                let image = await getMedicalDoc(docId: doc.id)
                medicalData.usermedicaldocument_set?.append(MedicalDoc(id: doc.id, image: image))
            }
        }catch{
            print(error)
        }
        isLoading = false
        return medicalData
    }
    
    func getMedicalDoc(docId: String) async -> Data {
        var data = Data()
        do {
            isLoading = true
            let (resData, response) = await fetchFile(
                url: "\(baseUrl)users/medical-data/docs/\(docId)/", method: "GET", fileName: nil, token: accessToken)
            let res = response as? HTTPURLResponse
            if res?.statusCode == 200 {
                data = resData
            }
        }catch{
            print(error)
        }
        isLoading = false
        return data
    }
    
    func getPatientsConditions() async -> [PatientCondition] {
        var patientConditions = [PatientCondition]()
        do {
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)users/medical-data/condition-list/", method: "GET", json: nil, token: accessToken)
            patientConditions = try JSONDecoder().decode([PatientCondition].self, from: data)
        }catch{
            print(error)
        }
        isLoading = false
        return patientConditions
    }
    
    func getCalendarBasics(filters: eventsFilters) async -> [CalendarEvents] {
        var events = [CalendarEvents]()
        let statusesQuery = filters.statuses[1...].map{"user_status=\($0)"}.joined(separator: "&")
        let categoiesQuery = filters.categories[1...].map{"category=\($0)"}.joined(separator: "&")
        let venuesQuery = filters.venues[1...].map{"venues=\($0)"}.joined(separator: "&")
        let speakersQuery = filters.speakers[1...].map{"speakers=\($0)"}.joined(separator: "&")
        let query = "\(statusesQuery)&\(categoiesQuery)&\(venuesQuery)&\(speakersQuery)".trimmingCharacters(in: .punctuationCharacters)

        isLoading = true
        do{
            let (data, _) = await fetchData(url: "\(baseUrl)events/calendar-basics/?\(query)", method: "GET", json: nil, token: accessToken)
            events = (try JSONDecoder().decode([CalendarEvents].self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return events
    }
    
    
    func getUserBasics() async -> User {
        var user = User()
        do{
            isLoading = true
            let (data, _) = await fetchData(url: "\(baseUrl)users/basics/", method: "GET", json: nil, token: accessToken)
            user = (try JSONDecoder().decode(User.self, from: data))
        }catch{
            print(error)
        }
        isLoading = false
        return user
    }

    
    func getNotifications() async -> [Notification] {
        var notifications = [Notification]()
        
        do {
            isLoading = true
            let (data, _) = await fetchData(
                url: "https://slot9b.oscarbot.ru/api/notification/list/", method: "GET", json: nil, token: accessToken)
            notifications = try JSONDecoder().decode([Notification].self, from: data)
        }catch{
            print(error)
        }
        isLoading = false
        return notifications
    }
    
    func getNotificationCount() async -> Int{
        var value = 0
        do{
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)notification/get_number_of_notifications/", method: "GET", json: nil, token: accessToken)
            let resData = try JSONSerialization.jsonObject(with: data) as? [String:Int]
            value = resData?.values.first ?? 0
        }catch{
            value = 0
        }
        isLoading = false
        return value
    }
    
    func getEventFilters() async -> Filters{
        var filters = Filters()
        do{
            isLoading = true
            let (data, _) = await fetchData(
                url: "\(baseUrl)events/event_filter/", method: "GET", json: nil, token: accessToken)
            filters = try JSONDecoder().decode(Filters.self, from: data)
        }catch{
            print(error)
        }
        isLoading = false
        return filters
    }
    
    func getAcceessToken() async {
        isLoading = true
        do {
            let encoded = try JSONEncoder().encode(Token(refresh: refreshToken))
            let url = URL(string: "\(baseUrl)token/refresh/")
            var request = URLRequest(url: url!)
            let sessionConfiguration = URLSessionConfiguration.default
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession(configuration: sessionConfiguration)
            
            let (data, response) = try await session.upload(for: request, from: encoded )

            let decoded = try JSONDecoder().decode(Token.self, from: data)
            let res = response as? HTTPURLResponse

            if res?.statusCode != 200 {
                await isLogged = getRefreshToken(email: nil, password: nil)
            } else {
                let decoded = try JSONDecoder().decode(Token.self, from: data)
                if decoded.access != nil {
                    accessToken = (decoded.access)!
                    isLogged = true
                }
            }
            
        } catch {
            isLogged = false
            print(error)
        }
        isLoading = false
    }
    
    func getRefreshToken(email: String?, password: String?) async -> Bool {
        
        isLoading = true
        do {
            let credentials = Login(email: email ?? userEmail, password: password ?? Keychain().retrieveUserPassword(email: userEmail))
            let encoded = try JSONEncoder().encode(credentials)
            let url = URL(string: "\(baseUrl)token/")
            var request = URLRequest(url: url!)
            let sessionConfiguration = URLSessionConfiguration.default
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession(configuration: sessionConfiguration)
            
            let (data, _) = try await session.upload(for: request, from: encoded )

            let decoded = try JSONDecoder().decode(Token.self, from: data)

            if decoded.refresh != nil {
                refreshToken = (decoded.refresh)!
                accessToken = (decoded.access)!
                
                Keychain().saveChain(email: credentials.email, password: credentials.password)
                
                userEmail = credentials.email
                isLogged = true
                isLoading = false
                
                return isLogged
            }
        }catch {
            print(error)
        }
        isLoading = false
        return isLoading
    }
}

