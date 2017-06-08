//
//  ViewController.swift
//  Spritz
//
//  Created by Richard Todd on 6/7/17.
//  Copyright © 2017 Richard Todd. All rights reserved.
//

import Cocoa
import SpritzLib

class ViewController: NSViewController {

    @IBAction func valChanged(_ sender: NSTextField) {

        let nBytes = (Int(tgtBits.intValue) + 7) / 8
        var result : [UInt8] = Array(repeating: 0, count: nBytes)
        if !SpritzLib.hash(fileAtPath: srcInput.stringValue, tgt: &result) {
            // fall back on literal text hash...
            SpritzLib.hash(string: srcInput.stringValue, tgt: &result)
        }
        tgtOutput.string =  Data(bytesNoCopy: &result, count: result.count, deallocator: .none).base64EncodedString()
        
    }
    
    @IBOutlet var tgtOutput: NSTextView!
    @IBOutlet weak var srcInput: NSTextField!
    @IBOutlet weak var tgtBits: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        srcInput.stringValue = "abc"
        tgtBits.intValue = 256
        valChanged(srcInput)
        
        // Do any additional setup after loading the view.
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

