//
//  CommonsAttributes.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

/// 字间距枚举
public enum Tracking {
    
    case point(CGFloat)
    case adobe(CGFloat)
    
    func kerning(for font: UIFont?) -> CGFloat {
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

/// 连字，某些字体在特殊字符组合时会有连笔的样式
public enum Ligature: Int {
    case disabled = 0
    case `default`
}

/// 英文自动断词
public enum Hyphenation: Float {
    case disabled = 0.0
    case `default` = 1.0
}

// MARK: Font 

public protocol FontFeatureConstructor {
    func featureConstruct() -> [(type: Int, selector: Int)]
}

extension FontFeatureConstructor {
    func attributes() -> [[UIFontDescriptor.FeatureKey: Any]] {
        let constructs = featureConstruct()
        return constructs.map {
            [
                UIFontDescriptor.FeatureKey.featureIdentifier: $0.type,
                UIFontDescriptor.FeatureKey.typeIdentifier: $0.selector
            ]
        }
    }
}

/// Number Case is independent of Letter Case.
/// https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type21
public enum NumberCase: FontFeatureConstructor {
    
    /// These forms of numbers do not descend below the baseline.
    /// They are sometimes known as "lining" numbers.
    /// 数字不会出现在 baseline 以下
    case upper
    
    /// These forms of numbers may descend below the baseline.
    /// They are sometimes known as "traditional" or "old-style" numbers.
    /// 数字出现在 baseline 以下
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

/// https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type6
/// 数字样式
public enum NumberSpacing: FontFeatureConstructor {
    
    /// 数字等宽
    case monospaced
    
    /// 数字宽度不同
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

/// https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type11
/// 分数的样式
public enum Fractions: FontFeatureConstructor {
    
    /// 不使用格式化，分子分母和 / 都在一行
    case disabled
    
    /// 分子略高，分母略低
    case diagonal
    
    /// 竖向的分数布局
    /// 需要字体中有绘制好的垂直分数，才生效
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

/// https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html#Type10
public enum VerticalPosition: FontFeatureConstructor {
    
    /// 常规文本显示
    case normal
    
    /// 上确界 script¹
    case superscript
    
    /// 下确界 vₑ
    case `subscript`
    
    /// 根据上下文，将某些字母更改为它们的高级形式，例如西班牙语中从1a更改为1ª。
    case ordinals
    
    /// 例如化学符号
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

public enum SmallCaps: FontFeatureConstructor {
    
    case disabled
    
    /// 将大写的字形显示为小写
    /// 即 iPhone XR 在官网中的样式，R 大写，但字形略小
    case fromUppercase
    
    /// 将小写的字形显示为小写
    case fromLowercase
    
    public func featureConstruct() -> [(type: Int, selector: Int)] {
        switch self {
        case .disabled:
            return [
                (type: kLowerCaseType, selector: kDefaultLowerCaseSelector),
                (type: kUpperCaseType, selector: kDefaultUpperCaseSelector)
            ]
        case .fromUppercase: return [(type: kUpperCaseType, selector: kUpperCaseSmallCapsSelector)]
        case .fromLowercase: return [(type: kLowerCaseType, selector: kLowerCaseSmallCapsSelector)]
        }
    }
    
}

public typealias SymbolicTraits = UIFontDescriptor.SymbolicTraits

/// 字体的特殊样式
/// 例如: 斜体/粗体/
public struct EmphasizeStyle: OptionSet {
    
    public var rawValue: Int
    
    /// 斜体
    public static let italic = EmphasizeStyle(rawValue: 1)
    
    /// 加粗
    public static let bold = EmphasizeStyle(rawValue: 1 << 1)
    
    /// 扩展，适当拉伸
    public static let expanded = EmphasizeStyle(rawValue: 1 << 2)
    
    /// 压缩，适当拉伸
    public static let condensed = EmphasizeStyle(rawValue: 1 << 3)
    
    /// 等宽，需要字体提供两种空格样式 (普通空格以及等宽填充空格)
    public static let monoSpace = EmphasizeStyle(rawValue: 1 << 4)
    
    ///
    public static let vertical = EmphasizeStyle(rawValue: 1 << 5)
    
    ///
    public static let uiOptimized = EmphasizeStyle(rawValue: 1 << 6)
    
    ///
    public static let tightLeading = EmphasizeStyle(rawValue: 1 << 7)
    
    ///
    public static let looseLeading = EmphasizeStyle(rawValue: 1 << 8)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}

extension EmphasizeStyle {
    
    var symbolicTraits: SymbolicTraits {
        var traits: SymbolicTraits = []
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
        return traits
    }
    
}
