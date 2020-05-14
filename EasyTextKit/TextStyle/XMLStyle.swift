//
//  XMLStyle.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

public class XMLStyle: StyleProtocol {
    
    public var styleDescription: StyleDescription
    
    public private(set) var styles: [String: StyleProtocol]
    
    ///
    public var base: StyleProtocol?
    
    var parsingOptions: ParsingOptions = []
    
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
    
    public func set(to source: String, range: NSRange?) -> AttributedString {
        let attributed = AttributedString(string: source)
        return apply(to: attributed, range: range)
    }
    
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
