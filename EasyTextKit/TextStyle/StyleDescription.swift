//
//  StyleDescription.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/13.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

public typealias ParagraphStyle = NSMutableParagraphStyle

public struct StyleDescription {
    
    internal var attributes: [NSAttributedString.Key: Any]
    
    internal var dynamicText: DynamicText?
    internal var paragraphStyle: ParagraphStyle
    internal var tracking: Tracking?
    internal var fontFeatureConstructors: [FontFeatureConstructor] = []
    internal var emphasizeStyle: EmphasizeStyle?
    internal var smallCaps: Set<SmallCaps> = []
    
    internal init(
        attributes: [NSAttributedString.Key: Any] = [:],
        paragraphStyle: ParagraphStyle? = nil
    ) {
        self.attributes = attributes
        self.paragraphStyle = paragraphStyle?.paragraphCopy() ?? ParagraphStyle()
    }
    
    internal mutating func set<T>(value: T?, forKey key: NSAttributedString.Key) {
        guard let value = value else {
            attributes.removeValue(forKey: key)
            return
        }
        attributes[key] = value
    }
    
    internal func get<T>(attributeForKey key: NSAttributedString.Key) -> T? {
        return attributes[key] as? T
    }
    
    internal func constructAttributes() -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = self.attributes
        
        attributes[.paragraphStyle] = paragraphStyle
        
        var font = (attributes[.font] as? UIFont) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
        let fontFeatures = fontFeatureConstructors.flatMap { $0.attributes() }
        
        if !fontFeatures.isEmpty {
            let descriptor = font.fontDescriptor.addingAttributes([
                UIFontDescriptor.AttributeName.featureSettings: fontFeatures
            ])
            
            font = UIFont(descriptor: descriptor, size: font.pointSize)
        }
        
        // SymbolicTraits
        if let emphasis = emphasizeStyle {
            let descriptor = font.fontDescriptor
            let existingTraits = descriptor.symbolicTraits
            let newTraits = existingTraits.union(emphasis.symbolicTraits)
            
            let newDescriptor = descriptor.withSymbolicTraits(newTraits)
            if let descriptor = newDescriptor {
                font = UIFont(descriptor: descriptor, size: font.pointSize)
            }
        }
        
        if #available(iOS 11.0, *), dynamicText != nil {
            attributes[.font] = scalable(font: font)
        } else {
            attributes[.font] = font
        }
        
        // 字间距
        if let tracking = tracking {
            attributes[.kern] = tracking.kerning(for: font)
        }
        
        return attributes
    }
    
    @available(iOS 11, *)
    private func scalable(font: UIFont) -> UIFont {
        let fontMetrics: UIFontMetrics
        if let textStyle = dynamicText?.style {
            fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        } else {
            fontMetrics = UIFontMetrics.default
        }
        
        return fontMetrics.scaledFont(
            for: font,
            maximumPointSize: dynamicText?.maximumPointSize ?? 0.0,
            compatibleWith: dynamicText?.traitCollection
        )
    }
    
    internal func copy() -> StyleDescription {
        var description = StyleDescription()
        description.attributes = attributes
        description.tracking = tracking
        description.dynamicText = dynamicText
        description.paragraphStyle = paragraphStyle.paragraphCopy()
        description.fontFeatureConstructors = fontFeatureConstructors
        description.emphasizeStyle = emphasizeStyle
        description.smallCaps = smallCaps
        return description
    }
    
}
