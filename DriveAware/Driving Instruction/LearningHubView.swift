//
//  LearningHubView.swift
//  DriveAware
//
//  Created by Alexander Ur on 10/26/25.
//

import SwiftUI

struct LearningHubView: View {
    var skillLevel: String = "Beginner"
    @State private var selectedLesson: Lesson?
    
    var filteredLessons: [Lesson] {
        switch skillLevel {
        case "Beginner":
            return Array(drivingLessons.prefix(3))
        case "Intermediate":
            return Array(drivingLessons.prefix(5))
        default: return drivingLessons
        }
    }
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    List(drivingLessons) { lesson in
                        NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                            VStack(alignment: .leading) {
                                Text(lesson.title)
                                    .font(.headline)
                                Text(lesson.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.plain)
                }
                .navigationTitle("My Lessons")
            }
        }
    }
