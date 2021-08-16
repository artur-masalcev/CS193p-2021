//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-18.
//

import SwiftUI

/// Shows state of memory card game with emojis as a content
struct EmojiMemoryGameView: View {
    /// View model, represents current state of the game
    @ObservedObject var game: EmojiMemoryGame
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            cardsView
            
            HStack {
                returnButton
                Spacer()
                newGameButton
            }
        }
        .foregroundColor(Color(game.theme.color))
        .font(.largeTitle)
        .padding()
        .navigationBarHidden(true)
    }
    
    var newGameButton: some View {
        Button {
            withAnimation {
                game.startNewGame()
            }
        } label: {
            Image(systemName: "gobackward")
        }
    }
    
    var returnButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
        }
    }
    
    var cardsView: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card)
                    .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("\(game.theme.name)").bold()
            Text("\(game.score)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: DefaultEmojiThemes.summer)
        Group {
            EmojiMemoryGameView(game: game)
                .previewDevice("iPhone 12 mini")
        }
    }
}
