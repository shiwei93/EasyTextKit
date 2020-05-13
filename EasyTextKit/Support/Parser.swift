//
//  Parser.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ParserError

public struct ParserError: Error {
    public let parserError: Error
    public let line: Int
    public let column: Int
}

// MARK: - ParsingOptions

public struct ParsingOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// 如果使用了该 option 就需要在 xml 最外层带上自己的自定义 tag
    /// 默认会添加 "source" tag，但如果对于特别特别长的文本，建议自己定义根 tag
    public static let doNotWrapXML = ParsingOptions(rawValue: 1)
}

// MARK: - Parser

class Parser: NSObject, XMLParserDelegate {
    
    private static let topTag = "source"
    
    private var xmlParser: XMLParser
    
    private var options: ParsingOptions {
        return styleGroup.parsingOptions
    }
    
    private var attributedString: AttributedString
    
    private var base: TextStyleProtocol? {
        return styleGroup.base
    }
    
    private var styles: [String: StyleProtocol] {
        return styleGroup.styles
    }
    
    private var xmlDynamicStyles: [XMLDynamicStyle] = []
    
    var currentString: String?
    
    private weak var styleGroup: XMLTextStyle!
    
    init(styleGroup: XMLTextStyle, string: String) {
        self.styleGroup = styleGroup
        let options = styleGroup.parsingOptions
        let xml = options.contains(.doNotWrapXML) ? string : "<\(Parser.topTag)>\(string)</\(Parser.topTag)>"
        guard let data = xml.data(using: .utf8) else {
            fatalError("无法转换为 utf8.")
        }
        
        self.attributedString = AttributedString()
        self.xmlParser = XMLParser(data: data)
        
        if let base = styleGroup.base { // 带有默认 root tag
            self.xmlDynamicStyles = [
                XMLDynamicStyle(
                    tag: Parser.topTag,
                    style: base
                )
            ]
        }
        
        super.init()
        
        xmlParser.shouldProcessNamespaces = false
        xmlParser.shouldReportNamespacePrefixes = false
        xmlParser.shouldResolveExternalEntities = false
        xmlParser.delegate = self
    }
    
    func parse() throws -> AttributedString {
        guard xmlParser.parse() else {
            let line = xmlParser.lineNumber
            let shiftColumn = line == 1 && options.contains(.doNotWrapXML) == false
            let shiftSize = Parser.topTag.lengthOfBytes(using: .utf8) + 2
            let column = xmlParser.columnNumber - (shiftColumn ? shiftSize : 0)
            
            let error = xmlParser.parserError
            assert(error != nil)
            throw ParserError(parserError: error!, line: line, column: column)
        }
        
        return attributedString
    }
    
    // MARK: - XMLParserDelegate
    
    @objc
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        foundNewString()
        enter(element: elementName, attributes: attributeDict)
    }
    
    @objc
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        foundNewString()
        guard elementName != Parser.topTag else { return }
        exit(element: elementName)
    }
    
    @objc
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString = (currentString ?? "").appending(string)
    }
    
    // MARK: -
    
    private func enter(element elementName: String, attributes: [String: String]) {
        guard elementName != Parser.topTag else { return }
        
        guard let custom = styles[elementName] else {
            fatalError("发现了未定义样式的 xml tag!")
        }
        
        let style: XMLDynamicStyle
        // 继承父标签属性
        if
            let last = xmlDynamicStyles.last?.style as? TextStyle,
            let copy = custom as? TextStyle
        {
            style = XMLDynamicStyle(
                tag: elementName,
                style: copy.merge(last),
                xmlAttributes: attributes
            )
        } else {
            style = XMLDynamicStyle(
                tag: elementName,
                style: custom,
                xmlAttributes: attributes
            )
        }
        xmlDynamicStyles.append(style)
    }
    
    private func exit(element elementName: String) {
        xmlDynamicStyles.removeLast()
    }
    
    private func foundNewString() {
        var new = AttributedString(string: currentString ?? "")
        for xmlStyle in xmlDynamicStyles {
            let style = xmlStyle.style
            if let attributedString = style as? AttributedString {
                new = attributedString
            } else if let image = style as? UIImage {
                new = image.generateAttachment()
            } else if let textStyle = style as? TextStyleProtocol {
                new = new.set(style: textStyle)
            }
        }
        attributedString.append(new)
        currentString = nil
    }
    
}

class XMLDynamicStyle {
    
    let tag: String
    
    let style: StyleProtocol
    
    let xmlAttributes: [String: String]?
    
    init(tag: String, style: StyleProtocol, xmlAttributes: [String: String]? = nil) {
        self.tag = tag
        self.style = style
        self.xmlAttributes = xmlAttributes
    }
    
    func enumerateAttributes(_ body: (_ key: String, _ value: String) -> Void) {
        guard let xmlAttributes = xmlAttributes else { return }
        xmlAttributes.forEach(body)
    }
    
}
