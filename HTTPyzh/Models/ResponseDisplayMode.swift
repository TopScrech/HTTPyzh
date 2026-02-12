import Foundation

enum ResponseDisplayMode: String, CaseIterable, Identifiable {
    case raw = "Raw", prettyJSON = "Pretty JSON", html = "HTML"

    var id: String { rawValue }
}
