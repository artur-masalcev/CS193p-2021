//
//  AspectVGrid.swift
//  Set
//
//  Created by CS193p Instructor on 4/14/21.
//  Copyright Stanford University 2021
//

import SwiftUI

/// Puts array of 'Items' on the screen so that they always fit the given space and make a grid
struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
        var items: [Item]
        var aspectRatio: CGFloat
        var content: (Item) -> ItemView
        
        init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
            self.items = items
            self.aspectRatio = aspectRatio
            self.content = content
        }
        
        var body: some View {
            GeometryReader { geometry in
                VStack {
                    let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                    LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                        ForEach(items) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    
    /// Represents the item of the grid
    /// - Parameter width: width of the item
    /// - Returns: 'GridItem' item of the grid
        private func adaptiveGridItem(width: CGFloat) -> GridItem {
            var gridItem = GridItem(.adaptive(minimum: width))
            gridItem.spacing = 0
            return gridItem
        }
    
    /// Calculates the width for the grid items that will optimally occupy the screen
    /// - Parameters:
    ///   - itemCount: the number of items to show
    ///   - size: 'CGSize' size
    ///   - itemAspectRatio: aspect ratio of the item
    /// - Returns: the value that represents the optimal width for item
        private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
            var columnCount = 1
            var rowCount = itemCount
            repeat {
                let itemWidth = size.width / CGFloat(columnCount)
                let itemHeight = itemWidth / itemAspectRatio
                if  CGFloat(rowCount) * itemHeight < size.height {
                    break
                }
                columnCount += 1
                rowCount = (itemCount + (columnCount - 1)) / columnCount
            } while columnCount < itemCount
            if columnCount > itemCount {
                columnCount = itemCount
            }
            return floor(size.width / CGFloat(columnCount))
        }
}
