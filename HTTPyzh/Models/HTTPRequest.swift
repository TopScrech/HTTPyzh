import Foundation
import SwiftData

@Model
final class HTTPRequest {
    @Attribute(.unique) var id: UUID
    var name: String
    var isFavorite: Bool
    var method: HTTPMethod
    var url: String
    var body: String
    var createdAt: Date

    var project: HTTPProject?
    var collection: HTTPRequestCollection?

    init(
        id: UUID = UUID(),
        name: String,
        isFavorite: Bool = false,
        method: HTTPMethod = .get,
        url: String = "",
        body: String = "",
        project: HTTPProject? = nil,
        collection: HTTPRequestCollection? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
        self.method = method
        self.url = url
        self.body = body
        self.project = project
        self.collection = collection
        self.createdAt = createdAt
    }
}
