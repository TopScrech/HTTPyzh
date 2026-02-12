import SwiftData
import SwiftUI

struct RequestEditorView: View {
    @Bindable var request: HTTPRequest

    @State private var responseDisplayMode: ResponseDisplayMode = .raw
    @State private var statusCode: Int?
    @State private var responseHeaders: [HTTPHeaderItem] = []
    @State private var rawResponse = ""
    @State private var prettyJSONResponse = ""
    @State private var htmlResponse = ""
    @State private var requestError = ""
    @State private var isSending = false

    private let requestExecutor = RequestExecutor()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RequestConfigurationSectionView(
                    request: request,
                    isSending: isSending,
                    onSend: send
                )

                RequestResponseSectionView(
                    displayMode: $responseDisplayMode,
                    statusCode: statusCode,
                    headers: responseHeaders,
                    rawResponse: rawResponse,
                    prettyJSONResponse: prettyJSONResponse,
                    htmlResponse: htmlResponse,
                    error: requestError
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(request.name)
    }

    private func send() async {
        isSending = true
        requestError = ""

        do {
            let result = try await requestExecutor.run(request: request)
            statusCode = result.statusCode
            responseHeaders = result.headers
            rawResponse = result.rawBody
            prettyJSONResponse = result.prettyJSONBody ?? "Response body is not valid JSON"
            htmlResponse = result.htmlBody
        } catch {
            statusCode = nil
            responseHeaders = []
            rawResponse = ""
            prettyJSONResponse = ""
            htmlResponse = ""
            requestError = error.localizedDescription
        }

        isSending = false
    }
}
