import ScrechKit

struct RequestRowView: View {
    let request: HTTPRequest
    let isSelected: Bool
    let onSelect: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 10) {
                Text(request.method.rawValue)
                    .caption(design: .monospaced)
                    .foregroundStyle(methodTint)
                    .frame(width: 58)
                    .padding(.vertical, 3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(request.name)
                        .lineLimit(1)
                    if let collectionName = request.collection?.name {
                        Text(collectionName)
                            .caption()
                            .secondary()
                    }
                }

                Spacer(minLength: 8)

                Button(action: onToggleFavorite) {
                    Image(systemName: request.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(request.isFavorite ? .yellow : .secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(isSelected ? Color.secondary.opacity(0.16) : Color.clear, in: .rect(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private var methodTint: Color {
        switch request.method {
        case .get:
            .green
        case .post:
            .blue
        case .put:
            .indigo
        case .patch:
            .purple
        case .delete:
            .red
        case .head:
            .orange
        case .options:
            .teal
        }
    }
}
