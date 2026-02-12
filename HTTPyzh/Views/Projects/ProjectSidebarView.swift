import SwiftUI

struct ProjectSidebarView: View {
    let projects: [HTTPProject]
    @Binding var selectedProject: HTTPProject?
    let onAddProject: () -> Void
    let onToggleFavorite: (HTTPProject) -> Void

    var body: some View {
        List(selection: $selectedProject) {
            if !favoriteProjects.isEmpty {
                Section("Favorites") {
                    ForEach(favoriteProjects) { project in
                        ProjectRowView(
                            project: project,
                            onToggleFavorite: {
                                onToggleFavorite(project)
                            }
                        )
                        .tag(project)
                    }
                }
            }

            Section("Projects") {
                ForEach(otherProjects) { project in
                    ProjectRowView(
                        project: project,
                        onToggleFavorite: {
                            onToggleFavorite(project)
                        }
                    )
                    .tag(project)
                }
            }
        }
        .navigationTitle("Projects")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add Project", systemImage: "plus", action: onAddProject)
            }
        }
    }

    private var favoriteProjects: [HTTPProject] {
        projects.filter(\.isFavorite)
    }

    private var otherProjects: [HTTPProject] {
        projects.filter { !$0.isFavorite }
    }
}
