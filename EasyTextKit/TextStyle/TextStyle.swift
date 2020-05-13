//
// TextStyle.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

public class TextStyle: TextStyleProtocol {
    
    public var attributes: [NSAttributedString.Key: Any] {
        // 构建新的属性字典
        let attributes = constructAttributes()
        return innerAttributes.merging(attributes) { (_, new) in
            return new
        }
    }
    
    /// 动态字体，根据用户设置实现对字体大小的控制
    public var dynamicText: DynamicText?
    
    /// 文本字体
    public var font: UIFont? {
        set { set(value: newValue, forKey: .font) }
        get { get(attributeForKey: .font) }
    }
    
    /// 文本颜色
    public var foregroundColor: UIColor? {
        set { set(value: newValue, forKey: .foregroundColor) }
        get { get(attributeForKey: .foregroundColor) }
    }
    
    /// 文本背景色
    public var backgroudColor: UIColor? {
        set { set(value: newValue, forKey: .backgroundColor) }
        get { get(attributeForKey: .backgroundColor) }
    }
    
    /// 文本下划线样式
    public var underline: (style: NSUnderlineStyle?, color: UIColor?)? {
        set {
            set(value: newValue?.style?.rawValue, forKey: .underlineStyle)
            set(value: newValue?.color, forKey: .underlineColor)
        }
        get {
            let style: Int? = get(attributeForKey: .underlineStyle)
            let color: UIColor? = get(attributeForKey: .underlineColor)
            return (NSUnderlineStyle(rawValue: style ?? 0), color)
        }
    }
    
    /// 添加字符描边
    /// - Attention: width 值为正数时，不填充文字内部，只显示描边。
    /// 为负数时，显示描边也会填充内部
    public var stroke: (color: UIColor?, width: Float?)? {
        set {
            set(value: newValue?.color, forKey: .strokeColor)
            set(value: newValue?.width, forKey: .strokeWidth)
        }
        get {
            let color: UIColor? = get(attributeForKey: .strokeColor)
            let width: Float? = get(attributeForKey: .strokeWidth)
            return (color, width)
        }
    }
    
    /// 添加删除线
    public var strikethroughStyle: (style: NSUnderlineStyle?, color: UIColor?)? {
        set {
            set(value: newValue?.style?.rawValue, forKey: .strikethroughStyle)
            set(value: newValue?.color, forKey: .strikethroughColor)
        }
        get {
            let style: Int? = get(attributeForKey: .strikethroughStyle)
            let color: UIColor? = get(attributeForKey: .strikethroughColor)
            return (NSUnderlineStyle(rawValue: style ?? 0), color)
        }
    }
    
    public var baselineOffset: CGFloat? {
        set { set(value: newValue, forKey: .baselineOffset) }
        get { get(attributeForKey: .baselineOffset) }
    }
    
    // MARK: - Paragraph Style
    
    public var paragraph: NSMutableParagraphStyle? {
        set { set(value: newValue, forKey: .paragraphStyle) }
        get {
            if let paragraph: NSMutableParagraphStyle = get(attributeForKey: .paragraphStyle) {
                return paragraph
            }
            let paragraph = NSMutableParagraphStyle()
            set(value: paragraph, forKey: .paragraphStyle)
            return paragraph
        }
    }
    
    /// 行高
    public var lineSpacing: CGFloat? {
        set { paragraph?.lineSpacing = newValue ?? 0.0 }
        get { paragraph?.lineSpacing }
    }
    
    /// 段前间距
    public var paragraphSpacingBefore: CGFloat? {
        set { paragraph?.paragraphSpacingBefore = newValue ?? 0.0 }
        get { paragraph?.paragraphSpacingBefore }
    }
    
    /// 段(后)间距
    public var paragraphSpacing: CGFloat? {
        set { paragraph?.paragraphSpacing = newValue ?? 0.0 }
        get { paragraph?.paragraphSpacing }
    }
    
    /// 文本的对齐方式
    public var alignment: NSTextAlignment? {
        set { paragraph?.alignment = newValue ?? .natural }
        get { paragraph?.alignment }
    }
    
    /// 段落的首行缩进
    public var firstLineHeadIndent: CGFloat? {
        set { paragraph?.firstLineHeadIndent = newValue ?? 0.0 }
        get { paragraph?.firstLineHeadIndent }
    }
    
    /// 整段除了第一行之外的缩进，距离 leading
    public var headIndent: CGFloat? {
        set { paragraph?.headIndent = newValue ?? 0.0 }
        get { paragraph?.headIndent }
    }
    
    /// 值为正数时，代表了文本的宽度。
    /// 0 或负数时，表示段落文本距离 trailing 的距离
    public var tailIndent: CGFloat? {
        set { paragraph?.tailIndent = newValue ?? 0.0 }
        get { paragraph?.tailIndent }
    }
    
