//
//  StyleProtocol.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation

public protocol StyleProtocol {
    
    var styleDescription: StyleDescription { get }
    
    func set(to source: String, range: NSRange?) -> AttributedString
    
    func set(to source: AttributedString, range: NSRange?) -> AttributedString
    
    @discardableResult
    func remove(from source: AttributedString, range: NSRange?) -> AttributedString
    
}

extension StyleProtocol {
    
    public func set(to source: String, range: NSRange?) -> AttributedString {
        let range = range ?? NSRange(location: 0, length: source.count)
        let attributedText = AttributedString(string: source)
        attributedText.addAttributes(styleDescription.constructAttributes(), range: range)
        return attributedText
    }
    
    public func set(to source: AttributedString, range: NSRange?) -> AttributedString {
        let range = range ?? NSRange(location: 0, length: source.length)
        source.addAttributes(styleDescription.constructAttributes(), range: range)
        return source
    }
    
    @discardableResult
    public func remove(from source: AttributedString, range: NSRange?) -> AttributedString {
        let range = range ?? NSRange(location: 0, length: source.length)
        styleDescription.constructAttributes().keys.forEach {
            source.removeAttribute($0, range: range)
        }
        return source
    }
    
}
