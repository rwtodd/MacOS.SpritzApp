//
//  utils.swift
//  SpritzLib
//
//  Created by Richard Todd on 6/8/17.
//  Copyright © 2017 Richard Todd. All rights reserved.
//

import Foundation

public func hash(string s: String, tgt: inout [UInt8]) {
    let st = State()
    st.soak(utf8: s)
    st.absorbStop()
    st.absorb(number: tgt.count)
    st.squeeze(tgt: &tgt)
}


public func hash(fileAtPath fp: String, tgt: inout [UInt8]) -> Bool {
    var buff : [UInt8] = Array(repeating: 0, count: (8*1024))
    let state = SpritzLib.State()
    
    if !FileManager.default.fileExists(atPath: fp) {
        return false
    }
    
    if let istr = InputStream(fileAtPath: fp) {
        istr.open()
        var actual = istr.read(&buff, maxLength: buff.count)
        while actual > 0 {
            state.soak(seq: buff[0..<actual])
            actual = istr.read(&buff, maxLength: buff.count)
        }
        istr.close()
        state.absorbStop()
        state.absorb(number: tgt.count)
        state.squeeze(tgt: &tgt)
        return true
    }
    return false
}
