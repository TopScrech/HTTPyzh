import SwiftData
import ScrechKit

struct RequestConfigurationSectionView: View {
    @Bindable var request: HTTPRequest
    let isSending: Bool
    let onSend: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Request")
                .headline()

            TextField("Name", text: $request.name)
                .textFieldStyle(.roundedBorder)

            Picker("Method", selection: $request.method) {
                ForEach(HTTPMethod.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.menu)

            TextField("URL", text: $request.url)
                .textFieldStyle(.roundedBorder)

            if let project = request.project {
                Picker("Collection", selection: $request.collection) {
                    Text("None")
                        .tag(nil as HTTPRequestCollection?)
                    
                    ForEach(sortedCollections(from: project)) {
                        Text($0.name)
                            .tag(Optional($0))
                    }
                }
                .pickerStyle(.menu)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Body")
                    .subheadline()
                    .secondary()

                TextEditor(text: $request.body)
                    .monospaced()
                    .frame(minHeight: 140)
                    .padding(8)
                    .background(.quaternary, in: .rect(cornerRadius: 10))
            }

            Button {
                Task {
                    await onSend()
                }
            } label: {
                Label(isSending ? "Sending..." : "Send", systemImage: "paperplane.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSending)
        }
        .padding(16)
        .background(.thinMaterial, in: .rect(cornerRadius: 14))
    }

    private func sortedCollections(from project: HTTPProject) -> [HTTPRequestCollection] {
        project.collections.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }
}
