//
//  ThemeStoreView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-09.
//

import SwiftUI

/// Shows all the available game themes as well as provides GUI for managing them
struct ThemeStoreView: View {
    typealias Theme = MemoryGameTheme<String>
    
    /// ViewModel that functions as a container for all the themes in the game
    @EnvironmentObject var themeStore: ThemeStore
    
    /// Contains all the currently played games
    @State private var games: Dictionary<Int, EmojiMemoryGame> = [:]
    
    @State private var editMode: EditMode = .inactive
    
    @State private var showingThemeEditorPopover = false
    
    @State private var themeToEdit: Theme?
    
    var body: some View {
        NavigationView {
            List {
                themes(viewModel: themeStore)
            }
            .navigationTitle("Memorize")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    AnimatedActionButton(systemImage: "plus") {
                        themeToEdit = themeStore.createNewTheme() // Create new theme and open editor window
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .onChange(of: themeToEdit, perform: { _ in
                updateGames()
            })
        }
    }
    
    private func themes(viewModel: ThemeStore) -> some View {
        ForEach(themeStore.themes) { theme in
            NavigationLink(destination: EmojiMemoryGameView(game: getGame(theme: theme))) {
                themeView(theme: theme)
            }
            .gesture(editMode == .active ? navigationLinkTap(theme: theme) : nil)
            .popover(item: $themeToEdit) { theme in
                ThemeEditorView(theme: $themeStore.themes[theme])
            }
        }
        .onDelete { offset in
            themeStore.removeTheme(atOffset: offset)
        }
        .onMove { source, destination in
            themeStore.moveTheme(fromOffsets: source, toOffset: destination)
        }
    }
    
    // MARK: - Gestures
    
    private func navigationLinkTap(theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    // MARK: - Games management
    
    private func updateGames() {
        for theme in themeStore.themes {
            if games[theme.id] == nil {
                games[theme.id] = EmojiMemoryGame(theme: theme)
            }
            else {
                // Replace old theme with the new one if needed //
                if !(games[theme.id]!.theme.equals(to: theme)) {
                    games[theme.id]!.theme = theme
                }
            }
        }
    }

    private func getGame(theme: Theme) -> EmojiMemoryGame {
        if let game = games[theme.id] {
            return game
        }
        else {
            let game = EmojiMemoryGame(theme: theme)
            games[theme.id] = game
            return game
        }
    }
    
    // MARK: - Drawing Constants
    
    private struct DrawingConstants {
        static let spacingValueInThemeView: CGFloat = 5
        static let lineLimitInThemeView: Int = 1
    }
}

// MARK: - Previews

struct ThemeStoreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ThemeStoreView().environmentObject(ThemeStore(name: "preview"))
        }
    }
}
