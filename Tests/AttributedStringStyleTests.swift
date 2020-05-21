//
//  AttributedStringStyleTests.swift
//  EasyTextKit
//
//  Created by shiwei on 2020/5/18.
//

@testable import EasyTextKit
import XCTest

// swiftlint:disable all
class AttributedStringStyleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        EBGaramondLoader.loadFontIfNeeded()
    }

    func testBasicAssertionUtilities() {
        let font = Font(name: "Avenir-Roman", size: 24)!
        let color = Color.red
        let backgroundColor = Color.black
        let style = Style()
            .font(font)
            .foregroundColor(color)
            .backgroundColor(backgroundColor)
        let attribtues = style.styleDescription.constructAttributes()
        guard let savedFont = attribtues[.font] as? Font else {
            fatalError("font was nil or of wrong type.")
        }
        XCTAssertEqual(savedFont.fontName, font.fontName)
        XCTAssertEqual(savedFont.pointSize, font.pointSize)
        assert(style: style, key: .foregroundColor, value: color)
        assert(style: style, key: .backgroundColor, value: backgroundColor)
    }

    func testUnderlineStyle() {
        let color = Color.red
        let underline: NSUnderlineStyle = .patternDash
        let style = Style().underline(underline, color: color)
        assert(style: style, key: .underlineStyle, value: underline.rawValue)
        assert(style: style, key: .underlineColor, value: color)
    }

    func testStroke() {
        let width: CGFloat = 2
        let style = Style().stroke(.red, width: width)
        assert(style: style, key: .strokeColor, value: Color.red)
        assert(style: style, key: .strokeWidth, value: width)
    }

    func testStrikethrougnStyle() {
        let style = Style().strikethroughStyle(.byWord, color: .red)
        assert(style: style, key: .strikethroughStyle, value: NSUnderlineStyle.byWord.rawValue)
        assert(style: style, key: .strikethroughColor, value: Color.red)
    }

    func testBaselineOffset() {
        let offset: CGFloat = 15
        let style = Style().baselineOffset(offset)
        assert(style: style, key: .baselineOffset, value: offset)
    }

    func testLigatureStyle() {
        let style = Style().ligature(.disabled)
        assert(style: style, key: .ligature, value: 0)
    }

    func testURL() {
        let url = URL(string: "https://apple.com/")
        let style = Style().linkURL(url)
        assert(style: style, key: .link, value: url)
    }

    func testLineSpacing() {
        let lineSpacing: CGFloat = 23
        let style = Style().lineSpacing(lineSpacing)
        assert(style: style, query: { $0.lineSpacing }, float: lineSpacing, accuracy: 0.001)
    }

    func testParagraphSpacingBefore() {
        let paragraphSpacingBefore: CGFloat = 9
        let style = Style().paragraphSpacingBefore(paragraphSpacingBefore)
        assert(style: style, query: { $0.paragraphSpacingBefore }, float: paragraphSpacingBefore, accuracy: 0.001)
    }

    func testParagraphSpacingAfter() {
        let paragraphSpacingAfter: CGFloat = 9
        let style = Style().paragraphSpacingAfter(paragraphSpacingAfter)
        assert(style: style, query: { $0.paragraphSpacing }, float: paragraphSpacingAfter, accuracy: 0.001)
    }

    func testAlignment() {
        let alignment: NSTextAlignment = .justified
        let style = Style().alignment(alignment)
        assert(style: style, query: { $0.alignment }, value: alignment)
    }

    func testIndent() {
        let firstLineHeadIndent: CGFloat = 2.22
        let headIndent: CGFloat = 3.33
        let tailIndent: CGFloat = 4.44
        let style = Style()
            .firstLineHeadIndent(firstLineHeadIndent)
            .headIndent(headIndent)
            .tailIndent(tailIndent)
        assert(style: style, query: { $0.firstLineHeadIndent }, float: firstLineHeadIndent, accuracy: 0.001)
        assert(style: style, query: { $0.headIndent }, float: headIndent, accuracy: 0.001)
        assert(style: style, query: { $0.tailIndent }, float: tailIndent, accuracy: 0.001)
    }

    func testLineBreakMode() {
        let lineBreakMode: NSLineBreakMode = .byTruncatingMiddle
        let style = Style().lineBreakMode(lineBreakMode)
        assert(style: style, query: { $0.lineBreakMode }, value: lineBreakMode)
    }

    func testLineHeight() {
        let minimumLineHeight: CGFloat = 20
        let maximumLineHeight: CGFloat = 40
        let lineHeightMultiple: CGFloat = 1.22
        let style = Style()
            .minimumLineHeight(minimumLineHeight)
            .maximumLineHeight(maximumLineHeight)
            .lineHeightMultiple(lineHeightMultiple)
        assert(style: style, query: { $0.minimumLineHeight }, float: minimumLineHeight, accuracy: 0.01)
        assert(style: style, query: { $0.maximumLineHeight }, float: maximumLineHeight, accuracy: 0.01)
        assert(style: style, query: { $0.lineHeightMultiple }, float: lineHeightMultiple, accuracy: 0.01)
    }

    func testHyphenation() {
        let style = Style().hyphenationFactor(1.0)
        assert(style: style, query: { CGFloat($0.hyphenationFactor) }, float: CGFloat(1.0), accuracy: 0.1)
    }

    func testBaseWritingDirection() {
        let baseWritingDirection: NSWritingDirection = .rightToLeft
        let style = Style().baseWritingDirection(baseWritingDirection)
        assert(style: style, query: { $0.baseWritingDirection }, value: baseWritingDirection)
    }

    func testNoTracking() {
        let style = Style().foregroundColor(.red)
        let styled = "abcd".attributedString(style: style)
        checkTrackingValue(NSRange(location: 0, length: 4), checkingType: .none, line: #line, in: styled)
    }

    func testTracking() {
        let style = Style().tracking(.point(5))
        let styled = "abcd".attributedString(style: style)
        checkTrackingValue(NSRange(location: 0, length: 3), checkingType: .tracking(5), line: #line, in: styled)
    }

    func testTrackingInAttributedStringBuilder() {
        let style5 = Style().tracking(.point(5))
        let style10 = Style().tracking(.point(10))
        let styled = NSAttributedString {
            "ab".attributedString(style: style5)
            "\n"
            "cd".attributedString(style: style10)
        }
        checkTrackingValue(NSRange(location: 0, length: 2), checkingType: .tracking(5), line: #line, in: styled)
        checkTrackingValue(NSRange(location: 2, length: 1), checkingType: .tracking(10), line: #line, in: styled)
    }

    func testNumberCase() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).numberCase(.lower)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }

        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kNumberCaseType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kLowerCaseNumbersSelector)
    }

    func testNumberSpacing() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).numberSpacing(.monospaced)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }

        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kNumberSpacingType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kMonospacedNumbersSelector)
    }

    func testFractionsStyle() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).fractions(.diagonal)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kFractionsType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kDiagonalFractionsSelector)
    }

    func testSuperscript() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).superscript(isOn: true)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kVerticalPositionType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kSuperiorsSelector)
    }

    func testSubscript() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).subscript(isOn: true)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kVerticalPositionType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kInferiorsSelector)
    }

    func testOrdinals() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).ordinals(isOn: true)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kVerticalPositionType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kOrdinalsSelector)
    }

    func testScientificInferiors() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).scientificInferiors(isOn: true)
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kVerticalPositionType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kScientificInferiorsSelector)
    }

    func testSmallCapsStyle() {
        let style = Style().font(Font(name: "EBGaramond12-Regular", size: 24)!).smallCaps([.fromUppercase])
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 1)
        XCTAssertEqual(featureArray[0][FontFeatureTypeIdentifierKey], kUpperCaseType)
        XCTAssertEqual(featureArray[0][FontFeatureSelectorIdentifierKey], kUpperCaseSmallCapsSelector)
    }

    func testStylisticAlternatives() {
        let style = Style().font(Font(name: "HypatiaSansPro-Regular", size: 24)!).stylisticAlternatives([.one, .three, .twenty])
        let font = style.styleDescription.constructAttributes()[.font] as? Font
        XCTAssertNotNil(font)
        let fontAttributes = font?.fontDescriptor.fontAttributes
        XCTAssertNotNil(fontAttributes)
        let featureAttribute = fontAttributes?[FontDescriptorFeatureSettingsAttribute]
        XCTAssertNotNil(featureAttribute)
        guard let featureArray = featureAttribute as? [[FontDescriptor.FeatureKey: Int]] else {
            XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[FontDescriptor.FeatureKey: Int]]")
            return
        }
        XCTAssertEqual(featureArray.count, 2)
        XCTAssertTrue(featureArray.contains { $0[FontFeatureSelectorIdentifierKey] == kStylisticAltOneOnSelector })
        XCTAssertTrue(featureArray.contains { $0[FontFeatureSelectorIdentifierKey] == kStylisticAltThreeOnSelector })
        // Stylistic Alternatives twenty is not supported!
        XCTAssertFalse(featureArray.contains { $0[FontFeatureSelectorIdentifierKey] == kStylisticAltTwentyOnSelector })
    }

}

extension AttributedStringStyleTests {

    enum TrackingCheckingType {
        case none
        case tracking(Double)
    }

    func checkTrackingValue(_ range: NSRange, checkingType: TrackingCheckingType, line: UInt, in attr: NSAttributedString) {
        let trackingValue = attr.attribute(.kern, at: range.location, effectiveRange: nil)
        if case .tracking(let value) = checkingType {
            guard let trackingValue = trackingValue as? NSNumber else {
                return
            }
            XCTAssertEqual(trackingValue.doubleValue, value, accuracy: 0.0001, line: line)
        } else {
            XCTAssertNil(trackingValue, line: line)
        }
    }

}
