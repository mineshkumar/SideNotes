import AppKit
import SwiftUI

class WindowManager: ObservableObject {
    private var panelWindow: NSWindow?
    private var mouseMonitor: Any?
    private var clickMonitor: Any?
    @Published var isPanelVisible = false
    
    init() {
        setupMouseMonitor()
    }
    
    private func setupMouseMonitor() {
        mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            guard let self = self else { return }
            let screenFrame = NSScreen.main?.visibleFrame ?? .zero
            
            // Check if mouse is at the right edge
            if event.locationInWindow.x >= screenFrame.maxX - 5 && !self.isPanelVisible {
                self.showPanel()
            }
        }
    }
    
    private func showPanel() {
        if panelWindow == nil {
            setupPanelWindow()
        }
        
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            panelWindow?.animator().setFrame(NSRect(
                x: screenFrame.maxX - 300,
                y: screenFrame.minY,
                width: 300,
                height: screenFrame.height
            ), display: true)
        }
        
        panelWindow?.makeKeyAndOrderFront(nil)
        isPanelVisible = true
        
        // Remove existing click monitor if any
        if let existingMonitor = clickMonitor {
            NSEvent.removeMonitor(existingMonitor)
        }
        
        // Add new click monitor
        clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, let panel = self.panelWindow else { return }
            let clickLocation = event.locationInWindow
            
            if !NSPointInRect(panel.convertPoint(fromScreen: clickLocation), panel.contentView?.bounds ?? .zero) {
                self.hidePanel()
            }
        }
    }
    
    func hidePanel() {
        guard let screen = NSScreen.main else { return }
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            panelWindow?.animator().setFrame(NSRect(
                x: screen.visibleFrame.maxX + 300,
                y: screen.visibleFrame.minY,
                width: 300,
                height: screen.visibleFrame.height
            ), display: true)
        }
        
        // Remove click monitor when hiding
        if let monitor = clickMonitor {
            NSEvent.removeMonitor(monitor)
            clickMonitor = nil
        }
        
        isPanelVisible = false
    }
    
    private func setupPanelWindow() {
        panelWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 800),
            styleMask: [.fullSizeContentView, .titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        panelWindow?.contentView = NSHostingView(rootView: ContentView())
        panelWindow?.isMovable = false
        panelWindow?.level = .floating
        panelWindow?.backgroundColor = .clear
        panelWindow?.isOpaque = false
        panelWindow?.hasShadow = true
        panelWindow?.titlebarAppearsTransparent = true
        panelWindow?.standardWindowButton(.closeButton)?.isHidden = true
        panelWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panelWindow?.standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    deinit {
        if let monitor = mouseMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = clickMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
} 