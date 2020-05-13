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
    
    var attributes: [NSAttributedString.Key: Any]
    var dynamicText: DynamicText?
    
    var lineSpacing: CGFloat? {
        didSet { paragraphStyle.lineSpacing = lineSpacing ?? 0 }
    }
    var paragraphSpacingBefore: CGFloat? {
        didSet { paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore ?? 0.0 }
    }
    var paragraphSpacing: CGFloat? {
        didSet { paragraphStyle.paragraphSpacing = paragraphSpacing ?? 0.0 }
    }
    var alignment: NSTextAlignment? {
        didSet { paragraphStyle.alignment = alignment ?? .natural }
    }
    var firstLineHeadIndent: CGFloat? {
        didSet { paragraphStyle.firstLineHeadIndent = firstLineHeadIndent ?? 0.0 }
    }
    var headIndent: CGFloat? {
        didSet { paragraphStyle.headIndent = headIndent ?? 0.0 }
    }
    var tailIndent: CGFloat? {
        didSet { paragraphStyle.tailIndent = tailIndent ?? 0.0 }
    }
    var lineBreakMode: NSLineBreakMode? {
        didSet { paragraphStyle.lineBreakMode = lineBreakMode ?? .byWordWrapping }
    }
    var minimumLineHeight: CGFloat? {
        didSet { paragraphStyle.minimumLineHeight = minimumLineHeight ?? 0.0 }
    }
    var maximumLineHeight: CGFloat? {
        didSet { paragraphStyle.maximumLineHeight = maximumLineHeight ?? 0.0 }
    }
    var lineHeightMultiple: CGFloat? {
        didSet { paragraphStyle.lineHeightMultiple = lineHeightMultiple ?? 0.0 }
    }
    var hyphenation: Hyphenation? {
        didSet { paragraphStyle.hyphenationFactor = hyphenation?.rawValue ?? 0 }
    }
    var baseWritingDirection: NSWritingDirection? {
        didSet { paragraphStyle.baseWritingDirection = baseWritingDirection ?? .natural }
    }
    
    var tracking: Tracking?
    var numberCase: NumberCase?
    var numberSpacing: NumberSpacing?
    var fractions: Fractions?
    var superscript: Bool?
    var `subscript`: Bool?
    var ordinals: Bool?
    var scientificInferiors: Bool?
    var smallCaps: Set<SmallCaps>?
    var emphasizeStyle: EmphasizeStyle?
    
    private(set) var paragraphStyle: ParagraphStyle
    
    init(
        attributes: [NSAttributedString.Key: Any] = [:],
        paragraphStyle: ParagraphStyle? = nil
    ) {
        self.attributes = attributes
        self.paragraphStyle = paragraphStyle?.paragraphCopy() ?? ParagraphStyle()
    }
    
    mutating func set<T>(value: T?, forKey key: NSAttributedString.Key) {
        guard let value = value else {
            attributes.removeValue(forKey: key)
            return
        }
        attributes[key] = value
    }
    
    func get<T>(attributeForKey key: NSAttributedString.Key) -> T? {
        return attributes[key] as? T
    }
    
    func constructAttributes() -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = self.attributes
        attributes[.paragraphStyle] = paragraphStyle
        
        var font = (attributes[.font] as? UIFont) ?? UIFont.systemFont(
            ofSize: UIFont.systemFontSize
        )
        
        var fontFeatureConstructors: [FontFeatureConstructor] = []
        fontFeatureConstructors += [numberCase].compactMap { $0 }
        fontFeatureConstructors += [numberSpacing].compactMap { $0 }
        fontFeatureConstructors += [fractions].compactMap { $0 }
        fontFeatureConstructors += [superscript].compactMap { $0 }
            .map { $0 ? VerticalPosition.superscript : VerticalPosition.normal }
        fontFeatureConstructors += [`subscript`].compactMap { $0 }
            .map { $0 ? VerticalPosition.subscript : VerticalPosition.normal }
        fontFeatureConstructors += [ordinals].compactMap { $0 }
            .map { $0 ? VerticalPosition.ordinals : VerticalPosition.normal }
        fontFeatureConstructors += [scientificInferiors].compactMap { $0 }
            .map { $0 ? VerticalPosition.scientificInferiors : VerticalPosition.normal }
        fontFeatureConstructors += smallCaps?.map { $0 } ?? []
        
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
    
    func copy() -> StyleDescription {
        var description = StyleDescription()
        description.attributes = attributes
        description.tracking = tracking
        description.dynamicText = dynamicText
        description.paragraphStyle = paragraphStyle.paragraphCopy()
        description.numberCase = numberCase
        description.numberSpacing = numberSpacing
        description.fractions = fractions
        description.superscript = superscript
        description.subscript = `subscript`
        description.ordinals = ordinals
        description.scientificInferiors = scientificInferiors
        description.smallCaps = smallCaps
        description.emphasizeStyle = emphasizeStyle
        return description
    }
    
    static func combine(_ parent: StyleDescription, _ child: StyleDescription) -> StyleDescription {
        let attributes = parent.attributes.merging(child.attributes) { _, new in
            return new
        }
        var description = StyleDescription(
            attributes: attributes,
            paragraphStyle: parent.paragraphStyle
        )
        description.dynamicText = child.dynamicText ?? parent.dynamicText
        
        description.lineSpacing = child.lineSpacing ?? parent.lineSpacing
        description.paragraphSpacingBefore = child.paragraphSpacingBefore
            ?? parent.paragraphSpacingBefore
        description.paragraphSpacing = child.paragraphSpacing ?? parent.paragraphSpacing
        description.alignment = child.alignment ?? parent.alignment
        description.firstLineHeadIndent = child.firstLineHeadIndent ?? parent.firstLineHeadIndent
        description.headIndent = child.headIndent ?? parent.headIndent
        description.tailIndent = child.tailIndent ?? parent.tailIndent
        description.lineBreakMode = child.lineBreakMode ?? parent.lineBreakMode
        description.minimumLineHeight = child.minimumLineHeight ?? parent.minimumLineHeight
        description.maximumLineHeight = child.maximumLineHeight ?? parent.maximumLineHeight
        description.lineHeightMultiple = child.lineHeightMultiple ?? parent.lineHeightMultiple
        description.hyphenation = child.hyphenation ?? parent.hyphenation
        description.baseWritingDirection = child.baseWritingDirection ?? parent.baseWritingDirection
        
        description.tracking = child.tracking ?? parent.tracking
        description.numberCase = child.numberCase ?? parent.numberCase
        description.numberSpacing = child.numberSpacing ?? parent.numberSpacing
        description.fractions = child.fractions ?? parent.fractions
        description.superscript = child.superscript ?? parent.superscript
        description.subscript = child.subscript ?? parent.subscript
        description.ordinals = child.ordinals ?? parent.ordinals
        description.scientificInferiors = child.scientificInferiors ?? parent.scientificInferiors
        description.smallCaps = parent.smallCaps?.union(child.smallCaps ?? []) ?? child.smallCaps
        description.emphasizeStyle = parent.emphasizeStyle?.union(
            child.emphasizeStyle ?? []) ?? child.emphasizeStyle
        
        return description
    }
    
}
