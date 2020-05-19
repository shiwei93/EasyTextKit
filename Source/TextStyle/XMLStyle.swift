//
//  XMLStyle.swift
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

public class XMLStyle: StyleProtocol {

    /// This struct modified when you set style.
    public var styleDescription: StyleDescription

    private(set) var styles: [String: StyleProtocol]

    var base: StyleProtocol?

    /// XMLParser options
    var parsingOptions: ParsingOptions = []

    /// Initialize a new `XMLStyle`.
    ///
    /// - Parameters:
    ///   - base:
    ///   - styles:
    ///   - options:
    public init(
        base: StyleProtocol? = nil,
        _ styles: [String: StyleProtocol] = [:],
        options: ParsingOptions = []
    ) {
        self.styleDescription = StyleDescription(attributes: [:])
        self.styles = styles
        self.base = base
        self.parsingOptions = options
    }

    /// Set current style in the string over the specified range.
    ///
    /// - Parameters:
    ///   - source: The string to be seted.
    ///   - range: The range to operate over.
    /// - Returns: attributed string.
    public func set(to source: String, range: NSRange?) -> AttributedString {
        let attributed = AttributedString(string: source)
        return apply(to: attributed, range: range)
    }

    /// Set current style in the attributed string over the specified range.
    ///
    /// - Parameters:
    ///   - source: The attributed string to be seted.
    ///   - range: The range to operate over.
    /// - Returns: attributed string.
    public func set(to source: AttributedString, range: NSRange?) -> AttributedString {
        return apply(to: source, range: range)
    }

    private func apply(to attributed: AttributedString, range: NSRange?) -> AttributedString {
        do {
            let parser = Parser(xmlStyle: self, string: attributed.string)
            return try parser.parse()
        } catch {
            debugPrint("xml string 转换失败: \(error)")
            return attributed
        }
    }

}
