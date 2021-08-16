//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {

    typealias Emoji = EmojiArtModel.Emoji
    
    var emojis: [Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    struct UIEmoji {
        private var emoji: Emoji
        var isSelected = false
    }
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            scheduleAutosave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    //MARK: - Data persistance
    
    private var autosaveTimer: Timer?
    
    init() {
        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackgroundImageDataIfNecessary()
        }
        else {
            emojiArt = EmojiArtModel()
        }
    }
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            self.autosave()
        }
    }
    
    private struct Autosave {
        static let filename = "autosaved.emojiart"
        
        static let coalescingInterval = 5.0
        
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        }
        catch {
            print(error)
        }
    }
    
    // MARK: - Background
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            // fetch the url //
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    // MARK: - Selection
    
    @Published private var selectedEmojis: Set<Emoji> = []
    
    func isSelected(emoji: Emoji) -> Bool {
        selectedEmojis.contains(emoji)
    }
    
    private func refreshSelectedEmojis() {
        var selectedEmojisIDs = [Int]()
        for selectedEmoji in selectedEmojis { selectedEmojisIDs.append(selectedEmoji.id) }
        
        selectedEmojis.removeAll()
        
        for id in selectedEmojisIDs {
            if let updatedEmojiIndex = emojiArt.emojis.firstIndex(where: { $0.id == id } ) {
                let updatedEmoji = emojiArt.emojis[updatedEmojiIndex]
                selectedEmojis.update(with: updatedEmoji)
            }
            
        }
    }
    
    var isSelectionHappening: Bool {
        !selectedEmojis.isEmpty
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
    
    func selectEmoji(_ emoji: Emoji) {
        selectedEmojis.toggleMembership(of: emoji)
    }
    
    func deselectAllEmojis() {
        selectedEmojis.removeAll()
    }
    
    func dragSelectedEmojis(by offset: CGSize) {
        for selectedEmoji in selectedEmojis {
            moveEmoji(selectedEmoji, by: offset)
        }
        
        refreshSelectedEmojis()
    }
    
    func scaleSelectedEmojis(by scale: CGFloat) {
        for selectedEmoji in selectedEmojis {
            scaleEmoji(selectedEmoji, by: scale)
        }
        
        refreshSelectedEmojis()
    }
    
    func removeEmoji(_ emoji: Emoji) {
        if(isSelected(emoji: emoji)) {
            selectedEmojis.remove(emoji)
        }
        
        emojiArt.emojis.remove(emoji)
    }
}
