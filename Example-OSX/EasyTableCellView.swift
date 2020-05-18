//
//  EasyTableCellView.swift
//  Example-OSX
//
//  Created by shiwei on 2020/5/18.
//

import Cocoa

class EasyTableCellView: NSTableCellView {

    @IBOutlet weak var textLabel: NSTextField!
    
    var attributedString: NSAttributedString? {
        didSet {
            guard let attributedString = attributedString else { return }
            
            textLabel.attributedStringValue = attributedString
        }
    }
    
}
