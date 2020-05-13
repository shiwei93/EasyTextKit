//
//  Extensions.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation
import UIKit

extension Array where Array.Element == StyleProtocol {
    
    func merge() -> Style {
        var attributes: [NSAttributedString.Key: Any] = [:]
//        forEach {
//            attributes.merge($0.attributes) { (_, new) in
//                return new
//            }
//        }
        //TODO: - merge description
        return Style(attributes)
    }
    
}

extension NSParagraphStyle {
    func paragraphCopy() -> NSMutableParagraphStyle {
        guard let new = mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("copy failed.")
        }
        return new
    }
}
