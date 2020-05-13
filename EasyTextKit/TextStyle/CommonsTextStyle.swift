//
//  CommonsTextStyle.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation
import UIKit

public protocol CommonsTextStyle {
    
    var attributes: [NSAttributedString.Key : Any] { get set }
    
}

extension CommonsTextStyle {
    
    mutating func set<T>(value: T?, forKey key: NSAttributedString.Key) {
        guard let value = value else {
            attributes.removeValue(forKey: key)
            return
        }
        attributes[key] = value
    }
    
    func get<T>(attributeForKey key: NSAttributedString.Key) -> T? {
        return attributes[key] as? T
    }
    
}

public struct Color: CommonsTextStyle {
    
    public var attributes: [NSAttributedString.Key : Any]
    
    public mutating func foregroundColor(_ color: UIColor) -> Color {
        set(value: color, forKey: .foregroundColor)
        return self
    }
    
    public mutating func backgroundColor(_ color: UIColor) -> Self {
        set(value: color, forKey: .backgroundColor)
        return self
    }
    
    // color just init
    
}

public struct Font: CommonsTextStyle {
    
    public var attributes: [NSAttributedString.Key : Any]
    
    // init with UIFont object
    
}

public struct Paragraph: CommonsTextStyle {
    
    public var attributes: [NSAttributedString.Key : Any]
    
    // paragraph init with default paragrapuStyle
    
}

@available(iOS 11.0, *)
public struct DynamicText: CommonsTextStyle {
    
    /// `attributes` will not work in `DynamicText`.
    public var attributes: [NSAttributedString.Key : Any] = [:]
    
    public var style: UIFont.TextStyle?
    
    public var maximumPointSize: CGFloat
    
    public var traitCollection: UITraitCollection?
    
    public init(style: UIFont.TextStyle? = nil, maximumPointSize: CGFloat = 0.0, compatibleWith traitCollection: UITraitCollection? = nil) {
        self.style = style
        self.maximumPointSize = maximumPointSize
        self.traitCollection = traitCollection
    }
    
}
