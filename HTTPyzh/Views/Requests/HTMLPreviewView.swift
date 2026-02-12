import SwiftUI
import WebKit

struct HTMLPreviewView: View {
    let html: String

    var body: some View {
        if html.isEmpty {
            ContentUnavailableView("No HTML response", systemImage: "chevron.left.forwardslash.chevron.right")
        } else {
            PlatformHTMLView(html: html)
                .background(.quaternary, in: .rect(cornerRadius: 10))
        }
    }
}

#if os(macOS)
struct PlatformHTMLView: NSViewRepresentable {
    let html: String

    func makeNSView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}
#else
struct PlatformHTMLView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}
#endif
