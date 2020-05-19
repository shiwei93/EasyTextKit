//
//  StyleProtocol.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation

public protocol StyleProtocol {

     /// `StyleDescription` modified when set style.
    var styleDescription: StyleDescription { get }

    /// Set current style in the string over the specified range.
    /// - Parameters:
    ///   - source: The string to be seted.
    ///   - range: The range to operate over.
    /// - Returns: Attributed string after setted current style.
    func set(to source: String, range: NSRange?) -> AttributedString

    /// Set current style in the attributed string over the specified range.
    ///
    /// - Parameters:
    ///   - source: The attributed string to be seted.
    ///   - range: The range to operate over.
    /// - Returns: Attributed string after remove current style.
    func set(to source: AttributedString, range: NSRange?) -> AttributedString

    /// Remove style from source (as `AttributedString`)
    ///
    /// - Parameters:
    ///   - source: The attributed string to be removed.
    ///   - range: The range to operate over.
    /// - Returns: Attributed string after remove current style.
    @discardableResult
    func remove(from source: AttributedString, range: NSRange?) -> AttributedString

}

extension StyleProtocol {

    public var styleDescription: StyleDescription { StyleDescription(attributes: [:]) }

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

    static func combine(_ parent: StyleProtocol, _ child: StyleProtocol) -> StyleProtocol {
        let description = StyleDescription.combine(parent.styleDescription, child.styleDescription)
        return Style(description)
    }

}
