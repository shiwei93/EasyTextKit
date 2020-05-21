//
//  CommonsAttributes.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import CoreGraphics
import Foundation

// MARK: - Typealias

#if os(OSX)
import AppKit

public typealias Color = NSColor
public typealias Image = NSImage
public typealias Font = NSFont

public typealias FontDescriptor = NSFontDescriptor
public typealias SymbolicTraits = NSFontDescriptor.SymbolicTraits
public typealias LineBreak = NSLineBreakMode

let FontDescriptorFeatureSettingsAttribute = NSFontDescriptor.AttributeName.featureSettings
let FontFeatureTypeIdentifierKey = NSFontDescriptor.FeatureKey.typeIdentifier
let FontFeatureSelectorIdentifierKey = NSFontDescriptor.FeatureKey.selectorIdentifier
#else
import UIKit

public typealias Color = UIColor
public typealias Image = UIImage
public typealias Font = UIFont

public typealias FontDescriptor = UIFontDescriptor
public typealias SymbolicTraits = UIFontDescriptor.SymbolicTraits
public typealias LineBreak = NSLineBreakMode

let FontDescriptorFeatureSettingsAttribute = UIFontDescriptor.AttributeName.featureSettings
let FontFeatureTypeIdentifierKey = UIFontDescriptor.FeatureKey.featureIdentifier
let FontFeatureSelectorIdentifierKey = UIFontDescriptor.FeatureKey.typeIdentifier
#endif

// MARK: - Tracking

/// An enumeration representing the tracking to be applied.
/// - point: point value
/// - abobe: adobe format point value,
///          designers working in Adobe Photoshop or Illustrator will be using the type panel’s tracking field,
///          which specifies values in thousandths of an em (a typographic unit of size).
public enum Tracking {

    case point(CGFloat)
    case adobe(CGFloat)

    func kerning(for font: Font?) -> CGFloat {
        switch self {
        case .point(let kernValue):
            return kernValue
        case .adobe(let adobeValue):
            guard let font = font else {
                debugPrint("字体传参为 nil, 返回 0")
                return 0
            }
            return font.pointSize * (adobeValue / 1000.0)
        }
    }

}

// MARK: - Ligature

/// A ligature is a special character that combines two (or sometimes three) characters into a single character.
///
/// - disabled: indicates no ligatures.
/// - default: indicates the use of the default ligatures
/// - all: indicates the use of all ligatures. (Supported only on OSX)
public enum Ligature: Int {
    case disabled = 0
    case `default`
    #if os(OSX)
    case all = 2
    #endif
}

// MARK: Font 

public protocol FontFeatureConstructor {
    func featureConstruct() -> [(type: Int, selector: Int)]
}

extension FontFeatureConstructor {
    func attributes() -> [[FontDescriptor.FeatureKey: Any]] {
        let constructs = featureConstruct()
        return constructs.map {
            [
                FontFeatureTypeIdentifierKey: $0.type,
                FontFeatureSelectorIdentifierKey: $0.selector,
            ]
        }
    }
}

// MARK: - NumberCase

/// Number Case is independent of Letter Case.
/// [Apple Document](https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type21)
///
/// - upper: Uppercase numbers, also known as "lining figures", are the same height
///          as uppercase letters, and they do not extend below the baseline.
/// - lower: Lowercase numbers, also known as "oldstyle figures", are similar in
///          size and visual weight to lowercase letters, allowing them to
///          blend in better in a block of text.
///          They may have descenders hich drop below the typographic baseline.
public enum NumberCase: FontFeatureConstructor {

    case upper
    case lower

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        let selector: Int
        if case .upper = self {
            selector = kUpperCaseNumbersSelector
        } else {
            selector = kLowerCaseNumbersSelector
        }
        return [(type: kNumberCaseType, selector: selector)]
    }
}

// MARK: - NumberSpacing

