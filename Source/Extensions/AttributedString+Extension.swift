//
//  AttributedString+Extension.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation

extension NSAttributedString {

    /// Recalculate style in the attributed string over the specified range.
    ///
    /// - Parameters:
    ///   - style: The `StyleProtocol` to be used.
    ///   - range: The range to operate over.
    /// - Returns: attributed string
    @discardableResult
    public func applying(style: StyleProtocol, range: NSRange? = nil) -> AttributedString {
        let attribtued = AttributedString(attributedString: self)
        return style.set(to: attribtued, range: range)
    }

    ///  Remove attributes in the attributed string over the specified range.
    ///
    /// - Parameters:
    ///   - keys: The NSAttributedString.Key will be removed/
    ///   - range: The range to operate over.
    /// - Returns: attributed string
    @discardableResult
    public func remove(attributes keys: [NSAttributedString.Key], range: NSRange) -> Self {
        let attribtued = AttributedString(attributedString: self)
        keys.forEach { attribtued.removeAttribute($0, range: range) }
        return self
    }

    /// Remove style in the attributed string over the specified range.
    ///
    /// - Parameters:
    ///   - style:
    /// - Returns: attributed string
    @discardableResult
    public func remove(style: StyleProtocol) -> Self {
        let attributes = style.styleDescription.constructAttributes()
        remove(
            attributes: Array(attributes.keys),
            range: NSRange(location: 0, length: length)
        )
        return self
    }

}

extension NSAttributedString: StyleProtocol { }

extension NSAttributedString {
    func mutableAttributedStringCopy() -> AttributedString? {
        mutableCopy() as? AttributedString
    }
}
