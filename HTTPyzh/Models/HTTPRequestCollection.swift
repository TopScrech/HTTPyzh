import Foundation
import SwiftData

@Model
final class HTTPRequestCollection {
    @Attribute(.unique) var id: UUID
    var name: String
    var isFavorite: Bool
    var createdAt: Date

    var project: HTTPProject?

    @Relationship(deleteRule: .nullify, inverse: \HTTPRequest.collection)
    var requests: [HTTPRequest]

    init(
        id: UUID = UUID(),
        name: String,
        project: HTTPProject? = nil,
        isFavorite: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.project = project
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        requests = []
    }
}
