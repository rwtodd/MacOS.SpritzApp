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

    @IBOutlet weak var resultsTbl: NSTableView!
    private let hr : HashResults
    
    @IBAction func doHash(_ sender: Any) {
        let nBytes = (Int(tgtBits.intValue) + 7) / 8
        var result : [UInt8] = Array(repeating: 0, count: nBytes)
        let srcPath = srcInput.stringValue
        
        DispatchQueue.global(qos: .userInitiated).async {
            if !SpritzLib.hash(fileAtPath: srcPath, tgt: &result) {
                // fall back on literal text hash...
                SpritzLib.hash(string: srcPath, tgt: &result)
            }
            let b64out = Data(bytesNoCopy: &result, count: result.count, deallocator: .none).base64EncodedString()
            DispatchQueue.main.async {
                self.hr.add(src: srcPath, bits: nBytes*8, hash: b64out)
                self.resultsTbl.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        hr = HashResults()
        super.init(coder: coder)
    }
    
    @IBOutlet weak var srcInput: NSTextField!
    @IBOutlet weak var tgtBits: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        srcInput.stringValue = "abc"
        tgtBits.intValue = 256
        resultsTbl.delegate = hr
        resultsTbl.dataSource = hr
        
        // Do any additional setup after loading the view.
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

