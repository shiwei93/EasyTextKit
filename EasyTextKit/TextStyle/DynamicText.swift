//
//  DynamicText.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/13.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
public struct DynamicText {
    
    public var style: UIFont.TextStyle?
    
    public var maximumPointSize: CGFloat
    
    public var traitCollection: UITraitCollection?
    
    public init(style: UIFont.TextStyle? = nil, maximumPointSize: CGFloat = 0.0, compatibleWith traitCollection: UITraitCollection? = nil) {
        self.style = style
        self.maximumPointSize = maximumPointSize
        self.traitCollection = traitCollection
    }
    
}

