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
import CoreLocation
import CoreML

enum EventType: String, Codable, CaseIterable {
    case normal = "Normal"
    case hardBump = "Hard Bump"
    case sharpTurn = "Sharp Turn"
    case hardBrake = "Hard Brake"
    case hardAcceleration = "Hard Acceleration"
}

struct HarshEvent: Identifiable, Codable {
    let id: UUID
    let type: EventType
    let timestamp: Date
    
    init(id: UUID = UUID(), type: EventType, timestamp: Date = Date()) {
        self.id = id
        self.type = type
        self.timestamp = timestamp
    }
}

final class MotionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let motion = CMMotionManager()
    private let locationManager = CLLocationManager()
    private let haptics = UIImpactFeedbackGenerator(style: .heavy)
    
    var lastLocation: CLLocation?
    private var smoothedAccel = CMAcceleration(x: 0, y: 0, z: 0)
    private let alpha = 0.15
    private var motionBuffer: [MotionSample] = []
    private var lastGlobalEventTime: Date?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var harshEvents: [HarshEvent] = []
    @Published private(set) var debouncedEvents: [HarshEvent] = []
    @Published private(set) var eventCounts: [EventType: Int] = [:]
    @Published private(set) var lastEvent: HarshEvent?
    
    var context: NSManagedObjectContext
    
    private let csvPath: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("motionData.csv")
    }()
    
    struct MotionSample {
        let forward, lateral, vertical: Double
        let timestamp: TimeInterval
    }
    
    func mockGPSChange(to newSpeed: Double) {
        let now = Date()
        
        if let last = lastLocation {
            let timeDelta: TimeInterval = 0.5
            let deltaV = newSpeed - last.speed
            let gForce = (deltaV / timeDelta) / 9.81
            
            if gForce < Config.brakeThreshold {
                triggerEvent(.hardBrake, hint: 2)
            } else if gForce > Config.accelThreshold {
                triggerEvent(.hardAcceleration, hint: 3)
            }
        }
        
        self.lastLocation = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 34.8526, longitude: -82.3940),
            altitude: 0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            course: 0,
            speed: newSpeed,
            timestamp: now
        )
    }
    
    private struct Config {
        static let windowDuration: TimeInterval = 1.5
        static let globalCooldown: TimeInterval = 2.0
        
        
        static let turnThreshold = 0.30
        static let bumpThreshold = 0.50
        static let brakeThreshold = -0.30
        static let accelThreshold = 0.30
        
        static let minSpeedForEvents: Double = 0.0
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupLocation()
        setupCSV()
        loadEvents()
        
        $harshEvents.assign(to: &$debouncedEvents)
        
        $harshEvents
            .map { events in
                Dictionary(grouping: events, by: { $0.type }).mapValues { $0.count }
            }
            .assign(to: &$eventCounts)
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startMonitoring() {
        haptics.prepare()
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.1
            motion.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
                if let d = data { self?.processMotion(d) }
            }
        }
        locationManager.startUpdatingLocation()
    }
    
    func predictEvent(features: [String: Double]) -> String {
        let maxF = features["maxForward"] ?? 0
        let minF = features["minForward"] ?? 0
        let maxL = features["maxLateral"] ?? 0
        let maxV = features["maxVertical"] ?? 0
        let rmsVal = features["RMS"] ?? 0
        let stdDev = features["stdDevForward"] ?? 0
        let meanF = features["meanForward"] ?? 0
        
        do {
            let config = MLModelConfiguration()
            
            let model = try DrivingClassifier(configuration: config)
            
            let input = DrivingClassifierInput(
                maxForward: maxF,
                minForward: minF,
                maxLateral: maxL,
                maxVertical: maxV,
                RMS: rmsVal,
                stdDevForward: stdDev,
                meanForward: meanF
            )
            
            let prediction = try model.prediction(input: input)
            return prediction.eventType
        } catch {
            print("AI Prediction Error: \(error)")
            return "Normal"
        }
    }
    
    private func processMotion(_ data: CMDeviceMotion) {
            let a = data.userAcceleration
            
            smoothedAccel.x = smoothedAccel.x * (1.0 - alpha) + a.x * alpha
            smoothedAccel.y = smoothedAccel.y * (1.0 - alpha) + a.y * alpha
            smoothedAccel.z = smoothedAccel.z * (1.0 - alpha) + a.z * alpha
            
            let now = Date().timeIntervalSince1970
            motionBuffer.append(MotionSample(forward: smoothedAccel.z, lateral: smoothedAccel.x, vertical: smoothedAccel.y, timestamp: now))
            motionBuffer.removeAll { now - $0.timestamp > Config.windowDuration }
            
            let longitudinalG = abs(a.z)
            let lateralG = abs(a.x)
            let verticalG = abs(a.y)
            
            if longitudinalG > 0.3 || lateralG > 0.3 || verticalG > 0.4 {
                let features = extractFeaturesDict()
                let aiResult = predictEvent(features: features)
                
                if aiResult != "Normal" {
                    let event = EventType(rawValue: aiResult) ?? .normal
                    triggerEvent(event, hint: 5)
                }
            }
        }

    func stopMonitoring() {
        motion.stopDeviceMotionUpdates()
        locationManager.stopUpdatingLocation()
        lastLocation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let current = locations.last, current.horizontalAccuracy < 20 else { return }
        
        if let last = lastLocation {
            let timeDelta = current.timestamp.timeIntervalSince(last.timestamp)
            
            if timeDelta >= 0.5 && timeDelta <= 2.0 {
                let deltaV = current.speed - last.speed
                let gForce = (deltaV / timeDelta) / 9.81
                
                if gForce < Config.brakeThreshold {
                    triggerEvent(.hardBrake, hint: 2)
                } else if gForce > Config.accelThreshold {
                    triggerEvent(.hardAcceleration, hint: 3)
                }
            }
        }
        lastLocation = current
    }

    private func triggerEvent(_ type: EventType, hint: Int) {
            let now = Date()
            if let last = lastGlobalEventTime, now.timeIntervalSince(last) < 2.0 { return }
            
            lastGlobalEventTime = now
            haptics.impactOccurred()
            
            let features = extractFeatures()
            saveEvent(type: type, features: features, hint: hint)
        }
    
    private func extractFeaturesDict() -> [String: Double] {
            let f = extractFeatures()
            return [
                "maxForward": f[0], "minForward": f[1], "maxLateral": f[2],
                "maxVertical": f[3], "RMS": f[4], "stdDevForward": f[7], "meanForward": f[8]
            ]
        }

    private func extractFeatures() -> [Double] {
        guard !motionBuffer.isEmpty else { return Array(repeating: 0.0, count: 9) }
        
        let fwd = motionBuffer.map { $0.forward }
        let lats = motionBuffer.map { $0.lateral }
        let verts = motionBuffer.map { $0.vertical }
        
        
        let meanF = fwd.reduce(0, +) / Double(fwd.count)
        
        let variance = fwd.map { pow($0 - meanF, 2) }.reduce(0, +) / Double(fwd.count)
        
        let stdDev = sqrt(variance)
        
        let sumOfSquares = motionBuffer.reduce(0.0) { $0 + (pow($1.forward, 2) + pow($1.lateral, 2) + pow($1.vertical, 2)) }
        let rmsTotal = sqrt(sumOfSquares / Double(motionBuffer.count))
        
        return [
            fwd.max() ?? 0,
            fwd.min() ?? 0,
            lats.map(abs).max() ?? 0,
            verts.map(abs).max() ?? 0,
            rmsTotal,
            0.0,
            Config.windowDuration,
            stdDev,
            meanF
        ]
    }
    
    private func saveEvent(type: EventType, features: [Double], hint: Int) {
        let event = HarshEvent(type: type)
        
        DispatchQueue.main.async {
            self.harshEvents.append(event)
            self.lastEvent = event
        }
        
        context.perform {
            let entity = HarshEventEntity(context: self.context)
            entity.id = event.id
            entity.type = event.type.rawValue
            entity.timestamp = event.timestamp
            try? self.context.save()
        }
        
        appendRowToCSV(features: features, hint: hint, label: type.rawValue)
    }

    func logNormalEvent() {
        let features = extractFeatures()
        saveEvent(type: .normal, features: features, hint: 4)
    }

    private func setupCSV() {
        if !FileManager.default.fileExists(atPath: csvPath.path) {
            let header = "maxForward,minForward,maxLateral,maxVertical,RMS,jerk,duration,stdDevForward,meanForward,ruleHint,eventType\n"
            try? header.write(to: csvPath, atomically: true, encoding: .utf8)
        }
    }

    private func appendRowToCSV(features: [Double], hint: Int, label: String) {
        let row = features.map { String(format: "%.4f", $0) }.joined(separator: ",") + ",\(hint),\(label)\n"
        DispatchQueue.global(qos: .background).async {
            if let fileHandle = try? FileHandle(forWritingTo: self.csvPath) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(row.data(using: .utf8)!)
                try? fileHandle.close()
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
                    type: EventType(rawValue: $0.type ?? "") ?? .normal,
                    timestamp: $0.timestamp ?? Date()
                )
            }
        } catch {
            print("Failed to fetch events: \(error)")
        }
    }
    
    func clearEvents() {
        harshEvents.removeAll()
        lastEvent = nil
        lastGlobalEventTime = nil
        
        let fetchRequest = HarshEventEntity.fetchRequest()
        if let results = try? context.fetch(fetchRequest) {
            for obj in results { context.delete(obj) }
            try? context.save()
        }
        try? "maxForward,minForward,maxLateral,maxVertical,RMS,jerk,duration,stdDevForward,meanForward,ruleHint,eventType\n".write(to: csvPath, atomically: true, encoding: .utf8)
    }

    func getCSVURL() -> URL {
        return csvPath
    }
    
    func exportEvents() -> String {
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
    @State private var isMonitoring = false
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Button(action: toggleMonitoring) {
                            HStack {
                                Image(systemName: isMonitoring ? "stop.fill" : "play.fill")
                                Text(isMonitoring ? "Stop Session" : "Start Session")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isMonitoring ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: motionManager.logNormalEvent) {
                            Text("Log Normal")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                
                Section("Mock Testing") {
                    HStack {
                        Button("Simulate Hard Accel") {
                            motionManager.lastLocation = CLLocation(
                                coordinate: CLLocationCoordinate2D(latitude: 34.8526, longitude: -82.3940),
                                altitude: 0, horizontalAccuracy: 1, verticalAccuracy: 1, course: 0,
                                speed: 0,
                                timestamp: Date()
                            )
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                motionManager.mockGPSChange(to: 18)
                            }
                        }
                        
                        Button("Simulate Hard Brake") {
                            motionManager.lastLocation = CLLocation(
                                coordinate: CLLocationCoordinate2D(latitude: 34.8526, longitude: -82.3940),
                                altitude: 0, horizontalAccuracy: 1, verticalAccuracy: 1, course: 0,
                                speed: 20,
                                timestamp: Date()
                            )
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                motionManager.mockGPSChange(to: 0)
                            }
                        }
                    }
                }

                List {
                    Section("Session Summary") {
                        ForEach(EventType.allCases, id: \.self) { type in
                            HStack {
                                Label(type.rawValue, systemImage: icon(for: type))
                                Spacer()
                                Text("\(motionManager.eventCounts[type] ?? 0)")
                                    .fontWeight(.bold)
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                    }
                    
                    Section("Event Log") {
                        ForEach(motionManager.debouncedEvents.reversed()) { event in
                            HStack {
                                Text(event.type.rawValue)
                                Spacer()
                                Text(event.timestamp, style: .time)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                HStack {
                    Button(role: .destructive, action: motionManager.clearEvents) {
                        Label("Reset Data", systemImage: "trash")
                    }
                    Spacer()
                    Button(action: { showShareSheet = true }) {
                        Label("Export CSV", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("DriveAware")
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [motionManager.getCSVURL()])
            }
        }
    }
    
    private func toggleMonitoring() {
        isMonitoring.toggle()
        isMonitoring ? motionManager.startMonitoring() : motionManager.stopMonitoring()
    }
    
    private func icon(for type: EventType) -> String {
        switch type {
        case .normal: return "car"
        case .hardBump: return "waveform.path.ecg"
        case .sharpTurn: return "arrow.turn.up.right"
        case .hardBrake: return "exclamationmark.octagon"
        case .hardAcceleration: return "bolt.fill"
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ ui: UIActivityViewController, context: Context) {}
}
