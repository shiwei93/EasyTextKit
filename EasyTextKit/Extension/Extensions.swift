//
//  Extensions.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

extension NSParagraphStyle {
    func paragraphCopy() -> NSMutableParagraphStyle {
        guard let new = mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("copy failed.")
        }
        return new
    }
}