/// The Number Spacing feature type specifies a choice for the appearance of digits.
/// [Apple Document](https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type6)
///
/// - monospaced:   Monospaced numbers, each take up
///                 the same amount of horizontal space, meaning that different numbers
///                 will line up when arranged in columns.
/// - proportional: Proportionally spaced numbers, also known as "proprotional figures",
///                 are of variable width.
///                 This makes them look better in most cases, but they should be avoided
///                 when numbers need to line up in columns.
public enum NumberSpacing: FontFeatureConstructor {

    case monospaced
    case proportional

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        let selector: Int
        if case .monospaced = self {
            selector = kMonospacedNumbersSelector
        } else {
            selector = kProportionalNumbersSelector
        }
        return [(type: kNumberSpacingType, selector: selector)]
    }

}

// MARK: - Fractions

/// The Fractions feature type controls the selection and/or generation of fractions.
/// [Apple Document](https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type11)
///
/// - disabled: No fraction formatting.
/// - diagonal: Acts like the Vertical Fractions selector,
///             but fractions will be synthesized using superiors and inferiors
///             (or special-purpose numerator and denominator forms, if present in the font).
/// - vertical: Form vertical (pre-drawn) fractions present in the font.
public enum Fractions: FontFeatureConstructor {

    case disabled
    case diagonal
    case vertical

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        let selector: Int
        switch self {
        case .disabled: selector = kNoFractionsSelector
        case .diagonal: selector = kDiagonalFractionsSelector
        case .vertical: selector = kVerticalFractionsSelector
        }
        return [(type: kFractionsType, selector: selector)]
    }

}

// MARK: - VerticalPosition

/// A feature provider for changing the vertical position of characters
/// using predefined styles in the font, such as superscript and subscript.
/// [Apple Document](https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type10)
public enum VerticalPosition: FontFeatureConstructor {

    /// No vertical position adjustment is applied.
    case normal

    /// Superscript (superior) glpyh variants are used, as in footnotes¹.
    case superscript

    /// Subscript (inferior) glyph variants are used: vₑ.
    case `subscript`

    /// Ordinal glyph variants are used, as in the common typesetting of 4th.
    case ordinals

    /// Scientific inferior glyph variants are used: H₂O
    case scientificInferiors

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        let selector: Int
        switch self {
        case .normal: selector = kNormalPositionSelector
        case .superscript: selector = kSuperiorsSelector
        case .`subscript`: selector = kInferiorsSelector
        case .ordinals: selector = kOrdinalsSelector
        case .scientificInferiors: selector = kScientificInferiorsSelector
        }
        return [(type: kVerticalPositionType, selector: selector)]
    }

}

// MARK: - SmallCaps

/// Configure small caps behavior.
///
/// - disabled:      No small caps are used.
/// - fromUppercase: Uppercase letters in the source string are replaced with small caps.
///                  Lowercase letters remain unmodified.
/// - fromLowercase: Lowercase letters in the source string are replaced with small caps.
///                  Uppercase letters remain unmodified.
public enum SmallCaps: FontFeatureConstructor {

    case disabled
    case fromUppercase
    case fromLowercase

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        switch self {
        case .disabled:
            return [
                (type: kLowerCaseType, selector: kDefaultLowerCaseSelector),
                (type: kUpperCaseType, selector: kDefaultUpperCaseSelector),
            ]
        case .fromUppercase: return [(type: kUpperCaseType, selector: kUpperCaseSmallCapsSelector)]
        case .fromLowercase: return [(type: kLowerCaseType, selector: kLowerCaseSmallCapsSelector)]
        }
    }

}

// MARK: - EmphasizeStyle

/// Describe trait variants to apply to the font.
public struct EmphasizeStyle: OptionSet {

    public var rawValue: Int

    /// The font typestyle is italic
    public static let italic = EmphasizeStyle(rawValue: 1)

    /// The font typestyle is bold
    public static let bold = EmphasizeStyle(rawValue: 1 << 1)

    /// The font’s typestyle is expanded. Expanded and condensed traits are mutually exclusive.
    public static let expanded = EmphasizeStyle(rawValue: 1 << 2)

