//
//  TextStyleProtocol.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation

public typealias AttributedString = NSMutableAttributedString

/// 区分 UIKit String 和实际 TextStyle 的联系
public protocol StyleProtocol { }

public protocol TextStyleProtocol: StyleProtocol {
    
    var attributes: [NSAttributedString.Key: Any] { get }
    
    func set(to source: String, range: NSRange?) -> AttributedString
    
    func set(to source: AttributedString, range: NSRange?) -> AttributedString
    
    @discardableResult
    func remove(from source: AttributedString, range: NSRange?) -> AttributedString
    
}

extension TextStyleProtocol {
    
    public func set(to source: String, range: NSRange?) -> AttributedString {
        let range = range ?? NSRange(location: 0, length: source.count)
        let attributedText = AttributedString(string: source)
        attributedText.addAttributes(attributes, range: range)
        return attributedText
    }
    
    public func set(to source: AttributedString, range: NSRange?) -> AttributedString {
        let range = range ?? NSRange(location: 0, length: source.length)
        source.addAttributes(attributes, range: range)
        return source
    }
    
    @discardableResult
    public func remove(from source: AttributedString, range: NSRange?) -> AttributedString {
        let range = range ?? NSRange(location: 0, length: source.length)
        attributes.keys.forEach {
            source.removeAttribute($0, range: range)
        }
        return AttributedString()
    }
    
}
