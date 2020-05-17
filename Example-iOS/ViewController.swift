//
//  ViewController.swift
//  Example-iOS
//
//  Created by 施伟 on 2020/5/17.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var examples: [(String, [NSAttributedString])] = [
        ("简单使用", [Example.normal]),
        ("XML", [
            Example.xmlSample,
            Example.emphasis
        ]),
        ("设置了 Font Features 示例", [
            Example.digital,
            Example.superscript,
            Example.fraction,
            Example.scientificInferiors
        ]),
        ("Ligature", [Example.ligature]),
        ("各种 Image", [
            Example.images,
            Example.multiImages
        ]),
        ("Kerning", [Example.kerning]),
        ("Composition", [Example.composition]),
        ("缩进排版", [
            Example.indention
        ]),
        ("Trait", [Example.emphasisSet]),
        ("Dynamic Text", [Example.dynamic])
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

