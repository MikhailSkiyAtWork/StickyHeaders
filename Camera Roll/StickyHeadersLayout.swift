//
//  StickyHeadersLayout.swift
//  Camera Roll
//
//  Created by Михаил Валуйский on 21.03.16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class StickyHeaderLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElementsInRect(rect)! as [UICollectionViewLayoutAttributes]
        let headerNeedingLayout = NSMutableIndexSet()
        for attributes in layoutAttributes {
            if attributes.representedElementCategory == .Cell {
                headerNeedingLayout.addIndex(attributes.indexPath.section)
            }
        }
        
        for attributes in layoutAttributes {
            if let elementKind = attributes.representedElementKind{
                if elementKind == UICollectionElementKindSectionHeader {
                    headerNeedingLayout.removeIndex(attributes.indexPath.section)
                }
            }
        }
        
        headerNeedingLayout.enumerateIndexesUsingBlock{(index,stop) -> Void in
            let indexPath = NSIndexPath(forItem:0,inSection: index)
        let attributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
            layoutAttributes.append(attributes!)
        }
        
        for attributes in layoutAttributes{
            if let elementKind = attributes.representedElementKind{
                if elementKind == UICollectionElementKindSectionHeader {
                    let section = attributes.indexPath.section
                    let attributesForFirstItemInSection = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem:0, inSection:section))
                    let attributesForLastItemInSection = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem:collectionView!.numberOfItemsInSection(section)-1,inSection: section))
                    var frame = attributes.frame
                    let offset = collectionView!.contentOffset.y
                    
                    let minY = CGRectGetMinY(attributesForFirstItemInSection!.frame) - frame.height
                    let maxY = CGRectGetMaxY(attributesForLastItemInSection!.frame) - frame.height
                    
                    let y = min(max(offset,minY),maxY)
                    frame.origin.y = y
                    attributes.frame = frame
                    attributes.zIndex = 99
                    
                }
            }
        }
        return layoutAttributes
        
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}
