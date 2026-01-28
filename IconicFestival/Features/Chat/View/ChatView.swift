import SwiftUI
import SwiftData

/// AI-powered chat assistant for festival visitors
struct ChatView: View {

    // MARK: - State

    @State private var viewModel = ChatViewModel()
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatMessage.timestamp) private var messages: [ChatMessage]

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages
                messagesView

                // Input
                inputView
            }
            .background(AppColors.background)
            .navigationTitle("Festival Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        clearChat()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Messages View

    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Welcome message
                    if messages.isEmpty {
                        welcomeMessage
                    }

                    // Chat messages
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }

                    // Loading indicator
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .tint(AppColors.primaryGold)
                            Text("Thinking...")
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .onChange(of: messages.count) { _, _ in
                if let lastMessage = messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - Welcome Message

    private var welcomeMessage: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryGold)

            Text("Welcome to the Iconic Festival Assistant!")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Ask me anything about the festival - timetable, artists, facilities, or practical info.")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)

            // Quick suggestions
            VStack(spacing: 8) {
                Text("Try asking:")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)

                ForEach(viewModel.suggestions, id: \.self) { suggestion in
                    Button {
                        sendMessage(suggestion)
                    } label: {
                        Text(suggestion)
                            .font(.subheadline)
                            .foregroundColor(AppColors.primaryGold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppColors.primaryGold.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
            }
        }
        .padding(.vertical, 40)
    }

    // MARK: - Input View

    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("Ask about the festival...", text: $inputText)
                .textFieldStyle(.plain)
                .padding(12)
                .background(AppColors.secondaryBackground)
                .cornerRadius(24)
                .focused($isInputFocused)
                .submitLabel(.send)
                .onSubmit {
                    sendCurrentMessage()
                }

            Button {
                sendCurrentMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(inputText.isEmpty ? AppColors.textTertiary : AppColors.primaryGold)
            }
            .disabled(inputText.isEmpty || viewModel.isLoading)
        }
        .padding()
        .background(AppColors.primaryDark)
    }

    // MARK: - Actions

    private func sendCurrentMessage() {
        guard !inputText.isEmpty else { return }
        sendMessage(inputText)
        inputText = ""
    }

    private func sendMessage(_ text: String) {
        // Save user message
        let userMessage = ChatMessage(content: text, isUser: true)
        modelContext.insert(userMessage)

        // Get AI response
        Task {
            let response = await viewModel.getResponse(for: text)
            let aiMessage = ChatMessage(content: response, isUser: false)
            modelContext.insert(aiMessage)
        }
    }

    private func clearChat() {
        for message in messages {
            modelContext.delete(message)
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 60) }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isUser ? .white : AppColors.textPrimary)
                    .padding(12)
                    .background(
                        message.isUser
                            ? AppColors.primaryGold
                            : AppColors.secondaryBackground
                    )
                    .cornerRadius(16)

                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(AppColors.textTertiary)
            }

            if !message.isUser { Spacer(minLength: 60) }
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    ChatView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
}
