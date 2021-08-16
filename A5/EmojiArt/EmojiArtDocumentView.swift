//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(DrawingConstants.progressViewScaleEffect)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: EmojiArtDocumentView.fontSize(for: emoji)))
                            .border(DrawingConstants.emojiBorderColor, width: document.isSelected(emoji: emoji) ? DrawingConstants.emojiBorderWidth : 0)
                            .padding(EmojiArtDocumentView.fontSize(for: emoji) / DrawingConstants.emojiViewPaddingRatio)
                            .overlay(
                                Group {
                                    if document.isSelected(emoji: emoji) {
                                        emojiRemoveButton(emoji: emoji) { document.removeEmoji(emoji) }
                                    }
                                },
                                alignment: .topTrailing)
                            .scaleEffect(zoomScale)
                            .position(position(for: emoji, in: geometry))
                            .onTapGesture {
                                withAnimation {
                                    document.selectEmoji(emoji)
                                }
                            }
                            .gesture(emojiDragGesture(triggeredEmoji: emoji, in: geometry))
                    }
                    
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: zoomGesture()))
            .onTapGesture {
                withAnimation {
                    document.deselectAllEmojis()
                }
            }
        }
    }
    
    // MARK: - Document body elements
    
    private struct emojiRemoveButton: View {
        private var emoji: EmojiArtModel.Emoji
        private var onTapGestureFunction: () -> ()
        
        init(emoji: EmojiArtModel.Emoji, onTapGestureFunction: @escaping () -> ()) {
            self.emoji = emoji
            self.onTapGestureFunction = onTapGestureFunction
        }
        
        var body: some View {
            Image(systemName: "xmark.circle.fill").font(.system(size: fontSize(for: emoji) / DrawingConstants.emojiFontButtonSizeRatio))
                .onTapGesture(perform: onTapGestureFunction)
        }
    }
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private static func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    @GestureState private var lastEmojiScaleValue: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        if document.isSelectionHappening {
            return MagnificationGesture()
                .updating($lastEmojiScaleValue) { latestGestureScale, lastEmojiScaleValue, _ in
                    let gestureScale =  latestGestureScale / lastEmojiScaleValue
                    document.scaleSelectedEmojis(by: gestureScale)
                    lastEmojiScaleValue = latestGestureScale
                }
                .onEnded { _ in }
        }
        else {
            return MagnificationGesture()
                .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                    gestureZoomScale = latestGestureScale
                }
                .onEnded { gestureScaleAtEnd in
                    steadyStateZoomScale *= gestureScaleAtEnd
                }
        }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    // MARK: - Emoji drag
    
    @GestureState var latestEmojiDragOffset: CGPoint = CGPoint.zero
    
    private func emojiDragGesture(triggeredEmoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> some Gesture {
        return DragGesture()
            .updating($latestEmojiDragOffset) { latestDragGestureValue, emojiDragOffset, _ in
                let location
                    = emojiDragOffset == CGPoint.zero ? CGSize.zero : latestDragGestureValue.location - emojiDragOffset
                
                document.isSelected(emoji: triggeredEmoji) ? document.dragSelectedEmojis(by: location) : document.moveEmoji(triggeredEmoji, by: location)
                
                emojiDragOffset = latestDragGestureValue.location
            }
    }
    
    // MARK: - Palette
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
    
    // MARK: - Drawing constants
    
    private struct DrawingConstants {
        static let emojiBorderWidth: CGFloat = 3
        static let emojiBorderColor = Color.black
        static let progressViewScaleEffect: CGFloat = 2
        static let emojiFontButtonSizeRatio: CGFloat = 2.5
        static let emojiViewPaddingRatio: CGFloat = 3
    }
}

struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
