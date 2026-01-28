import Foundation
import SwiftData

// MARK: - Favorite Artist

/// User's favorite artists for personalized experience
@Model
final class FavoriteArtist {
    @Attribute(.unique) var id: UUID
    var artistName: String
    var addedAt: Date
    var notificationsEnabled: Bool

    init(
        id: UUID = UUID(),
        artistName: String,
        addedAt: Date = Date(),
        notificationsEnabled: Bool = true
    ) {
        self.id = id
        self.artistName = artistName
        self.addedAt = addedAt
        self.notificationsEnabled = notificationsEnabled
    }
}

// MARK: - Chat Message

/// AI chat message for persistence
@Model
final class ChatMessage {
    @Attribute(.unique) var id: UUID
    var content: String
    var isUser: Bool
    var timestamp: Date

    init(
        id: UUID = UUID(),
        content: String,
        isUser: Bool,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}
