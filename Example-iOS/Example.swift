//
//  Example.swift
//  Example-iOS
//
//  Created by shiwei on 2020/5/12.
//  Copyright © 2020 easy. All rights reserved.
//

import Foundation
import UIKit
import EasyTextKit

struct Example {
    
    static let normal: NSAttributedString = {
        let style = TextStyle {
            $0.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)!
            $0.alignment = .center
            $0.lineSpacing = 5
            $0.tracking = .point(6)
            $0.foregroundColor = UIColor(red: 0.15, green: 0.4, blue: 0.86, alpha: 1.0)
        }
        return "JUST SAMPLE".set(style: style)
    }()
    
    static let xmlSample: NSAttributedString = {
        let xml = """
        I want to be different. If everyone is wearing <black>\u{00A0}black,\u{00A0}</black> I want to be wearing <red>\u{00A0}red.\u{00A0}</red>
        <signed>\u{2014}Maria Sharapova</signed> <racket/>
        
        """
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let style = TextStyle {
            $0.font = UIFont(name: "GillSans-Light", size: 18)!
            $0.lineHeightMultiple = 1.8
            $0.foregroundColor = .darkGray
            if #available(iOS 11, *) {
                $0.dynamicText = DynamicText(style: .body, maximumPointSize: 35, compatibleWith: UITraitCollection(userInterfaceIdiom: .phone))
            }
        }
        
        let accent = style.adding {
            $0.font = UIFont(name: "SuperClarendon-Black", size: 18)!
        }
        
        let black = accent.adding {
            $0.foregroundColor = .white
            $0.backgroudColor = .black
        }
        
        let red = accent.adding {
            $0.foregroundColor = .white
            $0.backgroudColor = color
        }
        
        let signed = accent.adding {
            $0.foregroundColor = color
        }
        
        let image = UIImage(named: "Tennis Racket")!
        let imageStyle = signed.adding {
            $0.baselineOffset = -4
        }
        let racket = image.set(style: imageStyle)
        
        let group = XMLTextStyle(
            base: style,
            [
                "black": black,
                "red": red,
                "signed": signed,
                "racket": racket
            ]
        )
        
        return xml.set(style: group)
    }()
    
    static let emphasis: NSAttributedString = {
        let string = """
        You can parse HTML with <strong>strong</strong>, <em>em</em>, and even <strong><em>nested strong and em</em></strong> tags

        You can parse HTML with <strong>strong</strong>, <em>em</em>, and even <strong><em>nested strong and em</em></strong> tags.
        """
        
        let base = TextStyle {
            $0.font = .systemFont(ofSize: 17)
            $0.foregroundColor = .black
        }
        
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let em = base.adding {
            $0.foregroundColor = color
            $0.emphasizeStyle = .italic
        }
        
        let strong = base.adding {
            $0.foregroundColor = color
            $0.emphasizeStyle = .bold
        }
        
        let xmlStyle = XMLTextStyle(
            base: base,
            [
                "em": em,
                "strong": strong
            ]
        )
        return string.set(style: xmlStyle)
    }()
    
    static let digital: NSAttributedString = {
        let garamondStyle = TextStyle {
            $0.font = UIFont(name: "EBGaramond12-Regular", size: 24)!
            $0.lineHeightMultiple = 1.2
        }
        
        let digits = "\n0123456789"
        
        let color = garamondStyle.adding {
            $0.smallCaps = [.fromLowercase]
            $0.foregroundColor = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        }
        
        return NSAttributedString {
            "Number Styles".set(style: color)
            digits.set(style: garamondStyle.adding({
                $0.numberCase = .lower
                $0.numberSpacing = .monospaced
            }))
            digits.set(style: garamondStyle.adding({
                $0.numberCase = .upper
                $0.numberSpacing = .monospaced
            }))
            digits.set(style: garamondStyle.adding({
                $0.numberCase = .lower
                $0.numberSpacing = .proportional
            }))
            digits.set(style: garamondStyle.adding({
                $0.numberCase = .upper
                $0.numberSpacing = .proportional
            }))
        }
    }()
    
    // 科学符号
    static let scientificInferiors: NSAttributedString = {
        let garamondStyle = TextStyle {
            $0.font = UIFont(name: "EBGaramond12-Regular", size: 24)!
            $0.lineHeightMultiple = 1.2
            $0.numberCase = .upper
        }
        
        let string = "<name>Johnny</name> was a little boy, but <name>Johnny</name> is no more, for what he thought was <chemical>H<number>2</number>O</chemical> was really <chemical>H<number>2</number>SO<number>4</number></chemical>."
        
        let foregroundColor = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let name = garamondStyle.adding {
            $0.smallCaps.insert(.fromLowercase)
        }
        
        let chemical = garamondStyle.adding {
            $0.foregroundColor = foregroundColor
        }
        
        let number = chemical.adding {
            $0.scientificInferiors = true
        }
        
        let style = XMLTextStyle(
            base: garamondStyle,
            [
                "name": name,
                "chemical": chemical,
                "number": number
            ]
        )
        return string.set(style: style)
    }()
    
    // 分数
    static let fraction: NSAttributedString = {
        let garamondStyle = TextStyle {
            $0.font = UIFont(name: "EBGaramond12-Regular", size: 24)!
            $0.lineHeightMultiple = 1.2
            $0.numberCase = .upper
        }
        
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let string = """
        1336 <fraction>6/10</fraction> + <fraction>4/10</fraction> = 1337

        Normal:
            1336 <normal>6/10</normal> + <normal>4/10</normal> = 1337
        """
        
        let fraction = garamondStyle.adding {
            $0.fractions = .diagonal
            $0.numberCase = .lower
            $0.foregroundColor = color
        }
        
        let vfraction = garamondStyle.adding {
            $0.fractions = .vertical
            $0.numberCase = .lower
            $0.foregroundColor = color
        }
        
        let normalFraction = garamondStyle.adding {
            $0.fractions = .disabled
            $0.numberCase = .lower
            $0.foregroundColor = color
        }
        
        let style = XMLTextStyle(
            base: garamondStyle,
            [
                "fraction": fraction,
                "normal": normalFraction
            ]
        )
        return string.set(style: style)
    }()
    
    static let superscript: NSAttributedString = {
        let garamondStyle = TextStyle {
            $0.font = UIFont(name: "EBGaramond12-Regular", size: 24)!
            $0.lineHeightMultiple = 1.2
        }
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        let string = "Today is my <number>111<ordinal>th</ordinal></number> birthday!"
        
        let number = garamondStyle.adding {
            $0.foregroundColor = color
            $0.numberCase = .upper
        }
        
        let ordinal = garamondStyle.adding {
            $0.superscript = true
        }
        
        let style = XMLTextStyle(
            base: garamondStyle,
            [
                "number": number,
                "ordinal": ordinal
            ]
        )
        return string.set(style: style)
    }()
    
    static let ligature: NSAttributedString = {
        let style = TextStyle {
            $0.font = UIFont(name: "Zapfino", size: 24)!
            $0.foregroundColor = UIColor(red: 0.82, green: 0.41, blue: 0.11, alpha: 1.0)
            $0.tracking = .point(6)
        }
        
        let text = "Hello Swift!!!"
        
        return NSAttributedString {
            text.set(style: style.adding({ style in
                style.ligature = .default
            }))
            "\n"
            text.set(style: style.adding({ style in
                style.ligature = .disabled
            }))
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
        
        let base = TextStyle {
            $0.font = UIFont(name: "HelveticaNeue-Bold", size: 24)!
        }
        
        let style = base.adding {
            $0.baselineOffset = 8
        }
        
        return NSAttributedString {
            "2".set(style: style)
            bee
            oar
            knot
            "2".set(style: style)
            bee
        }
    }()
    
    static let multiImages: NSAttributedString = {
        let base = TextStyle {
            $0.font = .systemFont(ofSize: 17)
            $0.foregroundColor = .darkGray
            $0.baselineOffset = 10
        }
        
        return NSAttributedString {
            UIImage(named: "barn")!
            " "
            "This".set(style: base)
            " "
            UIImage(named: "bee")!
            " "
            "string".set(style: base)
            " "
            UIImage(named: "bug")!
            " "
            "is".set(style: base)
            " "
            UIImage(named: "circuit")!
            " "
            "separated".set(style: base)
            " "
            UIImage(named: "cut")!
            " "
            "by".set(style: base)
            " "
            UIImage(named: "discount")!
            " "
            "images".set(style: base)
            " "
            UIImage(named: "gift")!
            " "
            "and".set(style: base)
            " "
            UIImage(named: "pin")!
            " "
            "spaces".set(style: base)
            " "
            UIImage(named: "robot")!
            "\n"
        }
    }()
    
    static let kerning: NSAttributedString = {
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        let base = TextStyle {
            $0.alignment = .center
            $0.foregroundColor = color
            $0.lineSpacing = 20
            $0.font = UIFont(name: "AvenirNext-Medium", size: 16)!
        }
        
        let phrase = """
            
        GO AHEAD,
        <large>MAKE
        MY
        DA<kern>Y.</kern></large>
        
        """
        
        let large = base.adding {
            $0.font = UIFont(name: "AvenirNext-Heavy", size: 64)!
            $0.lineSpacing = 40
        }
        
        let kern = large.adding {
            $0.tracking = .adobe(-80)
        }
        
        let style = XMLTextStyle(
            base: base,
            [
                "large": large,
                "kern": kern
            ]
        )
        return phrase.set(style: style)
    }()
    
    static let composition: NSAttributedString = {
        let color = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        
        let base = TextStyle {
            $0.alignment = .center
        }
        
        let preamble = base.adding {
            $0.font = UIFont(name: "AvenirNext-Bold", size: 14)!
        }
        
        let bigger = base.adding {
            $0.font = UIFont(name: "AvenirNext-Heavy", size: 64)!
        }
        
        let image = UIImage(named: "boat")!
        let boat = image.set(style: base.adding { $0.foregroundColor = color })
        
        return NSAttributedString {
            "\n\n"
            "You're going to need a\n".set(style: preamble)
            "Bigger\n".localizedUppercase.set(style: bigger)
            boat
            "\n\n"
        }
    }()
    
    static let indention: NSAttributedString = {
        let base = TextStyle {
            $0.font = UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!
            $0.foregroundColor = .darkGray
        }
        
        let indention = base.adding {
            $0.firstLineHeadIndent = 18
            $0.paragraphSpacingBefore = 9
            $0.headIndent = 30.78
        }
        
        let emoji = base.adding {
            $0.firstLineHeadIndent = 18
            $0.paragraphSpacingBefore = 9
            $0.headIndent = 64.78
        }
        
        return NSAttributedString {
            "• You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.".set(style: indention)
            "\n"
            "🍑 → You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.".set(style: emoji)
            "\n"
        }
    }()
    
    static let emphasisSet: NSAttributedString = {
        
        let base = TextStyle {
            $0.font = .systemFont(ofSize: 24.0)
            $0.foregroundColor = .systemGreen
        }
        
        return NSAttributedString {
            "加粗 "
            "SymbolicTraits 01234\n".localizedUppercase.set(style: base.adding {
                $0.emphasizeStyle = .bold
            })
            "斜体 "
            "SymbolicTraits 01234\n".localizedUppercase.set(style: base.adding {
                $0.emphasizeStyle = .italic
            })
            "压缩 "
            "SymbolicTraits 01234\n".localizedUppercase.set(style: base.adding {
                $0.emphasizeStyle = .condensed
            })
            "拉伸 "
            "SymbolicTraits 01234\n".localizedUppercase.set(style: base.adding {
                $0.emphasizeStyle = .expanded
            })
            "等宽 "
            "SymbolicTraits 01234\n".localizedUppercase.set(style: base.adding {
                $0.emphasizeStyle = .monoSpace
            })
        }
        
    }()
    
    static let dynamic: NSAttributedString = {
        let base = TextStyle {
            $0.font = UIFont(name: "EBGaramond12-Regular", size: 24)!
            $0.lineHeightMultiple = 1.2
            if #available(iOS 11, *) {
                $0.dynamicText = DynamicText(style: .body, maximumPointSize: 35, compatibleWith: UITraitCollection(userInterfaceIdiom: .phone))
            }
        }
        
        let string = "Hello, ceci estun texte anticonstitutionnellement tràs."
        
        return string.set(style: base)
    }()
    
}
