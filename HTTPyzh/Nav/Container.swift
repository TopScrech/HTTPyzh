import SwiftData
import SwiftUI

struct Container: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \HTTPProject.createdAt)
    private var projects: [HTTPProject]
    
    @State private var selectedProject: HTTPProject?
    @State private var selectedRequest: HTTPRequest?
    
    var body: some View {
        NavigationSplitView {
            ProjectSidebarView(
                projects: sortedProjects,
                selectedProject: $selectedProject,
                onAddProject: addProject,
                onToggleFavorite: toggleFavorite(for:)
            )
        } content: {
            ProjectContentsSidebarView(
                project: selectedProject,
                selectedRequest: $selectedRequest,
                onAddCollection: addCollection(to:),
                onAddRequest: addRequest(to:collection:),
                onToggleCollectionFavorite: toggleFavorite(for:),
                onToggleRequestFavorite: toggleFavorite(for:)
            )
        } detail: {
            RequestDetailHostView(request: selectedRequest)
        }
        .navigationSplitViewStyle(.balanced)
        .task {
            seedIfNeeded()
        }
        .onChange(of: selectedProject) { _, newProject in
            guard let selectedRequest else { return }
            if selectedRequest.project?.id != newProject?.id {
                self.selectedRequest = nil
            }
        }
    }
    
    private func seedIfNeeded() {
        guard projects.isEmpty else {
            if selectedProject == nil {
                selectedProject = projects.first
            }
            return
        }
        
        let starterProject = HTTPProject(name: "Default Project")
        modelContext.insert(starterProject)
        selectedProject = starterProject
    }
    
    private func addProject() {
        let project = HTTPProject(name: "Project \(projects.count + 1)")
        modelContext.insert(project)
        selectedProject = project
    }
    
    private func addCollection(to project: HTTPProject) {
        let collection = HTTPRequestCollection(name: "Collection \(project.collections.count + 1)", project: project)
        modelContext.insert(collection)
    }
    
    private func addRequest(to project: HTTPProject, collection: HTTPRequestCollection?) {
        let defaultURL = "https://httpbin.org/get"
        let request = HTTPRequest(
            name: "Request \(project.requests.count + 1)",
            method: .get,
            url: defaultURL,
            project: project,
            collection: collection
        )
        
        modelContext.insert(request)
        selectedRequest = request
    }
    
    private func toggleFavorite(for project: HTTPProject) {
        project.isFavorite.toggle()
    }
    
    private func toggleFavorite(for collection: HTTPRequestCollection) {
        collection.isFavorite.toggle()
    }
    
    private func toggleFavorite(for request: HTTPRequest) {
        request.isFavorite.toggle()
    }
    
    private var sortedProjects: [HTTPProject] {
        projects.sorted {
            if $0.isFavorite != $1.isFavorite {
                return $0.isFavorite && !$1.isFavorite
            }
            
            return $0.createdAt < $1.createdAt
        }
    }
}

#Preview {
    Container()
        .modelContainer(for: [HTTPProject.self, HTTPRequestCollection.self, HTTPRequest.self], inMemory: true)
}
