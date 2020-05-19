//
//  InterfaceController.swift
//  Example-watchOS Extension
//
//  Created by shiwei on 2020/5/18.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!

    var examples: [NSAttributedString] = [
        Example.normal,
        Example.xmlSample,
        Example.emphasis,
        Example.digital,
        Example.superscript,
        Example.fraction,
        Example.scientificInferiors,
        Example.ligature,
        Example.kerning,
        Example.composition,
        Example.indention,
        Example.emphasisSet,
    ]

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        table.setNumberOfRows(examples.count, withRowType: "EasyRow")

        for index in 0..<table.numberOfRows {
            guard let controller = table.rowController(at: index) as? EasyRowController else {
                continue
            }

            controller.attributedString = examples[index]
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
