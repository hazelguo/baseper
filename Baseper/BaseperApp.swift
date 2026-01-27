import SwiftUI

@main
struct BaseperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var viewModel: TranscriptionViewModel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Migrate legacy API key if needed
        KeychainManager.shared.migrateFromLegacyGeminiKey()

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "waveform", accessibilityDescription: "Baseper")
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 420, height: 300)
        popover?.behavior = .transient

        // Create view model
        viewModel = TranscriptionViewModel()

        // Set popover content
        popover?.contentViewController = NSHostingController(
            rootView: MenuBarView(viewModel: viewModel!)
        )
    }

    @objc func togglePopover() {
        guard let popover = popover, let button = statusItem?.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
