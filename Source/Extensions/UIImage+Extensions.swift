//
//  UIImage+Extensions.swift
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

#if os(iOS) || os(tvOS) || os(OSX)
extension Image {

    /// Recalculate style in the `UIImage`.
    ///
    /// - Parameters:
    ///   - style: The `StyleProtocol` to be used.
    /// - Returns: attributed string
    public func attributedString(style: Style) -> AttributedString {
        var attributes = style.styleDescription.constructAttributes()
        let baselineOffset = attributes[.baselineOffset] as? CGFloat
        let baselinesOffsetForAttachment = baselineOffset ?? 0
        let attachment = NSTextAttachment()

        #if os(OSX)
        let imageIsTemplate = isTemplate
        #else
        let imageIsTemplate = (renderingMode != .alwaysOriginal)
        #endif

        var imageToUse = self
        if let color = attributes[.foregroundColor] as? Color {
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

    #if os(OSX)
    private func tintedImage(color: Color) -> Image {
        let imageRect = CGRect(origin: .zero, size: size)

        let image = Image(size: size)

        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: color.colorSpaceName,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )!

        image.addRepresentation(rep)

        image.lockFocus()

        let context = NSGraphicsContext.current!.cgContext

        context.setBlendMode(.normal)
        let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        context.draw(cgImage, in: imageRect)

        // .sourceIn: resulting color = source color * destination alpha
        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(imageRect)

        image.unlockFocus()

        // Prevent further tinting
        image.isTemplate = false

        // Transfer accessibility description
        image.accessibilityDescription = self.accessibilityDescription

        return image
    }
    #else
    private func tintedImage(color: Color) -> Image {
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

        #if os(iOS) || os(tvOS)
        image.accessibilityLabel = self.accessibilityLabel
        #endif

        return image
    }
    #endif

}
#endif
