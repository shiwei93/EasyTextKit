//
//  EmphasisTests.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/18.
//

@testable import EasyTextKit
import XCTest

class EmphasisTests: XCTestCase {

    func testEmphasizeStyle() {
        let baseFont = Font.systemFont(ofSize: 20)
        let baseStyle = Style().font(baseFont)
        let bold = baseStyle.emphasizeStyle(.bold)
        let combined = bold.emphasizeStyle(.italic)
        let attributes = combined.styleDescription.constructAttributes()
        guard let font = attributes[.font] as? Font else {
            XCTFail("Unable to get font.")
            return
        }
        
        let descriptor = baseFont.fontDescriptor
        var traits = descriptor.symbolicTraits
        #if os(OSX)
        traits.insert([.italic, .bold])
        #else
        traits.insert([.traitItalic, .traitBold])
        #endif
        let newDescriptor: FontDescriptor? = descriptor.withSymbolicTraits(traits)
        guard let nonNilNewDescriptor = newDescriptor else {
            XCTFail("Unable to get descriptor.")
            return
        }
        let controlFont = Font(descriptor: nonNilNewDescriptor, size: 0)
        
        XCTAssertEqual(font, controlFont)
    }

}
