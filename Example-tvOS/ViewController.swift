//
//  ViewController.swift
//  Example-tvOS
//
//  Created by shiwei on 2020/5/18.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var examples: [(String, [NSAttributedString])] = [
        ("Simply", [Example.normal]),
        ("XML", [
            Example.xmlSample,
            Example.emphasis,
        ]),
        ("Font Features", [
            Example.digital,
            Example.superscript,
            Example.fraction,
            Example.scientificInferiors,
            Example.stylisticAlternatives,
        ]),
        ("Ligature", [Example.ligature]),
        ("With Images", [
            Example.images,
            Example.multiImages,
        ]),
        ("Kerning", [Example.kerning]),
        ("Composition", [Example.composition]),
        ("Indention", [
            Example.indention,
        ]),
        ("Trait", [Example.emphasisSet]),
        ("Dynamic Text", [Example.dynamic]),
    ]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples[section].1.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return examples[section].0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let attributedText = examples[indexPath.section].1[indexPath.row]
        cell.textLabel?.attributedText = attributedText
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        return cell
    }

}
