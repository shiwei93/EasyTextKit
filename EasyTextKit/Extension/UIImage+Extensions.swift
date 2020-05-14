//
//  UIImage+Extensions.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func applying(style: Style) -> AttributedString {
        var attributes = style.styleDescription.constructAttributes()
        let baselineOffset = attributes[.baselineOffset] as? CGFloat
        let baselinesOffsetForAttachment = baselineOffset ?? 0
        let attachment = NSTextAttachment()
        
        let imageIsTemplate = (renderingMode != .alwaysOriginal)
        
        var imageToUse = self
        if let color = attributes[.foregroundColor] as? UIColor {
            if imageIsTemplate {
                imageToUse = tintedImage(color: color)
            }
        }
        attachment.image = imageToUse
        attachment.bounds = CGRect(
            origin: CGPoint(x: 0, y: baselinesOffsetForAttachment),
            size: size
        )
        
        let attachmentString = NSAttributedString(
            attachment: attachment).mutableAttributedStringCopy()
        
        attributes[.baselineOffset] = nil
        attachmentString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: attachmentString.length)
        )
        
        return attachmentString
    }
    
    private func tintedImage(color: UIColor) -> UIImage {
        let imageRect = CGRect(origin: .zero, size: size)
        
        let originalCapInsets = capInsets
        let originalResizingMode = resizingMode
        let originalAlignmentRectInsets = alignmentRectInsets
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // http://stackoverflow.com/a/22528426/255489
        
        context.setBlendMode(.normal)
        context.draw(cgImage!, in: imageRect)
        
        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(imageRect)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        image = image.withRenderingMode(.alwaysOriginal)
        
        image = image.withAlignmentRectInsets(originalAlignmentRectInsets)
        if originalCapInsets != image.capInsets || originalResizingMode != image.resizingMode {
            image = image.resizableImage(
                withCapInsets: originalCapInsets,
                resizingMode: originalResizingMode
            )
        }
        
        image.accessibilityLabel = self.accessibilityLabel
        
        return image
    }
    
}
