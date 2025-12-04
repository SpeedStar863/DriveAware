//
//  DriveAwareApp.swift
//  DriveAware
//
//  Created by Alexander Ur on 9/1/25.
//

import SwiftUI
import Charts
import CoreData

@main
struct DriveAwareApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(
                    MotionManager(context: persistenceController.container.viewContext)
                )
        }
    }
}

struct ContentView: View {
    var body: some View {
            TabView {
                HomeView(allLessons: drivingLessons)
                    .tabItem {
                        Label("Home", systemImage: "car.fill")
                    }
                
                LearningHubView()
                    .tabItem {
                        Label("My Lessons", systemImage: "book.fill")
                    }
                
                Plans()
                    .tabItem {
                        Label("Driving Plan", systemImage: "list.bullet.circle.fill")
                    }
                
                DetectorView()
                    .tabItem {
                        Label("Detector", systemImage: "dot.radiowaves.left.and.right")
                    }
            }
        }
    }

struct SkillAssessmentView: View {
    @State private var selectedScore: Int? = nil
    @State private var skillLevel: String? = nil
    @State private var navigateToSuggestedLessons = false
    
    let allLessons: [Lesson]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("How well do you understand the theory of driving?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(1...10, id: \.self) { score in
                            Button(action: {
                                selectedScore = score
                                determineSkillLevel(for: score)
                            }) {
                                Text("\(score)")
                                    .font(.headline)
                                    .frame(width: 40, height: 40)
                                    .background(selectedScore == score ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                if let level = skillLevel {
                    Text("You've been placed in the \(level) plan!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top)
                }
                
                Button(action: {
                    navigateToSuggestedLessons = true
                }) {
                    Text("Finish Assessment")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedScore == nil ? Color.gray.opacity(0.5) : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .disabled(selectedScore == nil)
                .navigationDestination(isPresented: $navigateToSuggestedLessons) {
                    SuggestedLessonsView(skillLevel: skillLevel ?? "Beginner", allLessons: allLessons)
                }
                .padding()
                .navigationTitle("Self-Assessment")
            }
        }
    }
    
    private func determineSkillLevel(for score: Int) {
        switch score {
        case 1...4: skillLevel = "Beginner"
        case 5...8: skillLevel = "Intermediate"
        default: skillLevel = "Advanced"
        }
    }
}

struct SuggestedLessonsView: View {
    let skillLevel: String
    let allLessons: [Lesson]
    
    let beginnerChapters = ["Chapter 1: Early Licensing", "Chapter 2: Driving Safe", "Chapter 3: Pre-Drive Checklist", "Chapter 4: The Foundation", "Chapter 5: The Laws and Guidelines", "Chapter 6: Driving Etiquette", "Chapter 7: Additional Suggestions"]
    let intermediateChapters = ["Chapter 3: Pre-Drive Checklist", "Chapter 4: The Foundation", "Chapter 5: The Laws and Guidelines", "Chapter 6: Driving Etiquette", "Chapter 7: Additional Suggestions"]
    let advancedChapters = ["Chapter 5: The Laws and Guidelines", "Chapter 6: Driving Etiquette", "Chapter 7: Additional Suggestions"]
    
    private var suggestedLessons: [Lesson] {
        switch skillLevel {
        case "Beginner": return allLessons.filter { beginnerChapters.contains($0.title) }
        case "Intermediate": return allLessons.filter { intermediateChapters.contains($0.title) }
        case "Advanced": return allLessons.filter { advancedChapters.contains($0.title) }
        default: return []
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(skillLevel) Lessons")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                ForEach(suggestedLessons) { lesson in
                    NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                        Text(lesson.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Suggested Lessons")
        }
    }
}

struct DetectorView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var motionManager: MotionManager
    @State private var showShareSheet = false
    @State private var exportString: String = ""
    @State private var isMonitoring = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Experimental Performance Detector: ")
                            .underline()
                            .font(.headline)
                        
                        Spacer(minLength: 4)
                        
                        Text("Mount your device on your vehicle's dashboard and press Start Monitoring to begin recording. The tool will detect harsh events defined in a dictionary on the home page. Data will be stored in a history section unless you clear it manually.")
                            .font(.headline)
                        
                        Spacer(minLength: 4)
                        headerView
                        Spacer(minLength: 2)
                        monitoringToggleButton
                        
                        if isMonitoring {
                            MonitoringView(motionManager: motionManager)
                        }
                        
                        Spacer(minLength: 2)
                        lastEventSection
                        Spacer(minLength: 2)
                        Divider()
                        eventSummarySection
                        Spacer(minLength: 2)
                        eventLogSection
                    }
                    .padding()
                    .navigationTitle("DriveAware")
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("Detector")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer(minLength: 2)
            Text(isMonitoring ? "Monitoring Active" : "Ready to Monitor")
                .foregroundColor(isMonitoring ? .green : .gray)
        }
    }
    
    private var monitoringToggleButton: some View {
        Button(action: {
            isMonitoring.toggle()
            isMonitoring ? motionManager.startMonitoring() : motionManager.stopMonitoring()
        }) {
            Text(isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isMonitoring ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var lastEventSection: some View {
        NavigationLink("View Last Event") {
            LastEventView()
                .environmentObject(motionManager)
        }
    }
    
    private var eventSummarySection: some View {
        EventSummaryView(events: motionManager.harshEvents)
    }
    
    private var eventLogSection: some View {
        VStack(alignment: .leading) {
            Text("Event Log")
                .font(.headline)
                .padding(.top)
            
            HStack {
                Button("Clear Log") {
                    motionManager.clearEvents()
                }
                .disabled(motionManager.debouncedEvents.isEmpty)
                .padding()
                
                Spacer()
                
                Button("Export Log") {
                    exportString = motionManager.exportEvents()
                    showShareSheet = true
                }
                .disabled(motionManager.debouncedEvents.isEmpty)
                .padding()
                .sheet(isPresented: $showShareSheet) {
                    ActivityView(activityItems: [exportString])
                }
            }
            
            if motionManager.debouncedEvents.isEmpty {
                Text("No events yet")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ForEach(motionManager.debouncedEvents.sorted(by: { $0.timestamp > $1.timestamp })) { event in
                    VStack(alignment: .leading) {
                        Text(event.type.rawValue)
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(event.timestamp.formatted(date: .abbreviated, time: .standard))
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }
}

struct LastEventView: View {
    @EnvironmentObject var motionManager: MotionManager
    
    private var lastEvent: HarshEvent? {
        motionManager.harshEvents.last
    }
    
    var body: some View {
        Group {
            if let event = lastEvent {
                VStack {
                    Text(event.type.rawValue)
                        .font(.title2)
                        .foregroundColor(.red)
                    Text(event.timestamp.formatted(.dateTime.hour().minute().second()))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            else {
                Text("No motion data yet")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct EventSummaryView: View {
    var events: [HarshEvent]
    
    private var eventCounts: [EventType: Int] {
        var counts: [EventType: Int] = [:]
        EventType.allCases.forEach { type in
            counts[type] = events.filter { $0.type == type}.count }
        return counts
    }
    
    var body: some View {
        
        Divider()
        
        VStack(alignment: .leading, spacing: 12) {
            Text("All Harsh Events")
                .font(.headline)
            
            List(events.reversed()) { event in
                Text("\(event.type.rawValue) at \(event.timestamp.formatted(.dateTime.hour().minute().second()))")
            }
            .frame(height: 200)
            
            .padding()
            
            Divider()
            
            Text("Event Summary")
                .font(.headline)
            
            HStack(spacing: 0) {
                ForEach(Array(EventType.allCases.enumerated()), id: \.1) { index, type in
                    Text("\(type.rawValue): \(eventCounts[type] ?? 0)")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    
                    if index < EventType.allCases.count - 1 {
                        Divider()
                    }
                }
            }
            
            Chart {
                ForEach(EventType.allCases, id: \.self) { type in
                    BarMark(
                        x: .value("Event Type", type.rawValue),
                        y: .value("Count", eventCounts[type] ?? 0)
                    )
                }
            }
            .frame(height: 150)
        }
    }
}
struct FeedbackView: View {
    @EnvironmentObject var motionManager: MotionManager
    
    let eventDescriptions: [EventType: String] = [
        .hardBrake: "Careful with hard braking!",
        .hardAcceleration: "Smooth acceleration is key!",
        .hardBump: "Be cautious on bumps!",
        .sharpTurn: "Steer smoothly!"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    let counts = motionManager.eventCounts
                    let top = topEvents(from: counts)
                    
                    if top.isEmpty {
                        Text("No harsh events recorded yet. Great job!")
                            .font(.headline)
                    } else {
                        ForEach(top, id: \.self) { type in
                            let count = counts[type] ?? 0
                            VStack (alignment: .leading, spacing: 6) {
                                Text("\(type.rawValue): \(count)")
                                    .font(.headline)
                                Text(eventDescriptions[type] ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Divider().padding(.vertical)
                    
                    Text("Click below for a full description of each event:")
                        .font(.headline)
                    
                    NavigationLink(destination:
                                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hard Bump")
                                .font(.headline)
                            Text("These events are caused by a sudden disruption in the vertical z-axis from your car's motion. Your vehicle most likely hit a bump or pothole while driving. These events are recorded to help you identify potential hazards on the road.")
                                .padding()
                            Text("Sharp Turn")
                                .font(.headline)
                            Text("These events are caused by a sudden change in the x-axis direction of your car's motion. Your vehicle most likely turned sharply while driving. These events are recorded to help you drive smoother while on the road.")
                                .padding()
                            Text("Hard Brake")
                                .font(.headline)
                            Text("These events are caused by a sudden stop in the y-axis of your car's motion. You most likely hit the brake pedal too hard while driving. These events are recorded to help you reduce sudden stops while on the road.")
                                .padding()
                            Text("Hard Acceleration")
                                .font(.headline)
                            Text("These events are caused by a sudden increase in the y-axis of your car's motion. You most likely hit the gas pedal too hard while driving. These events are recorded to help you reduce sudden jolts while on the road.")
                                .padding()
                        }
                        .padding()
                        .navigationTitle("Harsh Event Definitions")
                    }
                    ) {
                        Text("Harsh Event Definitions")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Feedback Summary")
        }
    }
    
    func topEvents(from counts: [EventType: Int]) -> [EventType] {
        guard let maxCount = counts.values.max(), maxCount > 0 else { return [] }
        return counts.filter { $0.value == maxCount }.map { $0.key }
        
    }
}
        
        struct HistoryView: View {
            @EnvironmentObject var motionManager: MotionManager
            
            var body: some View {
                NavigationView{
                    List(motionManager.harshEvents.reversed()) { event in VStack(alignment: .leading) {
                        Text(event.type.rawValue)
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        Text(event.timestamp.formatted(.dateTime.hour().minute().second()))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    }
                    .navigationTitle("History")
                }
            }
        }

struct CreditsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Text("Credits & Sources")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Adapted from the resources of the South Carolina Department of Motor Vehicles")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                Text("Works Cited")
                    .font(.headline)
                
                Text("South Carolina Department of Motor Vehicles. *South Carolina Driver's Manual*. SCDMV, 2025, https://scdps.sc.gov/sites/scdps/files/Documents/ohsjp/Driver%20Manual.pdf")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                Text("South Carolina Department of Motor Vehicles. *Regular License Testing*. SCDMV, 2021, https://www.scdmvonline.com/Driver-Services/Drivers-License/Testing/Regular-License-Road-Test")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
        .navigationTitle("Credits")
        .navigationBarTitleDisplayMode(.inline)
    }
}
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                let context = PersistenceController.preview.container.viewContext
                ContentView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(MotionManager(context: context))
            }
        }
