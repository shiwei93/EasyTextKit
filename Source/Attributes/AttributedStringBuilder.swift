//
//  AttributedStringBuilder.swift
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

@_functionBuilder
public struct AttributedStringBuilder {
    public static func buildBlock(_ segments: NSAttributedString...) -> NSAttributedString {
        let string = AttributedString()
        segments.forEach(string.append)
        return string
    }
    
    public static func buildExpression(_ text: String) -> NSAttributedString {
        return NSAttributedString(string: text)
    }
    
    public static func buildExpression(_ attr: NSAttributedString) -> NSAttributedString {
        return attr
    }
    
    #if os(iOS) || os(OSX)
    public static func buildExpression(_ image: Image?) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        return NSAttributedString(attachment: attachment)
    }
    #endif
}

public extension NSAttributedString {
    convenience init(@AttributedStringBuilder _ content: () -> NSAttributedString) {
        self.init(attributedString: content())
    }
}
