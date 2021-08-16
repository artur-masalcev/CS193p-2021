//
//  GameView.swift
//  Set
//
//  Created by Artur Masalcev on 2021-06-30.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game: UISetGame // View model
    
    @Namespace private var cardsNamespace // Namespace for all cards in the game
    
    @State var undealtCards = [SetGame.Card]() // Cards that are appearing from the deck
    
    
    /// Check whether is card is have only been dealt from the deck
    /// - Parameter card: game card
    /// - Returns: 'true' if card is have only appeared on the table. 'false' - otherwise
    private func isundealt(_ card: SetGame.Card) -> Bool {
        undealtCards.contains(where: {card.id == $0.id})
    }
    
    /// Mark the card is already been dealt on the table
    /// - Parameter card: game card
    private func deal(_ card: SetGame.Card) {
        undealtCards.append(card)
    }
    
    /// Shows score of the game
    var scoreView: some View {
        Text("\(game.score)").font(.largeTitle).bold().foregroundColor(.orange)
    }
    
    /// Shows all the cards on the table
    var cardsView: some View {
        AspectVGrid(items: game.cardsOnTheTable, aspectRatio: DrawingConstants.cardAspectRatio) { card in
            CardView(card: card)
                .flipEffect(isFaceUp: isundealt(card))
                .padding(3)
                .onTapGesture {
                    game.choose(card)
                }
                .rotation3DEffect(Angle.degrees(isundealt(card) ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .onAppear() {
                    deal(card)
                }
                .animation(.easeOut)
                .matchedGeometryEffect(id: card.id, in: cardsNamespace)
        }
    }
    
    /// Shows GUI buttons
    var menuView: some View {
        HStack {
            Button {
                withAnimation{
                    game.hint()
                }
            } label: {
                Image(systemName: "lightbulb").font(.largeTitle)
            }
            
            Spacer()
            
            Button {
                withAnimation(DrawingConstants.dealAnimation){
                    game.newGame()
                }
            } label: {
                Image(systemName: "gobackward").font(.largeTitle)
            }
        }
        .padding(DrawingConstants.menuViewPadding)
        .foregroundColor(.orange)
    }
    
    /// Shows the deck with undealt cards and the discard pile with matched cards
    var cardPilesView: some View {
        HStack {
            Deck(cards: game.deck, namespace: cardsNamespace) {
                game.dealThreeMoreCards()
            }
            Spacer()
            DiscardPile(cards: game.discardPile, namespace: cardsNamespace)
        }
        .padding()
    }
    
    var body: some View {
        VStack{
            scoreView
            cardsView
            cardPilesView
            Divider()
            Spacer()
            menuView
        }
    }
    
    private struct DrawingConstants {
        static let cardAspectRatio: CGFloat = 2/3
        static let dealAnimationDuration: Double = 0.3
        static let menuViewPadding: CGFloat = 3
        static let dealAnimation: Animation = Animation.easeOut(duration: dealAnimationDuration)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: UISetGame()).padding()
    }
}
