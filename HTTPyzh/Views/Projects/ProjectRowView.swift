import SwiftUI

struct ProjectRowView: View {
    let project: HTTPProject
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Text(project.name)
                .lineLimit(1)

            Spacer(minLength: 8)

            Button(action: onToggleFavorite) {
                Image(systemName: project.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(project.isFavorite ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 2)
    }
}