    /// 文本的截断模式
    public var lineBreakMode: NSLineBreakMode? {
        set { paragraph?.lineBreakMode = newValue ?? .byWordWrapping }
        get { paragraph?.lineBreakMode }
    }
    
    /// 最小行高
    public var minimumLineHeight: CGFloat? {
        set { paragraph?.minimumLineHeight = newValue ?? 0.0 }
        get { paragraph?.minimumLineHeight }
    }
    
    /// 最大行高
    public var maximumLineHeight: CGFloat? {
        set { paragraph?.maximumLineHeight = newValue ?? 0.0 }
        get { paragraph?.maximumLineHeight }
    }
    
    /// 行高 = 原始行高 * 该倍数，受制于最大和最小行高的值
    public var lineHeightMultiple: CGFloat? {
        set { paragraph?.lineHeightMultiple = newValue ?? 0.0 }
        get { paragraph?.lineHeightMultiple }
    }
    
    /// 英文自动断词
    ///
    /// - Attention: 设置的值为 0 或 1，0 为关闭自动断词，1 为开启
    public var hyphenation: Hyphenation? {
        set { paragraph?.hyphenationFactor = newValue?.rawValue ?? 0.0 }
        get {
            let factor = paragraph?.hyphenationFactor
            return factor == 1.0 ? .default : .disabled
        }
    }
    
    /// 书写方向
    ///
    /// 默认值为 `NSWritingDirection.natural`
    public var baseWritingDirection: NSWritingDirection? {
        set { paragraph?.baseWritingDirection = newValue ?? .natural }
        get { paragraph?.baseWritingDirection }
    }
    // MARK: _
    
    /// 文本阴影
    public var shadow: NSShadow? {
        set { set(value: newValue, forKey: .shadow) }
        get { get(attributeForKey: .shadow) }
    }
    
    /// 链接
    public var linkURL: URL? {
        set { set(value: newValue, forKey: .link) }
        get { get(attributeForKey: .link) }
    }
    
    /// 是否支持连字
    public var ligature: Ligature? {
        set { set(value: newValue?.rawValue, forKey: .ligature) }
        get {
            if let ligature: Int = get(attributeForKey: .ligature) {
                return Ligature(rawValue: ligature)
            }
            return nil
        }
    }
    
    /// 字间距
    public var tracking: Tracking?
    
    // MARK: - Font UIFontDescriptor
    
    /// 显示数字时，数字是否会出现在 baseline 以下
    public var numberCase: NumberCase?
    
    /// 显示数字时，数字字符是否等宽
    public var numberSpacing: NumberSpacing?
    
    /// 显示分数时样式
    public var fractions: Fractions?
    
    /// 上确界 script¹
    public var superscript: Bool?
    
    /// 下确界 vₑ
    public var `subscript`: Bool?
    
    /// 根据上下文与语言特性，修改某些字符为特定形式，例如西班牙语中从1a更改为1ª。
    public var ordinals: Bool?
    
    /// 科学定义的符号，如化学元素表示
    public var scientificInferiors: Bool?
    
    /// 字形修改，实现类似 iPhone XR R 大写但比 X 小的效果
    /// 即保持字符大小写样式，又控制其高度为 xHeight
    public var smallCaps: Set<SmallCaps> = []
    
    /// 字体的特殊样式，例如斜体/加粗等
    public var emphasizeStyle: EmphasizeStyle?
    
    private var innerAttributes: [NSAttributedString.Key: Any] = [:]
    
    public init(_ handler: ((TextStyle) -> Void)? = nil) {
        handler?(self)
    }
    
    init(attributes: [NSAttributedString.Key: Any]) {
        self.innerAttributes = attributes
    }
    
    init(style: TextStyle) {
        self.innerAttributes = style.innerAttributes
    }
    
    public func adding(_ handler: (TextStyle) -> Void) -> TextStyle {
        let style = TextStyle(style: self)
        style.paragraph = paragraph?.paragraphCopy()
        handler(style)
        return style
    }
    
