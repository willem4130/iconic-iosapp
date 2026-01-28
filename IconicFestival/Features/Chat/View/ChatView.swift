import SwiftUI
import SwiftData

/// AI-gestuurde chat assistent voor festivalbezoekers
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
                // Logo header
                logoHeader

                // Messages
                messagesView

                // Input
                inputView
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
        }
    }

    // MARK: - Logo Header

    private var logoHeader: some View {
        HStack(spacing: 12) {
            Image("IconicLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 36)

            Text("Festival Assistent")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryGold)

            Spacer()

            Button {
                clearChat()
            } label: {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(AppColors.primaryDark)
    }

    // MARK: - Messages View

    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: true) {
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
                            Text("Even denken...")
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding()
                        .id("loading")
                    }

                    // Scroll anchor at the bottom
                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .padding()
            }
            .scrollIndicators(.visible)
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isLoading) { _, isLoading in
                if isLoading {
                    // Scroll to loading indicator when AI starts thinking
                    scrollToBottom(proxy: proxy)
                }
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.3)) {
            proxy.scrollTo("bottom", anchor: .bottom)
        }
    }

    // MARK: - Welcome Message

    private var welcomeMessage: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryGold)
                .animatedAppearance(delay: 0)

            Text("Welkom bij de Iconic Festival Assistent!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .animatedAppearance(delay: 0.1)

            Text("Stel me vragen over het festival - programma, artiesten, faciliteiten of praktische info.")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .animatedAppearance(delay: 0.15)

            // Quick suggestions
            VStack(spacing: 8) {
                Text("Probeer bijvoorbeeld:")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
                    .animatedAppearance(delay: 0.2)

                ForEach(Array(viewModel.suggestions.enumerated()), id: \.element) { index, suggestion in
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
                    .buttonStyle(.pressable)
                    .staggeredAppearance(index: index + 5, baseDelay: 0.08)
                }
            }

            // Social links
            VStack(spacing: 8) {
                Text("Volg ons voor updates!")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
                    .padding(.top, 16)

                HStack(spacing: 20) {
                    Link(destination: URL(string: FestivalInfo.contact.instagramURL)!) {
                        HStack(spacing: 4) {
                            Image(systemName: "camera.fill")
                            Text("Instagram")
                        }
                        .font(.caption)
                        .foregroundColor(AppColors.primaryGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.primaryGold.opacity(0.1))
                        .cornerRadius(16)
                    }

                    Link(destination: URL(string: FestivalInfo.contact.facebookURL)!) {
                        HStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup.fill")
                            Text("Facebook")
                        }
                        .font(.caption)
                        .foregroundColor(AppColors.primaryGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.primaryGold.opacity(0.1))
                        .cornerRadius(16)
                    }
                }
            }
        }
        .padding(.vertical, 40)
    }

    // MARK: - Input View

    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("Stel een vraag over het festival...", text: $inputText)
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
    @State private var hasAppeared = false

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
            .opacity(hasAppeared ? 1 : 0)
            .offset(x: hasAppeared ? 0 : (message.isUser ? 30 : -30))
            .scaleEffect(hasAppeared ? 1 : 0.9, anchor: message.isUser ? .trailing : .leading)
            .onAppear {
                withAnimation(AppAnimations.slideIn) {
                    hasAppeared = true
                }
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
