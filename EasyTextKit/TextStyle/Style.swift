//
//  Style.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

public typealias AttributedString = NSMutableAttributedString

public class Style: StyleProtocol {
    
    public private(set) var styleDescription: StyleDescription
    
    public init(
        _ attributes: [NSAttributedString.Key: Any],
        paragraphStyle: ParagraphStyle? = nil
    ) {
        self.styleDescription = StyleDescription(attributes: attributes, paragraphStyle: paragraphStyle)
    }
    
    public init(_ style: Style? = nil) {
        self.styleDescription = style?.styleDescription.copy() ?? StyleDescription()
    }
    
    @discardableResult @available(iOS 11.0, *)
    public func dynamicText(_ dynamicText: DynamicText) -> Style {
        self.styleDescription.dynamicText = dynamicText
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Style {
        self.styleDescription.set(value: font, forKey: .font)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Style {
        self.styleDescription.set(value: color, forKey: .foregroundColor)
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Style {
        self.styleDescription.set(value: color, forKey: .backgroundColor)
        return self
    }
    
    @discardableResult
    public func underline(_ style: NSUnderlineStyle, color: UIColor) -> Style {
        self.styleDescription.set(value: style, forKey: .underlineStyle)
        self.styleDescription.set(value: color, forKey: .underlineColor)
        return self
    }
    
    @discardableResult
    public func stroke(_ color: UIColor, width: CGFloat) -> Style {
        self.styleDescription.set(value: color, forKey: .strokeColor)
        self.styleDescription.set(value: width, forKey: .strokeWidth)
        return self
    }
    
    @discardableResult
    public func strikethroughStyle(_ style: NSUnderlineStyle, color: UIColor) -> Style {
        self.styleDescription.set(value: style, forKey: .strikethroughStyle)
        self.styleDescription.set(value: color, forKey: .strikethroughColor)
        return self
    }

    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> Style {
        self.styleDescription.set(value: baselineOffset, forKey: .baselineOffset)
        return self
    }
    
    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.lineSpacing = lineSpacing
        return self
    }
    
    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
    
    @discardableResult
    public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.paragraphSpacing = paragraphSpacing
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Style {
        self.styleDescription.paragraphStyle.alignment = alignment
        return self
    }
    
    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    @discardableResult
    public func headIndent(_ headIndent: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.headIndent = headIndent
        return self
    }
    
    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.tailIndent = tailIndent
        return self
    }
    
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Style {
        self.styleDescription.paragraphStyle.lineBreakMode = lineBreakMode
        return self
    }
    
    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.minimumLineHeight = minimumLineHeight
        return self
    }
    
    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.maximumLineHeight = maximumLineHeight
        return self
    }
    
    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> Style {
        self.styleDescription.paragraphStyle.lineHeightMultiple = lineHeightMultiple
        return self
    }
    
    @discardableResult
    public func hyphenation(_ hyphenation: Hyphenation) -> Style {
        self.styleDescription.paragraphStyle.hyphenationFactor = hyphenation.rawValue
        return self
    }
    
    @discardableResult
    public func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> Style {
        self.styleDescription.paragraphStyle.baseWritingDirection = baseWritingDirection
        return self
    }
    
    @discardableResult
    public func shadow(_ shadow: NSShadow) -> Style {
        self.styleDescription.set(value: shadow, forKey: .shadow)
        return self
    }
    
    @discardableResult
    public func linkURL(_ linkURL: URL) -> Style {
        self.styleDescription.set(value: linkURL, forKey: .link)
        return self
    }
    
    @discardableResult
    public func ligature(_ ligature: Ligature) -> Style {
        self.styleDescription.set(value: ligature.rawValue, forKey: .ligature)
        return self
    }
    
    @discardableResult
    public func tracking(_ tracking: Tracking) -> Style {
        self.styleDescription.tracking = tracking
        return self
    }
    
    @discardableResult
    public func numberCase(_ numberCase: NumberCase) -> Style {
        self.styleDescription.fontFeatureConstructors += [numberCase]
        return self
    }
    
    @discardableResult
    public func numberSpacing(_ numberSpacing: NumberSpacing) -> Style {
        self.styleDescription.fontFeatureConstructors += [numberSpacing]
        return self
    }
    
    @discardableResult
    public func fractions(_ fractions: Fractions) -> Style {
        self.styleDescription.fontFeatureConstructors += [fractions]
        return self
    }
    
    @discardableResult
    public func superscript(isOn: Bool) -> Style {
        let verticalPosition: VerticalPosition = isOn ? .superscript : .normal
        self.styleDescription.fontFeatureConstructors += [verticalPosition]
        return self
    }
    
    @discardableResult
    public func `subscript`(isOn: Bool) -> Style {
        let verticalPosition: VerticalPosition = isOn ? .subscript : .normal
        self.styleDescription.fontFeatureConstructors += [verticalPosition]
        return self
    }
    
    @discardableResult
    public func ordinals(isOn: Bool) -> Style {
        let verticalPosition: VerticalPosition = isOn ? .ordinals : .normal
        self.styleDescription.fontFeatureConstructors += [verticalPosition]
        return self
    }
    
    @discardableResult
    public func scientificInferiors(isOn: Bool) -> Style {
        let verticalPosition: VerticalPosition = isOn ? .scientificInferiors : .normal
        self.styleDescription.fontFeatureConstructors += [verticalPosition]
        return self
    }
    
    @discardableResult
    public func smallCaps(_ smallCaps: Set<SmallCaps>) -> Style {
        self.styleDescription.fontFeatureConstructors += smallCaps.map { $0 }
        return self
    }
    
    @discardableResult
    public func emphasizeStyle(_ emphasizeStyle: EmphasizeStyle) -> Style {
        self.styleDescription.emphasizeStyle = emphasizeStyle
        return self
    }
    
}