    func merge(_ parent: TextStyle) -> StyleProtocol {
        let style = TextStyle()
        style.font = font ?? parent.font
        style.foregroundColor = foregroundColor ?? parent.foregroundColor
        style.backgroudColor = backgroudColor ?? parent.backgroudColor
        style.underline = underline ?? parent.underline
        style.stroke = stroke ?? parent.stroke
        style.strikethroughStyle = strikethroughStyle ?? parent.strikethroughStyle
        style.baselineOffset = baselineOffset ?? parent.baselineOffset
        style.shadow = shadow ?? parent.shadow
        style.linkURL = linkURL ?? parent.linkURL
        style.ligature = ligature ?? parent.ligature
        style.tracking = tracking ?? parent.tracking
        style.numberCase = numberCase ?? parent.numberCase
        style.numberSpacing = numberSpacing ?? parent.numberSpacing
        style.fractions = fractions ?? parent.fractions
        style.superscript = superscript ?? parent.superscript
        style.`subscript` = `subscript` ?? parent.subscript
        style.ordinals = ordinals ?? parent.ordinals
        style.scientificInferiors = scientificInferiors ?? parent.scientificInferiors
        style.emphasizeStyle = emphasizeStyle?.union(parent.emphasizeStyle ?? [])
        style.smallCaps = smallCaps.union(parent.smallCaps)
        style.lineSpacing = lineSpacing ?? parent.lineSpacing
        style.paragraphSpacingBefore = paragraphSpacingBefore ?? parent.paragraphSpacingBefore
        style.paragraphSpacing = paragraphSpacing ?? parent.paragraphSpacing
        style.alignment = alignment ?? parent.alignment
        style.firstLineHeadIndent = firstLineHeadIndent ?? parent.firstLineHeadIndent
        style.headIndent = firstLineHeadIndent ?? parent.firstLineHeadIndent
        style.tailIndent = firstLineHeadIndent ?? parent.firstLineHeadIndent
        style.lineBreakMode = lineBreakMode ?? parent.lineBreakMode
        style.minimumLineHeight = minimumLineHeight ?? parent.minimumLineHeight
        style.maximumLineHeight = maximumLineHeight ?? parent.maximumLineHeight
        style.lineHeightMultiple = lineHeightMultiple ?? parent.lineHeightMultiple
        style.hyphenation = hyphenation ?? parent.hyphenation
        style.baseWritingDirection = baseWritingDirection ?? parent.baseWritingDirection
        return style
    }
    
}

extension TextStyle {
    
    func set<T>(value: T?, forKey key: NSAttributedString.Key) {
        guard let value = value else {
            innerAttributes.removeValue(forKey: key)
            return
        }
        innerAttributes[key] = value
    }
    
    func get<T>(attributeForKey key: NSAttributedString.Key) -> T? {
        return innerAttributes[key] as? T
    }
    
    private func constructAttributes() -> [NSAttributedString.Key: Any] {
        var extraAttributes: [NSAttributedString.Key: Any] = [:]
    
        var originalFont: UIFont = (innerAttributes[.font] as? UIFont) ?? UIFont.systemFont(
            ofSize: UIFont.systemFontSize
        )
        
        // UIFontDescriptor 处理，初始化新的 font
        var fontFeatureConstructs: [FontFeatureConstructor] = []
        fontFeatureConstructs += [numberCase].compactMap { $0 }
        fontFeatureConstructs += [numberSpacing].compactMap { $0 }
        fontFeatureConstructs += [fractions].compactMap { $0 }
        fontFeatureConstructs += [superscript].compactMap { $0 }
            .map { $0 ? VerticalPosition.superscript : VerticalPosition.normal }
        fontFeatureConstructs += [`subscript`].compactMap { $0 }
            .map { $0 ? VerticalPosition.subscript : VerticalPosition.normal }
        fontFeatureConstructs += [ordinals].compactMap { $0 }
            .map { $0 ? VerticalPosition.ordinals : VerticalPosition.normal }
        fontFeatureConstructs += [scientificInferiors].compactMap { $0 }
            .map { $0 ? VerticalPosition.scientificInferiors : VerticalPosition.normal }
        fontFeatureConstructs += smallCaps.map { $0 }
        
        let newFontFeatures = fontFeatureConstructs.flatMap { $0.attributes() }
        
        if !newFontFeatures.isEmpty {
            let descriptor = originalFont.fontDescriptor.addingAttributes([
                UIFontDescriptor.AttributeName.featureSettings: newFontFeatures
            ])
            
            originalFont = UIFont(descriptor: descriptor, size: originalFont.pointSize)
        }
        
        // SymbolicTraits 设置
        if let emphasis = emphasizeStyle {
            let descriptor = originalFont.fontDescriptor
            let existingTraits = descriptor.symbolicTraits
            let newTraits = existingTraits.union(emphasis.symbolicTraits)
            
            let newDescriptor = descriptor.withSymbolicTraits(newTraits)
            if let descriptor = newDescriptor {
                originalFont = UIFont(descriptor: descriptor, size: originalFont.pointSize)
            }
        }
        
        if #available(iOS 11.0, *), dynamicText != nil {
            extraAttributes[.font] = scalable(font: originalFont)
        } else {
            extraAttributes[.font] = originalFont
        }

        // 字间距
        if let tracking = tracking {
            extraAttributes[.kern] = tracking.kerning(for: originalFont)
        }
        
        return extraAttributes
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
    
}
