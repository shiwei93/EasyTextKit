//
//  DynamicText.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/13.
//  Copyright © 2020 easy. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public struct DynamicText {
    
    public var style: UIFont.TextStyle?
    
    public var maximumPointSize: CGFloat
    
    #if os(iOS) || os(tvOS)
    public var traitCollection: UITraitCollection?
    
    public init(
        style: UIFont.TextStyle? = nil,
        maximumPointSize: CGFloat = 0.0,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) {
        self.style = style
        self.maximumPointSize = maximumPointSize
        self.traitCollection = traitCollection
    }
    #else
    public init(
        style: UIFont.TextStyle? = nil,
        maximumPointSize: CGFloat = 0.0
    ) {
        self.style = style
        self.maximumPointSize = maximumPointSize
    }
    #endif
    
}

#endif
