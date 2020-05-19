//
//  String+Extensions.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation

extension String {

    /// Recalculate style in the string over the specified range.
    ///
    /// - Parameters:
    ///   - style: The `StyleProtocol` to be used.
    ///   - range: The range to operate over.
    /// - Returns: attributed string
    public func attributedString(style: StyleProtocol, range: NSRange? = nil) -> AttributedString {
        return style.set(to: self, range: range)
    }

}
