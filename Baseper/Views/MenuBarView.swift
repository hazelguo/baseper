import SwiftUI
import AppKit

struct MenuBarView: View {
    @ObservedObject var viewModel: TranscriptionViewModel
    @State private var showingSettings = false
    @State private var pulseAnimation = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 6) {
                Text("Baseper")
                    .font(.system(size: 14, weight: .semibold))

                if viewModel.sessionState.isRecording {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 7, height: 7)
                        .opacity(pulseAnimation ? 0.4 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulseAnimation)
                        .onAppear { pulseAnimation = true }
                        .onDisappear { pulseAnimation = false }
                }

                Spacer()

                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Settings")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Transcription text area
            ScrollViewReader { proxy in
                ZStack(alignment: .topLeading) {
                    ScrollView {
                        AttributedTextView(attributedText: viewModel.transcriptionText)
                            .frame(minHeight: 200, maxHeight: .infinity)
                            .id("textEditor")
                    }

                    if viewModel.transcriptionText.string.isEmpty && !viewModel.sessionState.isRecording {
                        Text("Click Start to begin transcription...")
                            .font(.system(size: 13))
                            .foregroundColor(Color(NSColor.tertiaryLabelColor))
                            .padding(.horizontal, 17)
                            .padding(.vertical, 8)
                            .allowsHitTesting(false)
                    }
                }
                .onChange(of: viewModel.transcriptionText) { _ in
                    withAnimation {
                        proxy.scrollTo("textEditor", anchor: .bottom)
                    }
                }
            }

            // Bottom toolbar
            HStack {
                // Copy button — labeled
                Button(action: { viewModel.copyToClipboard() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 11))
                        Text("Copy")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.transcriptionText.string.isEmpty)
                .help("Copy transcript to clipboard")

                Spacer()

                // Record button — centered pill
                Button(action: {
                    if viewModel.sessionState.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.sessionState.isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 11))
                        Text(recordButtonLabel)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(viewModel.sessionState.isRecording ? Color.red : Color.accentColor)
                    )
                    .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .disabled(!viewModel.hasAPIKey && !viewModel.sessionState.isRecording)
                .help(viewModel.sessionState.isRecording
                      ? "Pause recording (you can resume to continue this session)"
                      : "Start recording (text will append to this session)")

                Spacer()

                // New session button — clears transcript
                Button(action: { viewModel.clearTranscription() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .medium))
                        Text("New")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.transcriptionText.string.isEmpty || viewModel.sessionState.isRecording)
                .help("Clear transcript and start a new session")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.primary.opacity(0.03))
        }
        .frame(width: 420, height: 300)
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: viewModel)
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private var recordButtonLabel: String {
        if viewModel.sessionState.isRecording {
            return "Stop Recording"
        } else {
            return "Start Recording"
        }
    }
}

// NSViewRepresentable wrapper for NSTextView to display attributed text
struct AttributedTextView: NSViewRepresentable {
    let attributedText: NSAttributedString

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()

        guard let textView = scrollView.documentView as? NSTextView else {
            return scrollView
        }

        textView.isEditable = true
        textView.isSelectable = true
        textView.drawsBackground = false
        textView.textContainerInset = NSSize(width: 12, height: 8)
        textView.autoresizingMask = [.width]

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else {
            return
        }

        textView.textStorage?.setAttributedString(attributedText)

        // Auto-scroll to bottom
        textView.scrollToEndOfDocument(nil)
    }
}
