//
//  AttributedString+Extension.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    @discardableResult
    public func applying(style: StyleProtocol, range: NSRange? = nil) -> AttributedString {
        let attribtued = AttributedString(attributedString: self)
        return style.set(to: attribtued, range: range)
    }
    
    @discardableResult
    public func remove(attributes keys: [NSAttributedString.Key], range: NSRange) -> Self {
        let attribtued = AttributedString(attributedString: self)
        keys.forEach { attribtued.removeAttribute($0, range: range) }
        return self
    }
    
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
    func mutableAttributedStringCopy() -> AttributedString {
        guard let new = mutableCopy() as? AttributedString else {
            fatalError("mutableCopy() 拷贝失败!!")
        }
        return new
    }
}
