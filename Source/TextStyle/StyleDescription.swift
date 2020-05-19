//
//  StyleDescription.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/13.
//  Copyright © 2020 easy. All rights reserved.
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

let TVOS_SYSTEMFONT_SIZE: CGFloat = 29.0
let WATCHOS_SYSTEMFONT_SIZE: CGFloat = 12.0

/// A struct saved all of style's settings.
public struct StyleDescription {

    var attributes: [NSAttributedString.Key: Any]

    #if os(tvOS) || os(iOS) || os(watchOS)
    var dynamicText: DynamicText?
    #endif

    var lineSpacing: CGFloat?
    var paragraphSpacingBefore: CGFloat?
    var paragraphSpacing: CGFloat?
    var alignment: NSTextAlignment?
    var firstLineHeadIndent: CGFloat?
    var headIndent: CGFloat?
    var tailIndent: CGFloat?
    var lineBreakMode: NSLineBreakMode?
    var minimumLineHeight: CGFloat?
    var maximumLineHeight: CGFloat?
    var lineHeightMultiple: CGFloat?
    var hyphenationFactor: Float?
    var baseWritingDirection: NSWritingDirection?

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

    init(
        attributes: [NSAttributedString.Key: Any]
    ) {
        self.attributes = attributes
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

        // paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing ?? 0.0
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore ?? 0.0
        paragraphStyle.paragraphSpacing = paragraphSpacing ?? 0.0
        paragraphStyle.alignment = alignment ?? .natural
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent ?? 0.0
        paragraphStyle.headIndent = headIndent ?? 0.0
        paragraphStyle.tailIndent = tailIndent ?? 0.0
        paragraphStyle.lineBreakMode = lineBreakMode ?? .byWordWrapping
        paragraphStyle.minimumLineHeight = minimumLineHeight ?? 0.0
        paragraphStyle.maximumLineHeight = maximumLineHeight ?? 0.0
        paragraphStyle.lineHeightMultiple = lineHeightMultiple ?? 0.0
        paragraphStyle.hyphenationFactor = hyphenationFactor ?? 0.0
        paragraphStyle.baseWritingDirection = baseWritingDirection ?? .natural
        if paragraphStyle != NSParagraphStyle.default {
            attributes[.paragraphStyle] = paragraphStyle
        }
        let size: CGFloat
        #if os(tvOS)
        size = TVOS_SYSTEMFONT_SIZE
        #elseif os(watchOS)
        size = WATCHOS_SYSTEMFONT_SIZE
        #else
        size = Font.systemFontSize
        #endif
        var font = (attributes[.font] as? Font) ?? Font.systemFont(
            ofSize: size
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
        var descriptor: FontDescriptor? = font.fontDescriptor
        if !fontFeatures.isEmpty {
            descriptor = font.fontDescriptor.addingAttributes([
                FontDescriptorFeatureSettingsAttribute: fontFeatures,
            ])
        }

        // SymbolicTraits
        if let emphasis = emphasizeStyle {
            let existingTraits = descriptor?.symbolicTraits
            if let newTraits = existingTraits?.union(emphasis.symbolicTraits) {
                descriptor = descriptor?.withSymbolicTraits(newTraits)
            }
        }

        if let descriptor = descriptor {
            #if os(OSX)
            font = Font(descriptor: descriptor, size: font.pointSize)!
            #else
            font = Font(descriptor: descriptor, size: font.pointSize)
            #endif
        }

        #if os(tvOS) || os(watchOS) || os(iOS)
        if #available(iOS 11.0, watchOS 4.0, tvOS 11.0, *), dynamicText != nil {
            attributes[.font] = scalable(font: font)
        } else {
            attributes[.font] = font
        }
        #else
        attributes[.font] = font
        #endif

        // 字间距
        if let tracking = tracking {
            attributes[.kern] = tracking.kerning(for: font)
        }

        return attributes
    }

    #if os(tvOS) || os(watchOS) || os(iOS)
    @available(iOS 11, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
    private func scalable(font: UIFont) -> UIFont {
        let fontMetrics: UIFontMetrics
        if let textStyle = dynamicText?.style {
            fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        } else {
            fontMetrics = UIFontMetrics.default
        }

        #if os(iOS) || os(tvOS)
        return fontMetrics.scaledFont(
            for: font,
            maximumPointSize: dynamicText?.maximumPointSize ?? 0.0,
            compatibleWith: dynamicText?.traitCollection
        )
        #else
        return fontMetrics.scaledFont(
            for: font,
            maximumPointSize: dynamicText?.maximumPointSize ?? 0.0
        )
        #endif
    }
    #endif

    static func combine(_ parent: StyleDescription, _ child: StyleDescription) -> StyleDescription {
        let attributes = parent.attributes.merging(child.attributes) { _, new in
            return new
        }
        var description = StyleDescription(
            attributes: attributes
        )
        #if os(tvOS) || os(iOS) || os(watchOS)
        description.dynamicText = child.dynamicText ?? parent.dynamicText
        #endif

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
        description.hyphenationFactor = child.hyphenationFactor ?? parent.hyphenationFactor
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
