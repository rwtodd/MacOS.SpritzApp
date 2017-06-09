//
//  hashresults.swift
//  Spritz
//
//  Created by Richard Todd on 6/8/17.
//  Copyright © 2017 Richard Todd. All rights reserved.
//

import Foundation
import Cocoa

private class SingleResult {
    let src: String
    let bits: Int
    let hash: String
    init(src s: String, bits b: Int, hash h: String) {
        src = s; bits = b; hash = h
    }
}

class HashResults : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    private var data: [SingleResult]
    
    public override init() {
        data = [SingleResult]()
        super.init()
    }
    
    public func add(src: String, bits: Int, hash: String) {
        let entry = SingleResult(src: src, bits: bits, hash: hash)
        data.append(entry)
    }

    public func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row >= data.count { return nil }
        let res = data[row]
        
        let cellid = tableColumn?.identifier ?? "???"
        if let vw = tableView.make(withIdentifier: cellid, owner: nil) as? NSTableCellView {
            switch tableColumn?.headerCell.title ?? "?" {
                case "Source":
                    vw.textField?.stringValue = res.src
                case "Bits":
                    vw.textField?.stringValue = String(res.bits)
                default:
                    vw.textField?.stringValue = res.hash
            }
            return vw
        }
        return nil
    }
    
}
