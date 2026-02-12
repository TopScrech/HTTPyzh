import Foundation

struct RequestExecutor {
    func run(request: HTTPRequest) async throws -> RequestExecutionResult {
        guard let url = requestURL(from: request.url) else {
            throw RequestExecutionError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if request.method.supportsBody {
            let trimmedBody = request.body.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !trimmedBody.isEmpty {
                urlRequest.httpBody = trimmedBody.data(using: .utf8)
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestExecutionError.nonHTTPResponse
        }
        
        let rawBody = String(decoding: data, as: UTF8.self)
        
        return RequestExecutionResult(
            statusCode: httpResponse.statusCode,
            headers: headers(from: httpResponse),
            rawBody: rawBody,
            prettyJSONBody: prettyJSON(from: data),
            htmlBody: rawBody
        )
    }
    
    private func prettyJSON(from data: Data) -> String? {
        guard !data.isEmpty else { return "" }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
            return String(decoding: prettyData, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    private func headers(from response: HTTPURLResponse) -> [HTTPHeaderItem] {
        response.allHeaderFields
            .compactMap {
                guard let key = $0.key as? String else { return nil }
                return HTTPHeaderItem(key: key, value: String(describing: $0.value))
            }
            .sorted { $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedAscending }
    }

    private func requestURL(from value: String) -> URL? {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedValue.isEmpty else { return nil }

        if let directURL = URL(string: trimmedValue), isSupportedScheme(directURL) {
            return directURL
        }

        guard !trimmedValue.contains("://") else { return nil }

        let prefixedValue = "https://\(trimmedValue)"
        guard let prefixedURL = URL(string: prefixedValue), isSupportedScheme(prefixedURL) else { return nil }
        return prefixedURL
    }

    private func isSupportedScheme(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased(), let host = url.host else { return false }
        guard !host.isEmpty else { return false }
        return scheme == "http" || scheme == "https"
    }
}
