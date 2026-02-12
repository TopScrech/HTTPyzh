import SwiftUI

struct RequestDetailHostView: View {
    let request: HTTPRequest?

    var body: some View {
        if let request {
            RequestEditorView(request: request)
        } else {
            ContentUnavailableView("Select a Request", systemImage: "network")
        }
    }
}
