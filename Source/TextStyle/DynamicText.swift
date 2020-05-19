//
//  DynamicText.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/13.
//  Copyright © 2020 easy. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// DynamicText encapsulate the attributes for fonts to automatically scale to match the current Dynamic Type settings.
/// It uses UIFontMetrics.
public struct DynamicText {

    /// The text style that you want to apply to the font.
    public var style: UIFont.TextStyle?

    /// The maximum point size allowed for the font.
    /// Use this value to constrain the font to the specified
    /// size when your interface cannot accommodate text that is any larger.
    public var maximumPointSize: CGFloat

    #if os(iOS) || os(tvOS)
    /// The trait collection to use when determining compatibility.
    /// The returned font is appropriate for use in an interface that adopts the specified traits.
    public var traitCollection: UITraitCollection?

    /// Initialize a new dynamic text with configuration.
    ///
    /// - Parameters:
    ///   - style: The text style that you want to apply to the font.
    ///   - maximumPointSize: The maximum point size allowed for the font.
    ///   - traitCollection: The trait collection to use when determining compatibility.
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
    /// Initialize a new dynamic text with configuration.
    ///
    /// - Parameters:
    ///   - style: The text style that you want to apply to the font.
    ///   - maximumPointSize: The maximum point size allowed for the font.
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
