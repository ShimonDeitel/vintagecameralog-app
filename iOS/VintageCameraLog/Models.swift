import Foundation

struct CameraItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var model: String
    var condition: String
    var notes: String = ""
    var dateAdded: Date = Date()
    var isFavorite: Bool = false
}
