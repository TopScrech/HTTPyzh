import SwiftData
import SwiftUI

struct RequestEditorView: View {
    @Bindable var request: HTTPRequest

    @AppStorage("lastResponseDisplayMode")
    private var responseDisplayModeRaw = ResponseDisplayMode.raw.rawValue
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
                    displayMode: responseDisplayModeBinding,
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

    private var responseDisplayModeBinding: Binding<ResponseDisplayMode> {
        Binding {
            ResponseDisplayMode(rawValue: responseDisplayModeRaw) ?? .raw
        } set: {
            responseDisplayModeRaw = $0.rawValue
        }
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
            requestError = errorMessage(for: error, requestURL: request.url)
        }

        isSending = false
    }

    private func errorMessage(for error: any Error, requestURL: String) -> String {
        guard let urlError = error as? URLError else {
            return error.localizedDescription
        }

        let host = requestHost(from: requestURL)

        switch urlError.code {
        case .cannotFindHost:
            return "Could not resolve host \(host) [URLError: \(urlError.errorCode)]\nCheck DNS, VPN, proxy settings, or try another network"
        case .cannotConnectToHost:
            return "Could not connect to \(host) [URLError: \(urlError.errorCode)]\nThe host was found but refused or dropped the connection"
        case .timedOut:
            return "Request timed out [URLError: \(urlError.errorCode)]\nThe server or network is responding too slowly"
        case .notConnectedToInternet:
            return "No internet connection [URLError: \(urlError.errorCode)]"
        case .secureConnectionFailed:
            return "TLS handshake failed for \(host) [URLError: \(urlError.errorCode)]\nThe certificate or secure protocol negotiation failed"
        default:
            return "\(urlError.localizedDescription) [URLError: \(urlError.errorCode)]"
        }
    }

    private func requestHost(from value: String) -> String {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedValue.isEmpty else { return "unknown host" }

        if let directHost = URL(string: trimmedValue)?.host, !directHost.isEmpty {
            return directHost
        }

        if let prefixedHost = URL(string: "https://\(trimmedValue)")?.host, !prefixedHost.isEmpty {
            return prefixedHost
        }

        return "unknown host"
    }
}
