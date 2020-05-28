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

    public static func buildBlock() -> NSAttributedString {
        return NSAttributedString()
    }

    public static func buildExpression(_ text: String) -> NSAttributedString {
        return NSAttributedString(string: text)
    }

    public static func buildExpression(_ attr: NSAttributedString) -> NSAttributedString {
        return attr
    }

    #if os(iOS) || os(OSX) || os(tvOS)
    public static func buildExpression(_ image: Image?) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        return NSAttributedString(attachment: attachment)
    }
    #endif

    public static func buildOptional(_ attr: NSAttributedString?) -> NSAttributedString {
        return attr ?? NSAttributedString()
    }

    public static func buildIf(_ attr: NSAttributedString?) -> NSAttributedString {
        return attr ?? NSAttributedString()
    }

    public static func buildEither(first: NSAttributedString) -> NSAttributedString {
        return first
    }

    public static func buildEither(second: NSAttributedString) -> NSAttributedString {
        return second
    }
}

public extension NSAttributedString {
    convenience init(@AttributedStringBuilder _ content: () -> NSAttributedString) {
        self.init(attributedString: content())
    }
}
