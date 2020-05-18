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

public struct Style: StyleProtocol {
    
    public private(set) var styleDescription: StyleDescription
    
    public init(_ attributes: [NSAttributedString.Key: Any] = [:]) {
        self.styleDescription = StyleDescription(attributes: attributes)
    }
    
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
    
    /// 文本字体
    @discardableResult
    public func font(_ font: Font?) -> Style {
        var description = styleDescription
        description.set(value: font, forKey: .font)
        return Style(description)
    }
    
    /// 文本颜色
    @discardableResult
    public func foregroundColor(_ color: Color?) -> Style {
        var description = styleDescription
        description.set(value: color, forKey: .foregroundColor)
        return Style(description)
    }
    
    /// 文本背景色
    @discardableResult
    public func backgroundColor(_ color: Color?) -> Style {
        var description = styleDescription
        description.set(value: color, forKey: .backgroundColor)
        return Style(description)
    }
    
    /// 文本下划线样式
    @discardableResult
    public func underline(_ style: NSUnderlineStyle?, color: Color?) -> Style {
        var description = styleDescription
        description.set(value: style?.rawValue, forKey: .underlineStyle)
        description.set(value: color, forKey: .underlineColor)
        return Style(description)
    }
    
    /// 添加字符描边
    /// - Attention: width 值为正数时，不填充文字内部，只显示描边。
    /// 为负数时，显示描边也会填充内部
    @discardableResult
    public func stroke(_ color: Color?, width: CGFloat?) -> Style {
        var description = styleDescription
        description.set(value: color, forKey: .strokeColor)
        description.set(value: width, forKey: .strokeWidth)
        return Style(description)
    }
    
    /// 添加删除线
    @discardableResult
    public func strikethroughStyle(_ style: NSUnderlineStyle?, color: Color?) -> Style {
        var description = styleDescription
        description.set(value: style?.rawValue, forKey: .strikethroughStyle)
        description.set(value: color, forKey: .strikethroughColor)
        return Style(description)
    }

    /// 距离字体 baseline 的偏移值
    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat?) -> Style {
        var description = styleDescription
        description.set(value: baselineOffset, forKey: .baselineOffset)
        return Style(description)
    }
    
    /// 行间距
    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat?) -> Style {
        var description = styleDescription
        description.lineSpacing = lineSpacing
        return Style(description)
    }
    
    /// 段前间距
    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat?) -> Style {
        var description = styleDescription
        description.paragraphSpacingBefore = paragraphSpacingBefore
        return Style(description)
    }
    
    /// 段(后)间距
    @discardableResult
    public func paragraphSpacingAfter(_ paragraphSpacing: CGFloat?) -> Style {
        var description = styleDescription
        description.paragraphSpacing = paragraphSpacing
        return Style(description)
    }
    
    /// 文本的对齐方式
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment?) -> Style {
        var description = styleDescription
        description.alignment = alignment
        return Style(description)
    }
    
    /// 段落的首行缩进
    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat?) -> Style {
        var description = styleDescription
        description.firstLineHeadIndent = firstLineHeadIndent
        return Style(description)
    }
    
    /// 整段除了第一行之外的缩进，距离 leading
    @discardableResult
    public func headIndent(_ headIndent: CGFloat?) -> Style {
        var description = styleDescription
        description.headIndent = headIndent
        return Style(description)
    }
    
    /// 值为正数时，代表了文本的宽度。
    /// 0 或负数时，表示段落文本距离 trailing 的距离
    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat?) -> Style {
        var description = styleDescription
        description.tailIndent = tailIndent
        return Style(description)
    }
    
    /// 文本的截断模式
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Style {
        var description = styleDescription
        description.lineBreakMode = lineBreakMode
        return Style(description)
    }
    
    /// 最小行高
    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat?) -> Style {
        var description = styleDescription
        description.minimumLineHeight = minimumLineHeight
        return Style(description)
    }
    
    /// 最大行高
    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat?) -> Style {
        var description = styleDescription
        description.maximumLineHeight = maximumLineHeight
        return Style(description)
    }
    
    /// 行高 = 原始行高 * 该倍数，受制于最大和最小行高的值
    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat?) -> Style {
        var description = styleDescription
        description.lineHeightMultiple = lineHeightMultiple
        return Style(description)
    }
    
    /// 英文自动断词
    ///
    /// - Attention: 设置的值为 0 或 1，0 为关闭自动断词，1 为开启
    @discardableResult
    public func hyphenation(_ hyphenation: Hyphenation?) -> Style {
        var description = styleDescription
        description.hyphenation = hyphenation
        return Style(description)
    }
    
    /// 书写方向
    ///
    /// 默认值为 `NSWritingDirection.natural`
    @discardableResult
    public func baseWritingDirection(_ baseWritingDirection: NSWritingDirection?) -> Style {
        var description = styleDescription
        description.baseWritingDirection = baseWritingDirection
        return Style(description)
    }
    
    /// 文本阴影
    @discardableResult
    public func shadow(_ shadow: NSShadow?) -> Style {
        var description = styleDescription
        description.set(value: shadow, forKey: .shadow)
        return Style(description)
    }
    
    /// 链接
    @discardableResult
    public func linkURL(_ linkURL: URL?) -> Style {
        var description = styleDescription
        description.set(value: linkURL, forKey: .link)
        return Style(description)
    }
    
    /// 是否支持连字
    @discardableResult
    public func ligature(_ ligature: Ligature?) -> Style {
        var description = styleDescription
        description.set(value: (ligature ?? .disabled).rawValue, forKey: .ligature)
        return Style(description)
    }
    
    /// 字间距
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
    
    /// 显示分数时样式
    @discardableResult
    public func fractions(_ fractions: Fractions?) -> Style {
        var description = styleDescription
        description.fractions = fractions
        return Style(description)
    }
    
    /// 上确界 script¹
    @discardableResult
    public func superscript(isOn: Bool?) -> Style {
        var description = styleDescription
        description.superscript = isOn
        return Style(description)
    }
    
    /// 下确界 vₑ
    @discardableResult
    public func `subscript`(isOn: Bool?) -> Style {
        var description = styleDescription
        description.subscript = isOn
        return Style(description)
    }
    
    /// 根据上下文与语言特性，修改某些字符为特定形式，例如西班牙语中从1a更改为1ª。
    @discardableResult
    public func ordinals(isOn: Bool?) -> Style {
        var description = styleDescription
        description.ordinals = isOn
        return Style(description)
    }
    
    /// 科学定义的符号，如化学元素表示
    @discardableResult
    public func scientificInferiors(isOn: Bool?) -> Style {
        var description = styleDescription
        description.scientificInferiors = isOn
        return Style(description)
    }
    
    /// 字形修改，实现类似 iPhone XR R 大写但比 X 小的效果
    /// 即保持字符大小写样式，又控制其高度为 xHeight
    @discardableResult
    public func smallCaps(_ smallCaps: Set<SmallCaps>?) -> Style {
        var description = styleDescription
        if let smallCaps = smallCaps {
            if description.smallCaps == nil {
                description.smallCaps = smallCaps
            } else {
                description.smallCaps?.formUnion(smallCaps)
            }
        } else {
            description.smallCaps = nil
        }
        return Style(description)
    }
    
    /// 字体的特殊样式，例如斜体/加粗等
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
