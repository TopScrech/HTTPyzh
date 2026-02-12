import ScrechKit

struct CollectionRowView: View {
    let collection: HTTPRequestCollection
    let onToggleFavorite: () -> Void
    let onAddRequest: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(collection.name)
                    .lineLimit(1)
                
                Text("\(collection.requests.count) requests")
                    .caption()
                    .secondary()
            }

            Spacer(minLength: 8)

            Button(action: onAddRequest) {
                Image(systemName: "plus")
            }
            .buttonStyle(.plain)
            .help("Add request to \(collection.name)")

            Button(action: onToggleFavorite) {
                Image(systemName: collection.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(collection.isFavorite ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }
}
