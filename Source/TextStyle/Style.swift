//
//  Style.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

public typealias AttributedString = NSMutableAttributedString

// swiftlint:disable:next type_body_length
public struct Style: StyleProtocol {

    /// This struct modified when you set style.
    public private(set) var styleDescription: StyleDescription

    /// Initialize a new style from a predefined set of attributes.
    ///
    /// - Parameter attributes: Dictionary to set
    public init(_ attributes: [NSAttributedString.Key: Any] = [:]) {
        self.styleDescription = StyleDescription(attributes: attributes)
    }

    /// Initialize a new style from an existing style description object.
    ///
    /// - Parameter styleDescription: Existing style description object
    init(_ styleDescription: StyleDescription) {
        self.styleDescription = styleDescription
    }

    /// 动态字体，根据用户设置实现对字体大小的控制
    #if os(tvOS) || os(iOS) || os(watchOS)
    @discardableResult @available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
    public func dynamicText(_ dynamicText: DynamicText?) -> Style {
        var description = styleDescription
        description.dynamicText = dynamicText
        return Style(description)
    }
    #endif

    /// Set the font of the style.
    ///
    /// - Parameter font: `UIFont` or `NSFont` object
    @discardableResult
    public func font(_ font: Font?) -> Style {
        var description = styleDescription
        description.set(value: font, forKey: .font)
        return Style(description)
    }

    /// Set the text color of the style.
    ///
    /// - Parameter color: `UIColor` or `NSColor` object
    @discardableResult
    public func foregroundColor(_ color: Color?) -> Style {
        var description = styleDescription
        description.set(value: color, forKey: .foregroundColor)
        return Style(description)
    }

    /// Set the background color of the style.
    ///
    /// - Parameter color: `UIFont` or `NSFont` object for background color
    @discardableResult
    public func backgroundColor(_ color: Color?) -> Style {
        var description = styleDescription
        description.set(value: color, forKey: .backgroundColor)
        return Style(description)
    }

    /// This value indicates whether the text is underlined.
    ///
    /// - Parameters:
    ///    - style: The style of the line (as `NSUnderLineStyle`).
    ///    - color: The optional color of the line (if `nil`, foreground color is used instead).
    @discardableResult
    public func underline(_ style: NSUnderlineStyle?, color: Color?) -> Style {
        var description = styleDescription
        description.set(value: style?.rawValue, forKey: .underlineStyle)
        description.set(value: color, forKey: .underlineColor)
        return Style(description)
    }

    /// Define stroke attributes.
    ///
    /// - Parameters:
    ///     - color: The optional color of the line (if `nil`, foreground color is used instead).
    ///     - width: Represents the amount to change the stroke width and is specified as a percentage
    ///     of the font point size. Specify 0 (the default) for no additional changes.
    ///     Positive values to change the stroke width alone.
    ///     Negative values to stroke and fill the text.
    @discardableResult
    public func stroke(_ color: Color?, width: CGFloat?) -> Style {
        var description = styleDescription
        description.set(value: color, forKey: .strokeColor)
        description.set(value: width, forKey: .strokeWidth)
        return Style(description)
    }

    /// This value indicates whether the text has a line through it.
    ///
    /// - Parameters:
    ///     - style: The style of the line (as `NSUnderLineStyle`).
    ///     - color: the style of the line (as `NSUnderLineStyle`)
    @discardableResult
    public func strikethroughStyle(_ style: NSUnderlineStyle?, color: Color?) -> Style {
        var description = styleDescription
        description.set(value: style?.rawValue, forKey: .strikethroughStyle)
        description.set(value: color, forKey: .strikethroughColor)
        return Style(description)
    }

