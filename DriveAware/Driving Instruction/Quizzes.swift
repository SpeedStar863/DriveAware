//
//  Quizes.swift
//  DriveAware
//
//  Created by Alexander Ur on 10/14/25.
//

import SwiftUI

struct QuizView: View {
    let lesson: Lesson
    @State private var currentQuestion = 0
    @State private var selectedAnswers: [String] = []
    @State private var userAnswers: [Int: [String]] = [:]
    @State private var score = 0
    @State private var showResult = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text(lesson.title)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top)
                    
                    Text(lesson.questions[currentQuestion].question)
                        .font(.headline)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ForEach(lesson.questions[currentQuestion].options, id:\.self) { option in
                        Button(action: {
                            handleSelection(option)
                        }) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: selectedAnswers.contains(option) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedAnswers.contains(option) ? .green: .gray)
                                    .padding(.top, 2)
                                Text(option)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    if currentQuestion > 0 {
                        currentQuestion -= 1
                        selectedAnswers = userAnswers[currentQuestion] ?? []
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(currentQuestion == 0 ? Color.gray.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(currentQuestion == 0)
                
                Button(action: submitAnswer) {
                    HStack {
                        Text(currentQuestion < lesson.questions.count - 1 ? "Next" : "Finish")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(.bottom, 8)
        
        .alert("Quiz Complete", isPresented: $showResult) {
            Button("Ok") {}
        } message: {
            Text("You scored \(score)/\(lesson.questions.count)")
        }
    }
    
    private func handleSelection(_ option: String) {
        let correctAnswers = lesson.questions[currentQuestion].correctAnswer
        let isSingleChoice = correctAnswers.count == 1
        
        if isSingleChoice {
            selectedAnswers = [option]
        } else {
            if let index = selectedAnswers.firstIndex(of: option) {
                selectedAnswers.remove(at: index)
            } else {
                selectedAnswers.append(option)
            }
        }
    }
    
    private func submitAnswer() {
        guard !selectedAnswers.isEmpty else { return }
        let correctAnswers = lesson.questions[currentQuestion].correctAnswer.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }.sorted()
        let userAnswersSorted = selectedAnswers.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() } .sorted()
        
        userAnswers[currentQuestion] = selectedAnswers
        
        if userAnswersSorted == correctAnswers {
            score += 1
        }
        
        selectedAnswers = []
        if currentQuestion < lesson.questions.count - 1 {
            currentQuestion += 1
        } else {
            showResult = true
        }
    }
}
