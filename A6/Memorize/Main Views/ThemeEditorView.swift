//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-09.
//

import SwiftUI

struct ThemeEditorView: View {
    @Binding var theme: MemoryGameTheme<String>
    
    private var maximumPairsOfCards: Int {
        theme.content.count
    }
    
    private let minimumPairsOfCards: Int = 2
    
    var body: some View {
        Form {
            nameSection
            numberOfPairsOfCardsSection
            themeContentSection
            recentEmojisSection
            colorSection
        }
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextEditor(text: $theme.name)
        }
    }
    
    var numberOfPairsOfCardsSection: some View {
        Section(header: Text("Number of pairs of cards")) {
            Stepper(value: $theme.numberOfPairsOfCards,
                    in: minimumPairsOfCards...maximumPairsOfCards,
                    step: 1) {
                Text("\(theme.numberOfPairsOfCards)")
            }
        }
    }
    
    var themeContentSection: some View {
        Section(header: Text("Emojis")) {
            TextEditor(text: $theme.contentAsString)
                .onChange(of: theme.contentAsString) { _ in
                    theme.contentAsString = theme.contentAsString.emojiString
                }
        }
    }
    
    private struct recentEmojisSectionConstants {
        static let gridItemMinimumValue: CGFloat = 40
        static let fontSize: CGFloat = 40
    }
    
    var recentEmojisSection: some View {
        Section(header: Text("Recently removed emojis (tap to add)")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: recentEmojisSectionConstants.gridItemMinimumValue))]) {
                withAnimation {
                    ForEach(Array(theme.removedContent), id: \.self) { emoji in
                        Text(emoji).onTapGesture {
                                theme.content.append(emoji)
                        }
                    }
                }
            }.font(.system(size: recentEmojisSectionConstants.fontSize))
        }
    }
    
    var colorSection: some View {
        Section(header: Text("Color")) {
            ColorPicker("Pick a color", selection: $theme.colorAsSwiftUIColor)
        }
    }
}

struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView(theme: .constant(DefaultEmojiThemes.food))
    }
}
