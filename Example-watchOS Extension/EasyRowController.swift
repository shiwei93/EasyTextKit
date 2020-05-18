//
//  EasyRowController.swift
//  Example-watchOS Extension
//
//  Created by shiwei on 2020/5/18.
//

import WatchKit

class EasyRowController: NSObject {
    
    @IBOutlet var textLabel: WKInterfaceLabel!
    
    var attributedString: NSAttributedString? {
        didSet {
            guard let attributedString = attributedString else { return }
            
            textLabel.setAttributedText(attributedString)
        }
    }
}
