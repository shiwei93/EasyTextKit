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
        self.styleDescription = StyleDescription(
            attributes: attributes,
            paragraphStyle: paragraphStyle
        )
    }
    
    public init(_ style: Style? = nil) {
        self.styleDescription = style?.styleDescription.copy() ?? StyleDescription()
    }
    
    init(_ styleDescription: StyleDescription) {
        self.styleDescription = styleDescription
    }
    
    /// 动态字体，根据用户设置实现对字体大小的控制
    @discardableResult @available(iOS 11.0, *)
    public func dynamicText(_ dynamicText: DynamicText) -> Style {
        styleDescription.dynamicText = dynamicText
        return self
    }
    
    /// 文本字体
    @discardableResult
    public func font(_ font: UIFont) -> Style {
        styleDescription.set(value: font, forKey: .font)
        return self
    }
    
    /// 文本颜色
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Style {
        styleDescription.set(value: color, forKey: .foregroundColor)
        return self
    }
    
    /// 文本背景色
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Style {
        styleDescription.set(value: color, forKey: .backgroundColor)
        return self
    }
    
    /// 文本下划线样式
    @discardableResult
    public func underline(_ style: NSUnderlineStyle, color: UIColor) -> Style {
        styleDescription.set(value: style, forKey: .underlineStyle)
        styleDescription.set(value: color, forKey: .underlineColor)
        return self
    }
    
    /// 添加字符描边
    /// - Attention: width 值为正数时，不填充文字内部，只显示描边。
    /// 为负数时，显示描边也会填充内部
    @discardableResult
    public func stroke(_ color: UIColor, width: CGFloat) -> Style {
        styleDescription.set(value: color, forKey: .strokeColor)
        styleDescription.set(value: width, forKey: .strokeWidth)
        return self
    }
    
    /// 添加删除线
    @discardableResult
    public func strikethroughStyle(_ style: NSUnderlineStyle, color: UIColor) -> Style {
        styleDescription.set(value: style, forKey: .strikethroughStyle)
        styleDescription.set(value: color, forKey: .strikethroughColor)
        return self
    }

    /// 距离字体 baseline 的偏移值
    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> Style {
        styleDescription.set(value: baselineOffset, forKey: .baselineOffset)
        return self
    }
    
    /// 行间距
    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat) -> Style {
        styleDescription.lineSpacing = lineSpacing
        return self
    }
    
    /// 段前间距
    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Style {
        styleDescription.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
    
    /// 段(后)间距
    @discardableResult
    public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Style {
        styleDescription.paragraphSpacing = paragraphSpacing
        return self
    }
    
    /// 文本的对齐方式
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Style {
        styleDescription.alignment = alignment
        return self
    }
    
    /// 段落的首行缩进
    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Style {
        self.styleDescription.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    /// 整段除了第一行之外的缩进，距离 leading
    @discardableResult
    public func headIndent(_ headIndent: CGFloat) -> Style {
        styleDescription.headIndent = headIndent
        return self
    }
    
    /// 值为正数时，代表了文本的宽度。
    /// 0 或负数时，表示段落文本距离 trailing 的距离
    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat) -> Style {
        styleDescription.tailIndent = tailIndent
        return self
    }
    
    /// 文本的截断模式
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Style {
        styleDescription.lineBreakMode = lineBreakMode
        return self
    }
    
    /// 最小行高
    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat) -> Style {
        styleDescription.minimumLineHeight = minimumLineHeight
        return self
    }
    
    /// 最大行高
    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat) -> Style {
        styleDescription.maximumLineHeight = maximumLineHeight
        return self
    }
    
    /// 行高 = 原始行高 * 该倍数，受制于最大和最小行高的值
    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> Style {
        styleDescription.lineHeightMultiple = lineHeightMultiple
        return self
    }
    
    /// 英文自动断词
    ///
    /// - Attention: 设置的值为 0 或 1，0 为关闭自动断词，1 为开启
    @discardableResult
    public func hyphenation(_ hyphenation: Hyphenation) -> Style {
        styleDescription.hyphenation = hyphenation
        return self
    }
    
    /// 书写方向
    ///
    /// 默认值为 `NSWritingDirection.natural`
    @discardableResult
    public func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> Style {
        styleDescription.baseWritingDirection = baseWritingDirection
        return self
    }
    
    /// 文本阴影
    @discardableResult
    public func shadow(_ shadow: NSShadow) -> Style {
        styleDescription.set(value: shadow, forKey: .shadow)
        return self
    }
    
    /// 链接
    @discardableResult
    public func linkURL(_ linkURL: URL) -> Style {
        styleDescription.set(value: linkURL, forKey: .link)
        return self
    }
    
    /// 是否支持连字
    @discardableResult
    public func ligature(_ ligature: Ligature) -> Style {
        styleDescription.set(value: ligature.rawValue, forKey: .ligature)
        return self
    }
    
    /// 字间距
    @discardableResult
    public func tracking(_ tracking: Tracking) -> Style {
        styleDescription.tracking = tracking
        return self
    }
    
    /// 显示数字时，数字是否会出现在 baseline 以下
    @discardableResult
    public func numberCase(_ numberCase: NumberCase) -> Style {
        styleDescription.numberCase = numberCase
        return self
    }
    
    /// 显示数字时，数字字符是否等宽
    @discardableResult
    public func numberSpacing(_ numberSpacing: NumberSpacing) -> Style {
        styleDescription.numberSpacing = numberSpacing
        return self
    }
    
    /// 显示分数时样式
    @discardableResult
    public func fractions(_ fractions: Fractions) -> Style {
        styleDescription.fractions = fractions
        return self
    }
    
    /// 上确界 script¹
    @discardableResult
    public func superscript(isOn: Bool) -> Style {
        styleDescription.superscript = isOn
        return self
    }
    
    /// 下确界 vₑ
    @discardableResult
    public func `subscript`(isOn: Bool) -> Style {
        styleDescription.subscript = isOn
        return self
    }
    
    /// 根据上下文与语言特性，修改某些字符为特定形式，例如西班牙语中从1a更改为1ª。
    @discardableResult
    public func ordinals(isOn: Bool) -> Style {
        styleDescription.ordinals = isOn
        return self
    }
    
    /// 科学定义的符号，如化学元素表示
    @discardableResult
    public func scientificInferiors(isOn: Bool) -> Style {
        styleDescription.scientificInferiors = isOn
        return self
    }
    
    /// 字形修改，实现类似 iPhone XR R 大写但比 X 小的效果
    /// 即保持字符大小写样式，又控制其高度为 xHeight
    @discardableResult
    public func smallCaps(_ smallCaps: Set<SmallCaps>) -> Style {
        self.styleDescription.smallCaps = smallCaps
        return self
    }
    
    /// 字体的特殊样式，例如斜体/加粗等
    @discardableResult
    public func emphasizeStyle(_ emphasizeStyle: EmphasizeStyle) -> Style {
        self.styleDescription.emphasizeStyle = emphasizeStyle
        return self
    }
    
}
