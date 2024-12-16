//
//  ContentView.swift
//  SideNotes
//
//  Created by Minesh Kumar on 12/16/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var windowManager = WindowManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Invisible background to catch clicks
                if windowManager.isPanelVisible {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            windowManager.hidePanel()
                        }
                }
                
                // Notes panel
                if windowManager.isPanelVisible {
                    notesPanel
                        .frame(width: 300)
                        .background(Color(.windowBackgroundColor))
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut, value: windowManager.isPanelVisible)
            .ignoresSafeArea()
        }
    }
    
    private var notesPanel: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Side Notes")
                    .font(.title)
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 12) {
                    NoteCard(title: "Sample Note 1", 
                            content: "This is a sample note content")
                    NoteCard(title: "Sample Note 2", 
                            content: "Another sample note with different content")
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
