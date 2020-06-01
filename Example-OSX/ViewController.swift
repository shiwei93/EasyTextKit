//
//  ViewController.swift
//  Example-OSX
//
//  Created by shiwei on 2020/5/18.
//

import Cocoa

// swiftlint:disable force_unwrapping
class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!

    var examples: [NSAttributedString] = [
        Example.normal,
        Example.xmlSample,
        Example.emphasis,
        Example.digital,
        Example.superscript,
        Example.fraction,
        Example.scientificInferiors,
        Example.stylisticAlternatives,
        Example.ligature,
        Example.kerning,
        Example.composition,
        Example.indention,
        Example.emphasisSet,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.headerView = nil
        tableView.selectionHighlightStyle = .none
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return examples.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier
        let cellView = tableView.makeView(withIdentifier: identifier!, owner: self) as? EasyTableCellView
        let attributedString = examples[row]
        cellView?.attributedString = attributedString
        return cellView
    }

    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        return false
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false
    }

}
