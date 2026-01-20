//
//  Views.swift
//  DriveAware
//
//  Created by Alexander Ur on 9/1/25.
//

import SwiftUI

struct HomeButton: View {
    let text: String
    
    var body: some View {
        Text(text)
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

struct HomeView: View {
    let allLessons: [Lesson]
    
    @StateObject var drivingManager = DrivingManager()
    
    @StateObject var motionManager = MotionManager(context: PersistenceController.shared.container.viewContext)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    NavigationLink(destination: SkillAssessmentView(allLessons: drivingLessons)) {
                        HomeButton(text: "Take Preliminary Skill Assessment")
                    }
                    
                    NavigationLink(destination: LearningHubView()) {
                        HomeButton(text: "Go to Instructional Lessons & Quizzes")
                    }
                    
                    NavigationLink(destination: Plans(manager: DrivingManager())) {
                        HomeButton(text: "Go to Your Three-Week Driving Plan")
                    }
                    
                    NavigationLink(destination: DetectorView()) {
                        HomeButton(text: "Record Your Driving Performance")
                    }
                    
                    NavigationLink {
                        DriveChatView(context: drivingManager.generateAIContext(motionManager: motionManager))
                    } label: {
                        HomeButton(text: "Consult Your AI Driving Coach")
                    }
                    
                    NavigationLink(destination: FeedbackView()) {
                        HomeButton(text: "Understand Your Driving Performance")
                    }
                    
                    NavigationLink(destination: HistoryView()) {
                        HomeButton(text: "View Your Historical Driving Data")
                    }
                    
                    NavigationLink(destination: CreditsView()) {
                        HomeButton(text: "View Contributing Sources to the Information")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let motionManager = MotionManager(context: context)
        
        HomeView(allLessons: drivingLessons)
            .environment(\.managedObjectContext, context)
            .environmentObject(motionManager)
    }
}