    /// The font’s typestyle is condensed. Expanded and condensed traits are mutually exclusive.
    public static let condensed = EmphasizeStyle(rawValue: 1 << 3)

    /// The monospace variant of the default typeface.
    public static let monoSpace = EmphasizeStyle(rawValue: 1 << 4)

    /// The font uses vertical glyph variants and metrics.
    public static let vertical = EmphasizeStyle(rawValue: 1 << 5)

    /// The font synthesizes appropriate attributes for user interface rendering, such as control titles, if necessary.
    public static let uiOptimized = EmphasizeStyle(rawValue: 1 << 6)

    /// The font uses tighter leading values.
    public static let tightLeading = EmphasizeStyle(rawValue: 1 << 7)

    /// The font uses looser leading values.
    public static let looseLeading = EmphasizeStyle(rawValue: 1 << 8)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}

// Convert!

extension EmphasizeStyle {

    var symbolicTraits: SymbolicTraits {
        var traits: SymbolicTraits = []
        #if os(tvOS) || os(iOS) || os(watchOS)
        if contains(.italic) {
            traits.insert(.traitItalic)
        }
        if contains(.bold) {
            traits.insert(.traitBold)
        }
        if contains(.expanded) {
            traits.insert(.traitExpanded)
        }
        if contains(.condensed) {
            traits.insert(.traitCondensed)
        }
        if contains(.monoSpace) {
            traits.insert(.traitMonoSpace)
        }
        if contains(.vertical) {
            traits.insert(.traitVertical)
        }
        if contains(.uiOptimized) {
            traits.insert(.traitUIOptimized)
        }
        if contains(.tightLeading) {
            traits.insert(.traitTightLeading)
        }
        if contains(.looseLeading) {
            traits.insert(.traitLooseLeading)
        }
        #else
        if contains(.italic) {
            traits.insert(.italic)
        }
        if contains(.bold) {
            traits.insert(.bold)
        }
        if contains(.expanded) {
            traits.insert(.expanded)
        }
        if contains(.condensed) {
            traits.insert(.condensed)
        }
        if contains(.monoSpace) {
            traits.insert(.monoSpace)
        }
        if contains(.vertical) {
            traits.insert(.vertical)
        }
        if contains(.uiOptimized) {
            traits.insert(.UIOptimized)
        }
        if contains(.tightLeading) {
            traits.insert(.tightLeading)
        }
        if contains(.looseLeading) {
            traits.insert(.looseLeading)
        }
        #endif
        return traits
    }

}

// MARK: - Contextual Alternates

/// Different contextual alternates available for customizing a font.
/// - Attention:
///   Only certain fonts support contextual alternates.
/// [Apple Document](https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type36)
public struct ContextualAlternates: OptionSet, FontFeatureConstructor {

    public var rawValue: Int

    public static let contextualAlternates = ContextualAlternates(rawValue: 1)
    public static let swashAlternates = ContextualAlternates(rawValue: 1 << 1)
    public static let contextualSwashAlternates = ContextualAlternates(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        var selector: [Int] = []
        selector.append(
            contains(.contextualAlternates) ? kContextualAlternatesOnSelector : kContextualAlternatesOffSelector
        )
        selector.append(
            contains(.swashAlternates) ? kSwashAlternatesOnSelector : kSwashAlternatesOffSelector
        )
        selector.append(
            contains(.contextualSwashAlternates) ?
                kContextualSwashAlternatesOnSelector : kContextualSwashAlternatesOffSelector
        )
        return selector.map {
            (type: kContextualAlternatesType, selector: $0)
        }
    }

}

// MARK: - Stylistic Alternatives

/// Different stylistic alternates available for customizing a font.
/// Typically, a font will support a small subset of these alternates, and
/// what they mean in a particular font is up to the font's creator.
public struct StylisticAlternatives: OptionSet, FontFeatureConstructor {

    public var rawValue: Int

