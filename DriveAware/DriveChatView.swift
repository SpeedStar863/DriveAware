//
//  DriveChatView.swift
//  DriveAware
//
//  Created by Alexander Ur on 1/19/26.
//

import SwiftUI

struct DriveChatView: View {
    let context: String
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var isTyping = false
    
    let service = ChatService()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages.filter { $0.role != .system }) { msg in
                            ChatBubble(msg: msg)
                                .id(msg.id)
                        }
                        
                        if isTyping {
                            HStack {
                                Text("Coach is thinking...")
                                    .font(.caption)
                                    .italic()
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            SuggestionsView { selectedText in
                inputText = selectedText
                sendMessage()
            }
            
            HStack {
                TextField("Ask a question...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.send)
                    .onSubmit(sendMessage)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                }
                .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .onAppear {
                if messages.isEmpty {
                    messages.append(Message(content: context, role: .system))
                    messages.append(Message(content: "I'm your DriveCoach! I've analyzed your stats. How can I help you today?", role: .assistant))
                }
            }
            .padding()
        }
        .navigationTitle("AI Coach")
    }

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
        
        let userMsg = Message(content: trimmed, role: .user)
        messages.append(userMsg)
        inputText = ""
        isTyping = true
        Task {
            do {
                let response = try await service.getResponse(messages: messages)
                await MainActor.run {
                    withAnimation(.spring()) {
                        messages.append(Message(content: response, role: .assistant))
                        isTyping = false
                    }
                }
            } catch {
                print("Error: \(error)")
                isTyping = false
            }
        }
    }
}

struct ChatBubble: View {
    let msg: Message
    
    var body: some View {
        HStack {
            if msg.isUser { Spacer() }
            Text(LocalizedStringKey(msg.content))
                .padding(12)
                .background(msg.isUser ? Color.blue : Color(.systemGray5))
                .foregroundColor(msg.isUser ? .white : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
            if !msg.isUser { Spacer() }
        }
    }
}

struct SuggestionsView: View {
    let suggestions = ["How do I parallel park?", "Tips for night driving", "What is my next task?"]
    var onSelect: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: { onSelect(suggestion) }) {
                        Text(suggestion)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct Message: Identifiable, Codable {
    let id: UUID
    let content: String
    let role: MessageRole
    
    var isUser: Bool { role == .user }
    
    init(id: UUID = UUID(), content: String, role: MessageRole) {
        self.id = id
        self.content = content
        self.role = role
    }
}

enum MessageRole: String, Codable {
    case system
    case user
    case assistant
}
