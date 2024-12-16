//
//  SideNotesApp.swift
//  SideNotes
//
//  Created by Minesh Kumar on 12/16/24.
//

import SwiftUI

@main
struct SideNotesApp: App {
    private let statusBar = StatusBarController()
    @StateObject private var windowManager = WindowManager()
    
    var body: some Scene {
        Settings {
            // Empty view since we don't need a main window
            EmptyView()
        }
    }
    
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}
