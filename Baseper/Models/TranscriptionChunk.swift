import Foundation

struct TranscriptionChunk: Identifiable, Equatable {
    let id: UUID  // GhostID for tracking
    var text: String
    var status: ChunkStatus
    var timestamp: Date

    init(id: UUID = UUID(), text: String, status: ChunkStatus, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.status = status
        self.timestamp = timestamp
    }
}

enum ChunkStatus: Equatable {
    case uploading    // Gray placeholder
    case completed    // Black text
    case failed       // Error state
}

enum SessionState: Equatable {
    case idle
    case recording(startTime: Date)
    case review(chunks: [TranscriptionChunk])
    case finalized    // User clicked Copy
}

extension SessionState {
    var isRecording: Bool {
        if case .recording = self { return true }
        return false
    }
}
