import Foundation
import SwiftData

@Model
final class HTTPProject {
    @Attribute(.unique) var id: UUID
    var name: String
    var isFavorite: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \HTTPRequestCollection.project)
    var collections: [HTTPRequestCollection]

    @Relationship(deleteRule: .cascade, inverse: \HTTPRequest.project)
    var requests: [HTTPRequest]

    init(
        id: UUID = UUID(),
        name: String,
        isFavorite: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        collections = []
        requests = []
    }
}
