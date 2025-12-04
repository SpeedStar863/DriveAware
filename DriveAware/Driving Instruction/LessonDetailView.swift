//
//  LessonDetailView.swift
//  DriveAware
//
//  Created by Alexander Ur on 10/26/25.
//

import SwiftUI
import AVFoundation

class SpeechManager: ObservableObject {
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}

struct LessonDetailView: View {
    let lesson: Lesson
    @StateObject private var speechManager = SpeechManager()
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: {
                        let text = "\(lesson.title). \(lesson.description). \(lesson.content)"
                        speechManager.speak(text)
                    }) {
                        Label("Listen to Lesson", systemImage: "speaker.wave.2.fill")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Text(lesson.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(lesson.description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(lesson.content)
                        .padding(.top)
                        .font(.system(size: 18))
                        .lineSpacing(12)
                    
                    NavigationLink("Take Quiz") {
                        QuizView(lesson: lesson)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top)
                }
                .padding(.top)
            }
            .padding()
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
