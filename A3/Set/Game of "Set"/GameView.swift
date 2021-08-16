//
//  GameView.swift
//  Set
//
//  Created by Artur Masalcev on 2021-06-30.
//

import SwiftUI

//TODO: drawing constants

struct GameView: View {
    typealias Player = TwoPlayerSetGame.Player
    
    @ObservedObject var game: TwoPlayerSetGameViewModel
    @State var isColorBlindMode = false
    
    var body: some View {
        VStack{
            menuView(for: .second).foregroundColor(.red).rotationEffect(Angle(degrees: -180))
            Divider()
            
            cardsView
            
            Divider()
            menuView(for: .first).foregroundColor(.blue)
            actionBar
        }
    }
    
    private var firstPlayerScoreView: some View {
        Text("\(game.firstPlayerScore)").font(.largeTitle).bold().foregroundColor(.blue)
    }
    
    private var secondPlayerScoreView: some View {
        Text("\(game.secondPlayerScore)").font(.largeTitle).bold().foregroundColor(.red)
    }
    
    private var whichPlayerIsChoosing: some View {
        switch game.whichPlayerIsChoosing {
        case .first:
            return Text("First player is choosing").foregroundColor(.blue)
        case .second:
            return Text("Second player is choosing").foregroundColor(.red)
        default:
            return Text("")
        }
    }
    
    private var cardsView: some View {
        AspectVGrid(items: game.cardsOnTheTable, aspectRatio: 2/3) { card in
            CardView(card: card, isForColorBlind: isColorBlindMode)
                .padding(3)
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        }
    }
    
    private func menuView(for player: Player) -> some View {
        HStack {
            if player == .first {
                Text("Score: \(game.firstPlayerScore)")
            }
            else {
                Text("Score: \(game.secondPlayerScore)")
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    game.setChoosingPlayer(player)
                }
            } label: {
                Text("Set!")
                    .padding(10)
                    
            }
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth:1))
            
            Button {
                withAnimation {
                    game.dealThreeMoreCards(by: player)
                }
            } label: {
                Text("Deal")
                    .padding(10)
                    
            }
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth:1))
        }.padding(2)
    }
    
    private var actionBar: some View {
        HStack {
            Button {
                game.hint()
            } label: {
                Image(systemName: "lightbulb")
            }
            
            Spacer()
            
            Button {
                isColorBlindMode.toggle()
            } label: {
                Text("Color-blind mode")
            }
            
            Spacer()
            
            Button {
                game.newGame()
            } label: {
                Image(systemName: "gobackward")
            }
        }.padding(2)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: TwoPlayerSetGameViewModel())
    }
}
