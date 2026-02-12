import SwiftUI

struct ResponseTextView: View {
    let content: String

    var body: some View {
        ScrollView {
            Text(content.isEmpty ? "No response yet" : content)
                .font(.body.monospaced())
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(12)
        }
        .frame(minHeight: 220)
        .background(.quaternary, in: .rect(cornerRadius: 10))
    }
}
