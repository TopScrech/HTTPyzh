import ScrechKit
import SwiftData

@main
struct HTTPyzhApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            HTTPProject.self,
            HTTPRequestCollection.self,
            HTTPRequest.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Container()
        }
        .modelContainer(sharedModelContainer)
    }
}