    /// Floating point indicating the character’s offset from the baseline, in points.
    ///
    /// The default value is 0.
    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat?) -> Style {
        var description = styleDescription
        description.set(value: baselineOffset, forKey: .baselineOffset)
        return Style(description)
    }

    /// The distance in points between the bottom of one line fragment and the top of the next.
    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat?) -> Style {
        var description = styleDescription
        description.lineSpacing = lineSpacing
        return Style(description)
    }

    /// The distance between the paragraph’s top and the beginning of its text content.
    ///
    /// This property contains the space (measured in points) between the paragraph’s top
    /// and the beginning of its text content.
    ///
    /// The default value of this property is 0.0.
    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat?) -> Style {
        var description = styleDescription
        description.paragraphSpacingBefore = paragraphSpacingBefore
        return Style(description)
    }

    /// The space after the end of the paragraph.
    ///
    /// This property contains the space (measured in points) added at the end of the paragraph
    /// to separate it from the following paragraph.
    ///
    /// This value must be nonnegative.
    ///
    /// The space between paragraphs is determined by adding the previous paragraph’s `paragraphSpacing`
    /// and the current paragraph’s `paragraphSpacingBefore`.
    @discardableResult
    public func paragraphSpacingAfter(_ paragraphSpacing: CGFloat?) -> Style {
        var description = styleDescription
        description.paragraphSpacing = paragraphSpacing
        return Style(description)
    }

    /// The text alignment of the receiver.
    ///
    /// Default value is `natural`, depending by system's locale.
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment?) -> Style {
        var description = styleDescription
        description.alignment = alignment
        return Style(description)
    }

    /// The indentation of the first line of the receiver.
    ///
    /// This property contains the distance (in points) from the leading margin of a text container
    /// to the beginning of the paragraph’s first line.
    ///
    /// This value is always nonnegative.
    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat?) -> Style {
        var description = styleDescription
        description.firstLineHeadIndent = firstLineHeadIndent
        return Style(description)
    }

    /// The indentation of the receiver’s lines other than the first.
    ///
    /// This property contains the distance (in points) from the leading margin of a text container
    /// to the beginning of lines other than the first.
    ///
    /// This value is always nonnegative.
    @discardableResult
    public func headIndent(_ headIndent: CGFloat?) -> Style {
        var description = styleDescription
        description.headIndent = headIndent
        return Style(description)
    }

    /// The trailing indentation of the receiver.
    ///
    ///
    /// If positive, this value is the distance from the leading margin
    /// (for example, the left margin in left-to-right text).
    ///
    /// If 0 or negative, it’s the distance from the trailing margin.
    /// - Parameter tailIndent: The value of tail indent.
    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat?) -> Style {
        var description = styleDescription
        description.tailIndent = tailIndent
        return Style(description)
    }

    /// This property contains the line break mode to be used laying out the paragraph’s text.
    ///
    /// - Parameter lineBreakMode: The mode that should be used to break lines (as `NSLineBreakMode`).
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Style {
        var description = styleDescription
        description.lineBreakMode = lineBreakMode
        return Style(description)
    }

    /// The receiver’s minimum height.
    ///
    /// This property contains the minimum height in points that any line in the receiver will occupy,
    /// regardless of the font size or size of any attached graphic.
    ///
    /// This value must be nonnegative.
    /// - Parameter minimumLineHeight: The value of minimum line height.
    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat?) -> Style {
        var description = styleDescription
        description.minimumLineHeight = minimumLineHeight
        return Style(description)
    }

    /// The receiver’s maximum line height.
    ///
    /// This property contains the maximum height in points that any line in the receiver will occupy,
    /// regardless of the font size or size of any attached graphic.
    ///
    /// This value is always nonnegative.
    ///
    /// The default value is 0.
    ///
    /// - Parameter maximumLineHeight: The value of maximum line height.
    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat?) -> Style {
        var description = styleDescription
        description.maximumLineHeight = maximumLineHeight
        return Style(description)
    }

    /// The natural line height of the receiver is multiplied by this factor (if positive)
    /// before being constrained by minimum and maximum line height.
    ///
    ///  The default value of this property is 0.0.
    /// - Parameter lineHeightMultiple: The line height multiple.
    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat?) -> Style {
        var description = styleDescription
        description.lineHeightMultiple = lineHeightMultiple
        return Style(description)
    }

    /// Valid values lie between 0.0 and 1.0 inclusive.
    ///
    /// The default value is 0.0.
    /// Hyphenation is attempted when the ratio of the text width (as broken without hyphenation)
    /// to the width of the line fragment is less than the hyphenation factor.
    ///
    /// - Parameter hyphenation: The paragraph’s threshold for hyphenation.
    @discardableResult
    public func hyphenationFactor(_ hyphenationFactor: Float?) -> Style {
        var description = styleDescription
        description.hyphenationFactor = hyphenationFactor
        return Style(description)
    }

    /// The initial writing direction used to determine the actual writing direction for text.
    /// The default value of this property is `natural`.
    ///
    /// - Parameter baseWritingDirection: The base writing direction for the receiver.
    @discardableResult
    public func baseWritingDirection(_ baseWritingDirection: NSWritingDirection?) -> Style {
        var description = styleDescription
        description.baseWritingDirection = baseWritingDirection
        return Style(description)
    }

    /// The value of this attribute is an NSShadow object.
    ///
    /// The default value of this property is nil.
    @discardableResult
    public func shadow(_ shadow: NSShadow?) -> Style {
        var description = styleDescription
        description.set(value: shadow, forKey: .shadow)
        return Style(description)
    }

    /// The default value of this property is nil, indicating no link.
    ///
    /// - Parameter linkURL: The value of this attribute is an `URL` object.
    @discardableResult
    public func linkURL(_ linkURL: URL?) -> Style {
        var description = styleDescription
        description.set(value: linkURL, forKey: .link)
        return Style(description)
    }

    /// A ligature is a special character that combines two (or sometimes three) characters into a single character.
    ///
    /// The default value for this attribute is `defaults`. (Value `all` is unsupported on iOS.)
    /// - Parameter ligature: An enumeration representing the ligature to be applied.
    @discardableResult
    public func ligature(_ ligature: Ligature?) -> Style {
        var description = styleDescription
        description.set(value: (ligature ?? .disabled).rawValue, forKey: .ligature)
        return Style(description)
    }

    /// Tracking to apply.
    ///
    /// - Parameter tracking: An enumeration representing the tracking to be applied.
    @discardableResult
    public func tracking(_ tracking: Tracking?) -> Style {
        var description = styleDescription
        description.tracking = tracking
        return Style(description)
    }

    /// 显示数字时，数字是否会出现在 baseline 以下
    @discardableResult
    public func numberCase(_ numberCase: NumberCase?) -> Style {
        var description = styleDescription
        description.numberCase = numberCase
        return Style(description)
    }

    /// 显示数字时，数字字符是否等宽
    @discardableResult
    public func numberSpacing(_ numberSpacing: NumberSpacing?) -> Style {
        var description = styleDescription
        description.numberSpacing = numberSpacing
        return Style(description)
    }

    /// Configuration for displyaing a fraction.
    @discardableResult
    public func fractions(_ fractions: Fractions?) -> Style {
        var description = styleDescription
        description.fractions = fractions
        return Style(description)
    }

    /// Superscript (superior) glpyh variants are used, as in footnotes¹.
    @discardableResult
    public func superscript(isOn: Bool?) -> Style {
        var description = styleDescription
        description.superscript = isOn
        return Style(description)
    }

    /// Subscript (inferior) glyph variants are used: vₑ.
    @discardableResult
    public func `subscript`(isOn: Bool?) -> Style {
        var description = styleDescription
        description.subscript = isOn
        return Style(description)
    }

    /// Ordinal glyph variants are used, as in the common typesetting of 4th.
    @discardableResult
    public func ordinals(isOn: Bool?) -> Style {
        var description = styleDescription
        description.ordinals = isOn
        return Style(description)
    }

    /// Scientific inferior glyph variants are used: H₂O
    @discardableResult
    public func scientificInferiors(isOn: Bool?) -> Style {
        var description = styleDescription
        description.scientificInferiors = isOn
        return Style(description)
    }

    /// Configure small caps behavior.
    /// `fromUppercase` and `fromLowercase` can be combined: they are not mutually exclusive.
    @discardableResult
    public func smallCaps(_ smallCaps: Set<SmallCaps>?) -> Style {
        var description = styleDescription
        description.smallCaps = smallCaps
        return Style(description)
    }

    /// Different contextual alternates available for customizing a font.
    /// - Attention:
    ///   Only certain fonts support contextual alternates.
    @discardableResult
    public func contextualAlternates(_ contextualAlternates: ContextualAlternates?) -> Style {
        var description = styleDescription
        if let contextualAlternates = contextualAlternates {
            description.contextualAlternates = contextualAlternates
        } else {
            description.contextualAlternates = nil
        }
        return Style(description)
    }

    /// Different stylistic alternates available for customizing a font.
    @discardableResult
    public func stylisticAlternatives(_ stylisticAlternatives: StylisticAlternatives?) -> Style {
        var description = styleDescription
        if let stylisticAlternatives = stylisticAlternatives {
            description.stylisticAlternatives = stylisticAlternatives
        } else {
            description.stylisticAlternatives = nil
        }
        return Style(description)
    }

    /// Describe trait variants to apply to the font.
    @discardableResult
    public func emphasizeStyle(_ emphasizeStyle: EmphasizeStyle?) -> Style {
        var description = styleDescription
        if let emphasizeStyle = emphasizeStyle {
            if description.emphasizeStyle == nil {
                description.emphasizeStyle = emphasizeStyle
            } else {
                description.emphasizeStyle?.insert(emphasizeStyle)
            }
        } else {
            description.emphasizeStyle = nil
        }
        return Style(description)
    }

}
