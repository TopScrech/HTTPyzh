import ScrechKit

struct RequestResponseSectionView: View {
    @Binding var displayMode: ResponseDisplayMode

    let statusCode: Int?
    let headers: [HTTPHeaderItem]
    let rawResponse: String
    let prettyJSONResponse: String
    let htmlResponse: String
    let error: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Response")
                    .headline()

                Spacer(minLength: 12)

                if let statusCode {
                    Text("Status \(statusCode)")
                        .subheadline()
                        .secondary()
                }
            }

            if !error.isEmpty {
                Text(error)
                    .subheadline()
                    .foregroundStyle(.red)
            }

            Picker("Display", selection: $displayMode) {
                ForEach(ResponseDisplayMode.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)

            if !headers.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Headers")
                        .subheadline()
                        .secondary()

                    ForEach(headers) {
                        Text("\($0.key): \($0.value)")
                            .caption(design: .monospaced)
                            .textSelection(.enabled)
                    }
                }
            }

            switch displayMode {
            case .raw:
                ResponseTextView(content: rawResponse)
            case .prettyJSON:
                ResponseTextView(content: prettyJSONResponse)
            case .html:
                HTMLPreviewView(html: htmlResponse)
                    .frame(minHeight: 280)
            }
        }
        .padding(16)
        .background(.thinMaterial, in: .rect(cornerRadius: 14))
    }
}
