//
//  Persistence.swift
//  DriveAware
//
//  Created by Alexander Ur on 9/25/25.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        for i in 0..<5 {
            let event = HarshEventEntity(context: viewContext)
            event.id = UUID()
            event.type = i % 2 == 0 ? "Hard Bump" : "Sharp Turn"
            event.timestamp = Date().addingTimeInterval(Double(-i*60))
        }
        
        do {
            try viewContext.save() }
        catch { fatalError("Preview save failed: \(error)")
        }
        return controller
    }()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "DriveAware")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
