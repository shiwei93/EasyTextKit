//
//  Example.swift
//  Example-iOS
//
//  Created by 施伟 on 2020/5/18.
//

import Foundation
import UIKit
import EasyTextKit

struct Example {
    
    static let normal: NSAttributedString = {
        let style = Style()
            .font(UIFont(name: "AvenirNextCondensed-Bold", size: 24)!)
            .alignment(.center)
            .lineSpacing(5)
            .tracking(.point(6))
            .foregroundColor(UIColor(red: 0.15, green: 0.4, blue: 0.86, alpha: 1.0))
        
        return "JUST SAMPLE".attributedString(style: style)
    }()
    
    static let xmlSample: NSAttributedString = {
        let xml = """
        I want to be different. If everyone is wearing <black>\u{00A0}black,\u{00A0}</black> I want to be wearing <red>\u{00A0}red.\u{00A0}</red>
        <signed>\u{2014}Maria Sharapova</signed> <racket/>
        
        """
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let style: Style
        if #available(iOS 11.0, *) {
            style = Style()
                .font(UIFont(name: "GillSans-Light", size: 18)!)
                .lineHeightMultiple(1.8)
                .foregroundColor(.darkGray)
                .dynamicText(DynamicText(style: .body, maximumPointSize: 35, compatibleWith: UITraitCollection(userInterfaceIdiom: .phone)))
        } else {
            style = Style()
                .font(UIFont(name: "GillSans-Light", size: 18)!)
                .lineHeightMultiple(1.8)
                .foregroundColor(.darkGray)
        }
        
        
        let accent = style
            .font(UIFont(name: "SuperClarendon-Black", size: 18)!)
        
        let black = accent
            .foregroundColor(.white)
            .backgroundColor(.black)
        
        let red = accent
            .foregroundColor(.white)
            .backgroundColor(color)
        
        let signed = accent
            .foregroundColor(color)
        
        let image = UIImage(named: "Tennis Racket")!
        let imageStyle = signed
            .baselineOffset(-4)
        let racket = image.attributedString(style: imageStyle)
        
        let group = XMLStyle(
            base: style,
            [
                "black": black,
                "red": red,
                "signed": signed,
                "racket": racket
            ]
        )
        
