//
//  ContentView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-05-18.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("\(viewModel.theme.name)").bold()
            Text("\(viewModel.score)")
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card, color: viewModel.cardsColor)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            
            HStack {
                Button {
                    viewModel.startNewGame()
                } label: {
                    Image(systemName: "gobackward")
                }
                
                Spacer()
            }
            
        }
        .foregroundColor(viewModel.mainColor)
        .padding(.horizontal)
        .font(.largeTitle)
    }
}

struct CardView: View {
    init(_ card: MemoryGame<String>.Card, color: LinearGradient){
        self.card = card
        self.color = color
    }
    
    let card: MemoryGame<String>.Card
    let color: LinearGradient
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            }
            else if card.isMatched{
                shape.opacity(0)
            }
            else {
                shape.fill(color)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        Group {
            ContentView(viewModel: game)
                .previewDevice("iPhone 12 mini")
        }
    }
}
