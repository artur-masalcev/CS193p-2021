//
//  ContentView.swift
//  Memorize
//
//  Created by Artur Masalcev on 2021-08-16.
//

import SwiftUI

struct ContentView: View {
    var summerEmojis = ["☀️","🍉","🏐","🏄‍♂️","🐠","✈️","🏝","🏖","🎡","🎢","🛥","🚤"]
    var animalsEmojis = ["🐶","🐱","🐯","🐻‍❄️","🙈","🐸","🐼","🦄","🐔","🐹","🦖","🐺"]
    var musicEmojis = ["🎧","🎷","🎻","🎸","🪗","🥁","🎹","🎼","🪕","🔉","🎶","🎵"]
    
    @State var emojiCount = 12
    @State var emojisToShow = ["☀️","🍉","🏐","🏄‍♂️","🐠","✈️","🏝","🏖","🎡","🎢","🛥","🚤"]
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatFitsBest(cardCount: emojiCount)))]) {
                    ForEach(emojisToShow[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            
            Spacer()
            HStack {
                animalsThemeButton
                Spacer()
                summerThemeButton
                Spacer()
                musicThemeButton
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }.padding()
    }
    
    var summerThemeButton: some View {
        Button {
            emojiCount = Int.random(in: 4...summerEmojis.count)
            emojisToShow = summerEmojis.shuffled()
        } label: {
            VStack {
                Image(systemName: "sun.max").font(.largeTitle)
                Text("Summer").font(.caption)
            }
        }
    }
    
    var animalsThemeButton: some View {
        Button {
            emojiCount = Int.random(in: 4...animalsEmojis.count)
            emojisToShow = animalsEmojis.shuffled()
        } label: {
            VStack {
                Image(systemName: "tortoise").font(.largeTitle)
                Text("Animals").font(.caption)
            }
        }
    }
    
    var musicThemeButton: some View {
        Button {
            emojiCount = Int.random(in: 4...musicEmojis.count)
            emojisToShow = musicEmojis.shuffled()
        } label: {
            VStack {
                Image(systemName: "pianokeys").font(.largeTitle)
                Text("Music").font(.caption)
            }
        }
    }
    
    var remove: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    
    var add: some View {
        Button {
            if emojiCount < summerEmojis.count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
    }
    
    func widthThatFitsBest(cardCount: Int) -> CGFloat {
        if cardCount < 4 {
            return 100
        }
        else {
            return 60
        }
    }
    
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            }
            else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
