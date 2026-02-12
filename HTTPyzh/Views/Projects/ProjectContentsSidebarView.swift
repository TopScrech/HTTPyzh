import SwiftUI

struct ProjectContentsSidebarView: View {
    let project: HTTPProject?
    @Binding var selectedRequest: HTTPRequest?
    let onAddCollection: (HTTPProject) -> Void
    let onAddRequest: (HTTPProject, HTTPRequestCollection?) -> Void
    let onToggleCollectionFavorite: (HTTPRequestCollection) -> Void
    let onToggleRequestFavorite: (HTTPRequest) -> Void

    var body: some View {
        Group {
            if let project {
                List {
                    if !favoriteCollections.isEmpty {
                        Section("Favorite Collections") {
                            ForEach(favoriteCollections) { collection in
                                CollectionRowView(
                                    collection: collection,
                                    onToggleFavorite: {
                                        onToggleCollectionFavorite(collection)
                                    },
                                    onAddRequest: {
                                        onAddRequest(project, collection)
                                    }
                                )
                            }
                        }
                    }

                    if !favoriteRequests.isEmpty {
                        Section("Favorite Requests") {
                            ForEach(favoriteRequests) { request in
                                RequestRowView(
                                    request: request,
                                    isSelected: selectedRequest?.id == request.id,
                                    onSelect: {
                                        selectedRequest = request
                                    },
                                    onToggleFavorite: {
                                        onToggleRequestFavorite(request)
                                    }
                                )
                            }
                        }
                    }

                    Section("Collections") {
                        ForEach(otherCollections) { collection in
                            CollectionRowView(
                                collection: collection,
                                onToggleFavorite: {
                                    onToggleCollectionFavorite(collection)
                                },
                                onAddRequest: {
                                    onAddRequest(project, collection)
                                }
                            )
                        }
                    }

                    Section("Requests") {
                        ForEach(otherRequests) { request in
                            RequestRowView(
                                request: request,
                                isSelected: selectedRequest?.id == request.id,
                                onSelect: {
                                    selectedRequest = request
                                },
                                onToggleFavorite: {
                                    onToggleRequestFavorite(request)
                                }
                            )
                        }
                    }
                }
                .navigationTitle(project.name)
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button("Add Collection", systemImage: "folder.badge.plus") {
                            onAddCollection(project)
                        }

                        Button("Add Request", systemImage: "plus") {
                            onAddRequest(project, nil)
                        }
                    }
                }
            } else {
                ContentUnavailableView("Select a Project", systemImage: "folder")
            }
        }
    }

    private var collections: [HTTPRequestCollection] {
        guard let project else { return [] }
        
        return project.collections.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    private var requests: [HTTPRequest] {
        guard let project else { return [] }
        
        return project.requests.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    private var favoriteCollections: [HTTPRequestCollection] {
        collections.filter(\.isFavorite)
    }

    private var otherCollections: [HTTPRequestCollection] {
        collections.filter { !$0.isFavorite }
    }

    private var favoriteRequests: [HTTPRequest] {
        requests.filter(\.isFavorite)
    }

    private var otherRequests: [HTTPRequest] {
        requests.filter { !$0.isFavorite }
    }
}
