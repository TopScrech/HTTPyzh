import Foundation

struct RequestExecutionResult {
    let statusCode: Int
    let headers: [HTTPHeaderItem]
    let rawBody: String
    let prettyJSONBody: String?
    let htmlBody: String
}

struct HTTPHeaderItem: Identifiable, Hashable {
    let key: String
    let value: String
    
    var id: String { key + value }
}

enum RequestExecutionError: LocalizedError {
    case invalidURL
    case nonHTTPResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: "The request URL is invalid"
        case .nonHTTPResponse: "Received a non-HTTP response"
        }
    }
}
