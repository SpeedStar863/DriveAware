//
//  ContentView.swift
//  DriveAware
//
//  Created by Alexander Ur on 9/1/25.
//

import CoreMotion
import CoreData
import SwiftUI
import Foundation
import Combine

enum EventType: String, Codable, CaseIterable {
    case hardBump = "Hard Bump"
    case sharpTurn = "Sharp Turn"
    case hardBrake =  "Hard Brake"
    case hardAcceleration = "Hard Acceleration"
}

struct HarshEvent: Identifiable, Codable {
    var id = UUID()
    let type: EventType
    let timestamp: Date
}

final class MotionManager: ObservableObject {
    private let motion = CMMotionManager()
    private var userAccel: CMAcceleration?
    var eventCounts: [EventType: Int] {
        Dictionary(grouping: harshEvents, by: {$0.type})
            .mapValues { $0.count }
    }
    
    @Published private(set) var harshEvents: [HarshEvent] = []
    @Published private(set) var debouncedEvents: [HarshEvent] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var lastEvent: HarshEvent?
    private var lastGlobalEventTime: Date?
    
    var context: NSManagedObjectContext
    
    private struct Thresholds {
        static let turn: Double = 0.45
        static let bump: Double = 0.35
        static let brake: Double = -0.35
        static let acceleration: Double = 0.30
    }
    
    private struct Cooldowns {
        static let sameEvent: TimeInterval = 2.0
        static let global: TimeInterval = 0.5
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadEvents()
        
        $harshEvents
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] events in
                self?.debouncedEvents = events
            }
            .store(in: &cancellables)
    }
    
    deinit {
        motion.stopDeviceMotionUpdates()
    }
    
    func startMonitoring() {
        guard motion.isDeviceMotionAvailable, !motion.isDeviceMotionActive else { return }
        motion.deviceMotionUpdateInterval = 0.1
        
        motion.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let d = data else { return }
            self.userAccel = d.userAcceleration
            self.checkForHarshEvent(data: d)
        }
    }
    
    func stopMonitoring() {
        motion.stopDeviceMotionUpdates()
    }
    
    private func checkForHarshEvent(data: CMDeviceMotion) {
        guard let a = userAccel else { return }
        let g = data.gravity
        
        let gravityNorm = sqrt(g.x*g.x + g.y*g.y + g.z*g.z)
        let gx = g.x / gravityNorm
        let gy = g.y / gravityNorm
        let gz = g.z / gravityNorm
        
        let forwardAccel = a.x * gx + a.y * gy + a.z * gz
        let verticalAccel = a.x * (-gx) + a.y * (-gy) + a.z * (1 - gz)
        let lateralAccel  = a.x * (-gy) + a.y * gx
        
        var newEventType: EventType? = nil
        
        if abs(lateralAccel) > Thresholds.turn {
            newEventType = .sharpTurn
        } else if abs(verticalAccel) > Thresholds.bump {
            newEventType = .hardBump
        } else if forwardAccel < Thresholds.brake {
            newEventType = .hardBrake
        } else if forwardAccel > Thresholds.acceleration {
            newEventType = .hardAcceleration
        }

        guard let type = newEventType else { return }

        let now = Date()

        if let lastGlobal = lastGlobalEventTime,
           now.timeIntervalSince(lastGlobal) < Cooldowns.global {
            return
        }

        if let last = lastEvent,
           last.type == type,
           now.timeIntervalSince(last.timestamp) < Cooldowns.sameEvent {
            return
        }

        logEvent(type: type)
        lastGlobalEventTime = now
        lastEvent = HarshEvent(type: type, timestamp: now)
    }

    
    func logEvent(type: EventType) {
        let newEvent = HarshEvent(type: type, timestamp: Date())
        harshEvents.append(newEvent)
        lastEvent = newEvent
        lastGlobalEventTime = Date()
        
        let entity = HarshEventEntity(context: context)
        entity.id = newEvent.id
        entity.type = type.rawValue
        entity.timestamp = newEvent.timestamp
        
        context.perform {
            do {
                try self.context.save()
            } catch {
                print("Failed to save event: \(error)")
            }
        }
    }
    
    private func loadEvents() {
        let request = HarshEventEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HarshEventEntity.timestamp, ascending: true)]
        
        do {
            let results = try context.fetch(request)
            harshEvents = results.map {
                HarshEvent(
                    type: EventType(rawValue: $0.type ?? "") ?? .hardBump,
                    timestamp: $0.timestamp ?? Date()
                )
            }
        } catch {
            print("Failed to fetch events: \(error)")
        }
    }
    
    func clearEvents() {
        harshEvents.removeAll()
        debouncedEvents.removeAll()
        lastEvent = nil
        lastGlobalEventTime = nil
        
        let fetchRequest = HarshEventEntity.fetchRequest()
        if let results = try? context.fetch(fetchRequest) {
            for obj in results { context.delete(obj) }
            try? context.save()
        }
    }
    
    func exportEvents() -> String {
        guard !debouncedEvents.isEmpty else { return "No event to export." }
        
        let sortedEvents = debouncedEvents.sorted { $0.timestamp > $1.timestamp }
        var output = "ID,Type,Timestamp\n"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for event in sortedEvents {
            output += "\(event.id.uuidString),\(event.type.rawValue),\(formatter.string(from: event.timestamp))\n"
        }
        return output
    }
}

    
struct MonitoringView: View {
    @ObservedObject var motionManager: MotionManager
    
    @State private var showShareSheet = false
    @State private var exportString: String = ""
    
    var body: some View {
        Text("Monitoring in progress...")
            .font(.title2)
            .foregroundColor(.blue)
            .padding()
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
