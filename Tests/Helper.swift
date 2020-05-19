//
//  Helper.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/18.
//

@testable import EasyTextKit
import XCTest

// swiftlint:disable all
func assert<T: Equatable>(
    style: Style,
    key: NSAttributedString.Key, value: T,
    file: StaticString = #file,
    line: UInt = #line
) {
    let dict = style.styleDescription.constructAttributes()
    guard let dictValue = dict[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }

    XCTAssert(dictValue == value, "\(key): \(dictValue) != \(value)", file: file, line: line)
}

func assert<T: RawRepresentable>(
    style: Style,
    query: (NSParagraphStyle) -> T,
    value: T,
    file: StaticString = #file,
    line: UInt = #line
) where T.RawValue: Equatable {
    let dict = style.styleDescription.constructAttributes()
    guard let paragraphStyle = dict[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let _value = query(paragraphStyle)
    XCTAssertEqual(value.rawValue, _value.rawValue, file: file, line: line)
}

func assert(
    style: Style,
    query: (NSParagraphStyle) -> CGFloat,
    float: CGFloat,
    accuracy: CGFloat,
    file: StaticString = #file,
    line: UInt = #line
) {
    let dict = style.styleDescription.constructAttributes()
    guard let paragraphStyle = dict[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let _value = query(paragraphStyle)
    XCTAssertEqual(_value, float, accuracy: accuracy, file: file, line: line)
}

class EBGaramondLoader: NSObject {

    static func loadFontIfNeeded() {
        _ = loadFont
    }

    private static var loadFont: Void = {
        guard let path = Bundle(for: EBGaramondLoader.self).path(forResource: "EBGaramond12-Regular", ofType: "otf"), let data = NSData(contentsOfFile: path) else {
            fatalError("Can not load EGBaramond12")
        }

        guard let provider = CGDataProvider(data: data) else {
            fatalError("Can not create provider")
        }
        let fontRef = CGFont(provider)

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(fontRef!, &error)

        if let error = error {
            fatalError("Unable to load font: \(error)")
        }
    }()

}
