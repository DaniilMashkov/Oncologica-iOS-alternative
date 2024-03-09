import Foundation


struct PatientCondition: Codable, Identifiable {
    var id: Int?
    var name: String?
}


struct MedicalDoc: Codable {
    var id: String
    var image: Data?
}


struct MedicalData: Codable {
    var diagnosis: String?
    var condition: Int?
    var anamnesis: String?
    var usermedicaldocument_set: [MedicalDoc]?
    
}