        return xml.attributedString(style: group)
    }()
    
    static let emphasis: NSAttributedString = {
        let string = """
        You can parse HTML with <strong>strong</strong>, <em>em</em>, <strong>and even <em>nested strong and em</em></strong> tags

        You can parse HTML with <strong>strong</strong>, <em>em</em>, <strong>and even <em>nested strong and em</em></strong> tags.
        """
        
        let base = Style()
            .font(.systemFont(ofSize: 17))
            .foregroundColor(.black)
        
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        
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
                "strong": strong
            ]
        )
        return string.attributedString(style: xmlStyle)
    }()
    
    static let digital: NSAttributedString = {
        let garamondStyle = Style()
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!)
            .lineHeightMultiple(1.2)
        
        let digits = "\n0123456789"
        
        let color = garamondStyle
            .smallCaps([.fromLowercase])
            .foregroundColor(UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0))
        
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
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!)
            .lineHeightMultiple(1.2)
            .numberCase(.upper)
        
        let string = "<name>Johnny</name> was a little boy, but <name>Johnny</name> is no more, for what he thought was <chemical>H<number>2</number>O</chemical> was really <chemical>H<number>2</number>SO<number>4</number></chemical>."
        
        let foregroundColor = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
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
                "number": number
            ]
        )
        return string.attributedString(style: style)
    }()
    
    // 分数
    static let fraction: NSAttributedString = {
        let garamondStyle = Style()
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!)
            .lineHeightMultiple(1.2)
            .numberCase(.upper)
        
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
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
                "normal": normalFraction
            ]
        )
        return string.attributedString(style: style)
    }()
    
    static let superscript: NSAttributedString = {
        let garamondStyle = Style()
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!)
            .lineHeightMultiple(1.2)
            
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
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
                "ordinal": ordinal
            ]
        )
        return string.attributedString(style: style)
    }()
    
    static let ligature: NSAttributedString = {
        let style = Style()
            .font(UIFont(name: "Zapfino", size: 24)!)
            .foregroundColor(UIColor(red: 0.82, green: 0.41, blue: 0.11, alpha: 1.0))
            .tracking(.point(6))
        
        let text = "Hello Swift!!!"
        
        return NSAttributedString {
            text.attributedString(style: style.ligature(.default))
            "\n"
            text.attributedString(style: style
                .ligature(.disabled))
            "\n"
        }
    }()
    
    static let images: NSAttributedString = {
        
        func accessibleImage(named name: String) -> UIImage {
            let image = UIImage(named: name)!
            image.accessibilityLabel = name
            return image
        }
        
        let bee = accessibleImage(named: "bee")
        let oar = accessibleImage(named: "oar")
        let knot = accessibleImage(named: "knot")
        
        let base = Style()
            .font(UIFont(name: "HelveticaNeue-Bold", size: 24)!)
        
        let style = base
            .baselineOffset(8)
        
        return NSAttributedString {
            "2".attributedString(style: style)
            bee
            oar
            knot
            "2".attributedString(style: style)
            bee
        }
    }()
    
    static let multiImages: NSAttributedString = {
        let base = Style()
            .font(.systemFont(ofSize: 17))
            .foregroundColor(.darkGray)
            .baselineOffset(10)
        
        return NSAttributedString {
            UIImage(named: "barn")!
            " "
            "This".attributedString(style: base)
            " "
            UIImage(named: "bee")!
            " "
            "string".attributedString(style: base)
            " "
            UIImage(named: "bug")!
            " "
            "is".attributedString(style: base)
            " "
            UIImage(named: "circuit")!
            " "
            "separated".attributedString(style: base)
            " "
            UIImage(named: "cut")!
            " "
            "by".attributedString(style: base)
            " "
            UIImage(named: "discount")!
            " "
            "images".attributedString(style: base)
            " "
            UIImage(named: "gift")!
            " "
            "and".attributedString(style: base)
            " "
            UIImage(named: "pin")!
            " "
            "spaces".attributedString(style: base)
            " "
            UIImage(named: "robot")!
            "\n"
        }
    }()
    
    static let kerning: NSAttributedString = {
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        let base = Style()
            .alignment(.center)
            .foregroundColor(color)
            .lineSpacing(20)
            .font(UIFont(name: "AvenirNext-Medium", size: 16)!)
        
        let phrase = """
            
        GO AHEAD,
        <large>MAKE
        MY
        DA<kern>Y.</kern></large>
        
        """
        
        let large = base
            .font(UIFont(name: "AvenirNext-Heavy", size: 64)!)
            .lineSpacing(40)
        
        let kern = large
            .tracking(.adobe(-80))
        
        let style = XMLStyle(
            base: base,
            [
                "large": large,
                "kern": kern
            ]
        )
        return phrase.attributedString(style: style)
    }()
    
    static let composition: NSAttributedString = {
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let base = Style()
            .alignment(.center)
        
        
        let preamble = base
            .font(UIFont(name: "AvenirNext-Bold", size: 14)!)
        
        
        let bigger = base
            .font(UIFont(name: "AvenirNext-Heavy", size: 64)!)
        
        let imageStyle = base
            .foregroundColor(color)
        
        let image = UIImage(named: "boat")!
        let boat = image.attributedString(style: imageStyle)
        
        return NSAttributedString {
            "\n\n"
            "You're going to need a\n".attributedString(style: preamble)
            "Bigger\n".localizedUppercase.attributedString(style: bigger)
            boat
            "\n\n"
        }
    }()
    
    static let indention: NSAttributedString = {
        let base = Style()
            .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!)
        
        
        let indention = base
            .firstLineHeadIndent(18)
            .paragraphSpacingBefore(9)
            .headIndent(30.78)
        
        
        
        let emoji = base
            .firstLineHeadIndent(18)
            .paragraphSpacingBefore(9)
            .headIndent(64.78)
        
        return NSAttributedString {
            "• You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.".attributedString(style: indention)
            "\n"
            "🍑 → You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.".attributedString(style: emoji)
            "\n"
        }
    }()
    
    static let emphasisSet: NSAttributedString = {
        
        let base = Style()
            .font(.systemFont(ofSize: 24.0))
            .foregroundColor(.systemGreen)
        
        return NSAttributedString {
            "加粗 "
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.bold))
            "斜体 "
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.italic))
            "压缩 "
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.condensed))
            "拉伸 "
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.expanded))
            "等宽 "
            "SymbolicTraits 01234\n".localizedUppercase.attributedString(style: base.emphasizeStyle(.monoSpace))
        }
        
    }()
    
    static let dynamic: NSAttributedString = {
        let base: Style
        if #available(iOS 11.0, *) {
            base = Style()
                .font(UIFont(name: "EBGaramond12-Regular", size: 24)!)
                .lineHeightMultiple(1.2)
                .dynamicText(DynamicText(style: .body, maximumPointSize: 35, compatibleWith: UITraitCollection(userInterfaceIdiom: .phone)))
        } else {
            base = Style()
                .font(UIFont(name: "EBGaramond12-Regular", size: 24)!)
                .lineHeightMultiple(1.2)
        }
        
        let string = "Hello, ceci estun texte anticonstitutionnellement tràs."
        
        return string.attributedString(style: base)
    }()
    
}