    public static let one = StylisticAlternatives(rawValue: 1)
    public static let two = StylisticAlternatives(rawValue: 1 << 1)
    public static let three = StylisticAlternatives(rawValue: 1 << 2)
    public static let four = StylisticAlternatives(rawValue: 1 << 3)
    public static let five = StylisticAlternatives(rawValue: 1 << 4)
    public static let six = StylisticAlternatives(rawValue: 1 << 5)
    public static let seven = StylisticAlternatives(rawValue: 1 << 6)
    public static let eight = StylisticAlternatives(rawValue: 1 << 7)
    public static let nine = StylisticAlternatives(rawValue: 1 << 8)
    public static let ten = StylisticAlternatives(rawValue: 1 << 9)
    public static let eleven = StylisticAlternatives(rawValue: 1 << 10)
    public static let twelve = StylisticAlternatives(rawValue: 1 << 11)
    public static let thirteen = StylisticAlternatives(rawValue: 1 << 12)
    public static let fourteen = StylisticAlternatives(rawValue: 1 << 13)
    public static let fifteen = StylisticAlternatives(rawValue: 1 << 14)
    public static let sixteen = StylisticAlternatives(rawValue: 1 << 15)
    public static let seventeen = StylisticAlternatives(rawValue: 1 << 16)
    public static let eighteen = StylisticAlternatives(rawValue: 1 << 17)
    public static let nineteen = StylisticAlternatives(rawValue: 1 << 18)
    public static let twenty = StylisticAlternatives(rawValue: 1 << 19)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public func featureConstruct() -> [(type: Int, selector: Int)] {
        var selector: [Int] = []
        selector.append(contains(.one) ? kStylisticAltOneOnSelector : kStylisticAltOneOffSelector)
        selector.append(contains(.two) ? kStylisticAltTwoOnSelector : kStylisticAltTwoOffSelector)
        selector.append(contains(.three) ? kStylisticAltThreeOnSelector : kStylisticAltThreeOffSelector)
        selector.append(contains(.four) ? kStylisticAltFourOnSelector : kStylisticAltFourOffSelector)
        selector.append(contains(.five) ? kStylisticAltFiveOnSelector : kStylisticAltFiveOffSelector)
        selector.append(contains(.six) ? kStylisticAltSixOnSelector : kStylisticAltSixOffSelector)
        selector.append(contains(.seven) ? kStylisticAltSevenOnSelector : kStylisticAltSevenOffSelector)
        selector.append(contains(.eight) ? kStylisticAltEightOnSelector : kStylisticAltEightOffSelector)
        selector.append(contains(.nine) ? kStylisticAltNineOnSelector : kStylisticAltNineOffSelector)
        selector.append(contains(.ten) ? kStylisticAltTenOnSelector : kStylisticAltTenOffSelector)
        selector.append(contains(.eleven) ? kStylisticAltElevenOnSelector : kStylisticAltElevenOffSelector)
        selector.append(contains(.twelve) ? kStylisticAltTwelveOnSelector : kStylisticAltTwelveOffSelector)
        selector.append(contains(.thirteen) ? kStylisticAltThirteenOnSelector : kStylisticAltThirteenOffSelector)
        selector.append(contains(.fourteen) ? kStylisticAltFourteenOnSelector : kStylisticAltFourteenOffSelector)
        selector.append(contains(.fifteen) ? kStylisticAltFifteenOnSelector : kStylisticAltFifteenOffSelector)
        selector.append(contains(.sixteen) ? kStylisticAltSixteenOnSelector : kStylisticAltSixteenOffSelector)
        selector.append(contains(.seventeen) ? kStylisticAltSeventeenOnSelector : kStylisticAltSeventeenOffSelector)
        selector.append(contains(.eighteen) ? kStylisticAltEighteenOnSelector : kStylisticAltEighteenOffSelector)
        selector.append(contains(.nineteen) ? kStylisticAltNineteenOnSelector : kStylisticAltNineteenOffSelector)
        selector.append(contains(.twenty) ? kStylisticAltTwentyOnSelector : kStylisticAltTwentyOffSelector)
        return selector.map {
            (type: kStylisticAlternativesType, selector: $0)
        }
    }

}
