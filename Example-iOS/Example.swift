//
//  Example.swift
//  Example-iOS
//
//  Created by 施伟 on 2020/5/18.
//

import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
import EasyTextKit

// swiftlint:disable:next type_body_length
struct Example {

    static var avenirNextCondensed: Font {
        #if os(iOS) || os(OSX) || os(watchOS)
        return Font(name: "AvenirNextCondensed-Bold", size: 24)!
        #else
        return Font(name: "AvenirNextCondensed-Bold", size: 36)!
        #endif
    }

    static var avenirNextCondensedMedium: Font {
        #if os(iOS) || os(OSX) || os(watchOS)
        return Font(name: "AvenirNextCondensed-Medium", size: 18.0)!
        #else
        return Font(name: "AvenirNextCondensed-Medium", size: 38.0)!
        #endif
    }

    static var gillSans: Font {
        #if os(iOS) || os(OSX) || os(watchOS)
        return Font(name: "GillSans-Light", size: 18)!
        #else
        return Font(name: "GillSans-Light", size: 36)!
        #endif
    }

    static var superClarendon: Font {
        #if os(iOS)
        return Font(name: "SuperClarendon-Black", size: 18)!
        #elseif os(tvOS)
        return Font(name: "SuperClarendon", size: 34)!
        #else
        return Font(name: "SuperClarendon", size: 18)!
        #endif
    }

    static var zapfino: Font {
        #if os(iOS) || os(OSX)
        return Font(name: "Zapfino", size: 24)!
        #elseif os(tvOS)
        return Font(name: "Zapfino", size: 36)!
        #else
        return Font(name: "Zapfino", size: 16)!
        #endif
    }

    static var helveticaNeue: Font {
        #if os(iOS) || os(OSX)
        return Font(name: "HelveticaNeue-Bold", size: 24)!
        #elseif os(tvOS)
        return Font(name: "HelveticaNeue-Bold", size: 36)!
        #else
        return Font.systemFont(ofSize: 24)
        #endif
    }

    static var custom: Font {
        #if os(iOS) || os(watchOS) || os(OSX)
        return Font(name: "EBGaramond12-Regular", size: 24)!
        #else
        return Font(name: "EBGaramond12-Regular", size: 36)!
        #endif
    }

    static var avenirNextMedium: Font {
        #if os(iOS) || os(watchOS) || os(OSX)
        return Font(name: "AvenirNext-Medium", size: 16)!
        #else
        return Font(name: "AvenirNext-Medium", size: 26)!
        #endif
    }

    static let normal: NSAttributedString = {
        let style = Style()
            .font(avenirNextCondensed)
            .alignment(.center)
            .lineSpacing(5)
            .tracking(.point(6))
            .foregroundColor(Color(red: 0.15, green: 0.4, blue: 0.86, alpha: 1.0))

        return "JUST SAMPLE".attributedString(style: style)
    }()

    static let xmlSample: NSAttributedString = {
        #if os(iOS) || os(tvOS) || os(OSX)
        let xml = """
        I want to be different. If everyone is wearing <black>\u{00A0}black,\u{00A0}</black> I want to be wearing <red>\u{00A0}red.\u{00A0}</red>
        <signed>\u{2014}Maria Sharapova</signed> <racket/>
        """
        #else
        let xml = """
        I want to be different. If everyone is wearing <black>\u{00A0}black,\u{00A0}</black> I want to be wearing <red>\u{00A0}red.\u{00A0}</red>
        <signed>\u{2014}Maria Sharapova</signed>
        """
        #endif

        let color = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)

