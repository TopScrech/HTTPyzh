import Foundation

enum HTTPMethod: String, Codable, CaseIterable, Identifiable {
    case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE", head = "HEAD", options = "OPTIONS"

    var id: String { rawValue }

    var supportsBody: Bool {
        switch self {
        case .post, .put, .patch, .delete:
            true
        case .get, .head, .options:
            false
        }
    }
}