        let style: Style
        #if os(iOS) || os(tvOS) || os(watchOS)
        if #available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *) {
            #if os(iOS) || os(tvOS)
            let dynamicText = DynamicText(style: .body, maximumPointSize: 35, compatibleWith: UITraitCollection(userInterfaceIdiom: .phone))
            #else
            let dynamicText = DynamicText(style: .body, maximumPointSize: 35)
            #endif
            style = Style()
                .font(gillSans)
                .lineHeightMultiple(1.8)
                .foregroundColor(.darkGray)
                .dynamicText(dynamicText)
        } else {
            style = Style()
                .font(gillSans)
                .lineHeightMultiple(1.8)
                .foregroundColor(.darkGray)
        }
        #else
        style = Style()
            .font(gillSans)
            .lineHeightMultiple(1.8)
            .foregroundColor(.darkGray)
        #endif

        let accent = style
            .font(superClarendon)

        let black = accent
            .foregroundColor(.white)
            .backgroundColor(.black)

        let red = accent
            .foregroundColor(.white)
            .backgroundColor(color)

        let signed = accent
            .foregroundColor(color)

        let image = Image(named: "Tennis Racket")!
        #if os(OSX)
        image.isTemplate = true
        #endif
        let imageStyle = signed
            .baselineOffset(-4)
        #if os(iOS) || os(tvOS) || os(OSX)
        let racket = image.attributedString(style: imageStyle)

        let group = XMLStyle(
            base: style,
            [
                "black": black,
                "red": red,
                "signed": signed,
                "racket": racket,
            ]
        )
        #else

        let group = XMLStyle(
            base: style,
            [
                "black": black,
                "red": red,
                "signed": signed,
            ]
        )
        #endif

        return xml.attributedString(style: group)
    }()

    static let emphasis: NSAttributedString = {
        let string = """
        You can parse HTML with <strong>strong</strong>, <em>em</em>, <strong>and even <em>nested strong and em</em></strong> tags

        You can parse HTML with <strong>strong</strong>, <em>em</em>, <strong>and even <em>nested strong and em</em></strong> tags.
        """

        #if os(watchOS)
        let foregroundColor: Color = .white
        let font: Font = .systemFont(ofSize: 17)
        #elseif os(iOS) || os(OSX)
        let foregroundColor: Color = .black
        let font: Font = .systemFont(ofSize: 17)
        #else
        let foregroundColor: Color = .black
        let font: Font = .systemFont(ofSize: 34)
        #endif
        let base = Style()
            .font(font)
            .foregroundColor(foregroundColor)

        let color = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)

        let em = base
            .foregroundColor(color)
            .emphasizeStyle(.italic)

        let strong = base
            .foregroundColor(color)
            .emphasizeStyle(.bold)

        let xmlStyle = XMLStyle(
            base: base,
            [
                "em": em,
                "strong": strong,
            ]
        )
        return string.attributedString(style: xmlStyle)
    }()

    static let digital: NSAttributedString = {
        let garamondStyle = Style()
            .font(custom)
            .lineHeightMultiple(1.2)

        let digits = "\n0123456789"

        let color = garamondStyle
            .smallCaps([.fromLowercase])
            .foregroundColor(Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0))

        return NSAttributedString {
            "Number Styles".attributedString(style: color)
            digits.attributedString(style: garamondStyle
                .numberCase(.lower)
                .numberSpacing(.monospaced))
            digits.attributedString(style: garamondStyle
                .numberCase(.upper)
                .numberSpacing(.monospaced))
            digits.attributedString(style: garamondStyle
                .numberCase(.lower)
                .numberSpacing(.proportional))
            digits.attributedString(style: garamondStyle
                .numberCase(.upper)
                .numberSpacing(.proportional))
        }
    }()

    // 科学符号
    static let scientificInferiors: NSAttributedString = {
        let garamondStyle = Style()
            .font(custom)
            .lineHeightMultiple(1.2)
            .numberCase(.upper)

        let string = "<name>Johnny</name> was a little boy, but <name>Johnny</name> is no more, for what he thought was <chemical>H<number>2</number>O</chemical> was really <chemical>H<number>2</number>SO<number>4</number></chemical>."

        let foregroundColor = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)

        let name = garamondStyle
            .smallCaps([.fromLowercase])

        let chemical = garamondStyle
            .foregroundColor(foregroundColor)

        let number = chemical
            .scientificInferiors(isOn: true)

        let style = XMLStyle(
            base: garamondStyle,
            [
                "name": name,
                "chemical": chemical,
                "number": number,
            ]
        )
        return string.attributedString(style: style)
    }()

    // 分数
    static let fraction: NSAttributedString = {
        let garamondStyle = Style()
            .font(custom)
            .lineHeightMultiple(1.2)
            .numberCase(.upper)

        let color = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)

        let string = """
        1336 <fraction>6/10</fraction> + <fraction>4/10</fraction> = 1337

        Normal:
            1336 <normal>6/10</normal> + <normal>4/10</normal> = 1337
        """

        let fraction = garamondStyle
            .fractions(.diagonal)
            .numberCase(.lower)
            .foregroundColor(color)

        let vfraction = garamondStyle
            .fractions(.vertical)
            .numberCase(.lower)
            .foregroundColor(color)

        let normalFraction = garamondStyle
            .fractions(.disabled)
            .numberCase(.lower)
            .foregroundColor(color)

        let style = XMLStyle(
            base: garamondStyle,
            [
                "fraction": fraction,
                "normal": normalFraction,
            ]
        )
        return string.attributedString(style: style)
    }()

    static let superscript: NSAttributedString = {
        let garamondStyle = Style()
            .font(custom)
            .lineHeightMultiple(1.2)

        let color = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        let string = "Today is my <number>111<ordinal>th</ordinal></number> birthday!"

        let number = garamondStyle
            .foregroundColor(color)
            .numberCase(.upper)

        let ordinal = garamondStyle
            .superscript(isOn: true)

        let style = XMLStyle(
            base: garamondStyle,
            [
                "number": number,
                "ordinal": ordinal,
            ]
        )
        return string.attributedString(style: style)
    }()

    static let ligature: NSAttributedString = {
        let style = Style()
            .font(zapfino)
            .foregroundColor(Color(red: 0.82, green: 0.41, blue: 0.11, alpha: 1.0))
            .tracking(.point(6))

        let text = "Hello Swift!!!"

        return NSAttributedString {
            text.attributedString(style: style.ligature(.default))
            "\n"
            text.attributedString(style: style
                .ligature(.disabled))
        }
    }()

    static let images: NSAttributedString = {

        func accessibleImage(named name: String) -> Image {
            let image = Image(named: name)!
            #if os(iOS) || os(tvOS)
            image.accessibilityLabel = name
            #endif
            return image
        }

        let bee = accessibleImage(named: "bee")
        let oar = accessibleImage(named: "oar")
        let knot = accessibleImage(named: "knot")

        let base = Style()
            .font(Font(name: "HelveticaNeue-Bold", size: 24)!)

        let style = base
            .baselineOffset(8)

        return NSAttributedString {
            "2".attributedString(style: style)
            #if os(tvOS) || os(iOS) || os(OSX)
            bee
            oar
            knot
            #endif
            "2".attributedString(style: style)
            #if os(tvOS) || os(iOS) || os(OSX)
            bee
            #endif
        }
    }()

    static let multiImages: NSAttributedString = {
        #if os(tvOS)
        let font: Font = .systemFont(ofSize: 34)
        #else
        let font: Font = .systemFont(ofSize: 17)
        #endif
        let base = Style()
            .font(font)
            .foregroundColor(.darkGray)
            .baselineOffset(10)

        #if os(tvOS) || os(iOS) || os(OSX)
        return NSAttributedString {
            Image(named: "barn")!
            " "
            "This".attributedString(style: base)
            " "
            Image(named: "bee")!
            " "
            "string".attributedString(style: base)
            " "
            Image(named: "bug")!
            " "
            "is".attributedString(style: base)
            " "
            Image(named: "circuit")!
            " "
            "separated".attributedString(style: base)
            " "
            Image(named: "cut")!
            " "
            "by".attributedString(style: base)
            " "
            Image(named: "discount")!
            " "
            "images".attributedString(style: base)
            " "
            Image(named: "gift")!
            " "
            "and".attributedString(style: base)
            " "
            Image(named: "pin")!
            " "
            "spaces".attributedString(style: base)
            " "
            Image(named: "robot")!
        }
        #else
        return NSAttributedString {
            "This".attributedString(style: base)
            " "
            "string".attributedString(style: base)
            " "
            "is".attributedString(style: base)
            " "
            "separated".attributedString(style: base)
            " "
            "by".attributedString(style: base)
            " "
            "images".attributedString(style: base)
            " "
            "and".attributedString(style: base)
            " "
            "spaces.".attributedString(style: base)
        }
        #endif
    }()

    static let kerning: NSAttributedString = {
        let color = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        let base = Style()
            .alignment(.center)
            .foregroundColor(color)
            .lineSpacing(20)
            .font(avenirNextMedium)

        let phrase = """
        GO AHEAD,
        <large>MAKE
        MY
        DA<kern>Y.</kern></large>
        """

        #if os(iOS) || os(tvOS)
        let font = Font(name: "AvenirNext-Heavy", size: 64)!
        #else
        let font = Font(name: "AvenirNext-Heavy", size: 32)!
        #endif
        let fontSize: CGFloat
        let large = base
            .font(font)
            .lineSpacing(40)

        let kern = large
            .tracking(.adobe(-80))

        let style = XMLStyle(
            base: base,
            [
                "large": large,
                "kern": kern,
            ]
        )
        return phrase.attributedString(style: style)
    }()

    static let composition: NSAttributedString = {
        let color = Color(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)

        let base = Style()
            .alignment(.center)

        let preamble = base
            .font(Font(name: "AvenirNext-Bold", size: 14)!)

        #if os(watchOS)
        let bigger = base
            .font(Font(name: "AvenirNext-Heavy", size: 30)!)
        #else
        let bigger = base
            .font(Font(name: "AvenirNext-Heavy", size: 64)!)
        #endif

        let imageStyle = base
            .foregroundColor(color)

        let image = Image(named: "boat")!
        #if os(tvOS) || os(iOS) || os(OSX)
        let boat = image.attributedString(style: imageStyle)
        return NSAttributedString {
            "\n\n"
            "You're going to need a\n".attributedString(style: preamble)
            "Bigger\n".localizedUppercase.attributedString(style: bigger)
            boat
            "\n"
        }
        #else
        return NSAttributedString {
            "\n\n"
            "You're going to need a\n".attributedString(style: preamble)
            "Bigger".localizedUppercase.attributedString(style: bigger)
        }
        #endif
    }()

    static let indention: NSAttributedString = {
        let base = Style()
            .font(avenirNextCondensedMedium)

        let indention = base
            .firstLineHeadIndent(18)
            .paragraphSpacingBefore(9)
            .headIndent(30.78)

        let headIndent: CGFloat
        #if os(tvOS)
        headIndent = 109
        #else
        headIndent = 64.78
        #endif

        let emoji = base
            .firstLineHeadIndent(18)
            .paragraphSpacingBefore(9)
            .headIndent(headIndent)

        return NSAttributedString {
            "• You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.".attributedString(style: indention)
            "\n"
            "🍑 → You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.".attributedString(style: emoji)
        }
    }()

    static let emphasisSet: NSAttributedString = {
        #if os(iOS)
        let base = Style()
            .font(.systemFont(ofSize: 24.0))
            .foregroundColor(.systemGreen)
        #elseif os(tvOS)
        let base = Style()
            .font(.systemFont(ofSize: 36.0))
            .foregroundColor(.systemGreen)
        #else
        let base = Style()
            .font(.systemFont(ofSize: 15.0))
            .foregroundColor(.green)
        #endif

        return NSAttributedString {
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.bold))
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.italic))
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.condensed))
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.expanded))
            "SymbolicTraits 01234".localizedUppercase.attributedString(style: base.emphasizeStyle(.monoSpace))
        }

    }()

    static let dynamic: NSAttributedString = {
        let base: Style
        #if os(iOS) || os(tvOS) || os(watchOS)
        if #available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *) {
            #if os(iOS) || os(tvOS)
            base = Style()
                .font(custom)
                .lineHeightMultiple(1.2)
                .dynamicText(DynamicText(style: .body, maximumPointSize: 35, compatibleWith: UITraitCollection(userInterfaceIdiom: .phone)))
            #else
            base = Style()
                .font(custom)
                .lineHeightMultiple(1.2)
                .dynamicText(DynamicText(style: .body, maximumPointSize: 35))
            #endif
        } else {
            base = Style()
                .font(custom)
                .lineHeightMultiple(1.2)
        }
        #else
        base = Style()
            .font(custom)
            .lineHeightMultiple(1.2)
        #endif

        let string = "Hello, ceci estun texte anticonstitutionnellement tràs."

        return string.attributedString(style: base)
    }()

    static let stylisticAlternatives: NSAttributedString = {
        let string = "The quick brown fox jumps over the lazy dog."
        #if os(iOS)
        let font = Font(name: "HypatiaSansPro-Regular", size: 22)!
        #elseif os(OSX) || os(tvOS)
        let font = Font(name: "HypatiaSansPro-Regular", size: 26)!
        #else
        let font = Font(name: "HypatiaSansPro-Regular", size: 16)!
        #endif

        let style = Style()
            .foregroundColor(.black)
            .font(font)

        return NSAttributedString {
            string.attributedString(
                style: style.stylisticAlternatives(
                    [
                        .one, .two, .three, .four, .five,
                        .six, .seven, .eight, .nine, .ten,
                        .eleven, .twelve, .thirteen,
                    ]
                )
            )
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.one))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.two))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.three))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.four))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.five))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.six))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.seven))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.eight))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.nine))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.ten))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.eleven))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.twelve))
            "\n"
            string.attributedString(style: style.stylisticAlternatives(.thirteen))
        }
    }()

}
