//
//  state.swift
//  SpritzLib
//
//  Created by Richard Todd on 6/7/17.
//  Copyright © 2017 Richard Todd. All rights reserved.
//

import Foundation

public class State {
    var i, j, k, z, a, w : UInt8
    var mem : [UInt8]

    private func reset() {
        i = 0
        j = 0
        k = 0
        z = 0
        a = 0
        w = 1
        for index in 0..<256 {
            mem[index] = UInt8(index)
        }
    }
    
    public init() {
        i = 0
        j = 0
        k = 0
        z = 0
        a = 0
        w = 0
        mem = Array(repeating: 0, count: 256)
        reset()
    }
    

    private func memSwap(_ idx1: Int, with idx2: Int) {
        let tmp = mem[idx1]
        mem[idx1] = mem[idx2]
        mem[idx2] = tmp
    }

    private func crush() {
        for v in 0..<128 {
            if mem[v] > mem[255 - v] {
                memSwap(v, with: 255 - v)
            }
        }
    }
    
    private func update(times: Int) {
        var mi = i
        var mj = j
        var mk = k
        let mw = w
        
        for _ in 1...times {
            mi = (mi &+ mw)
            mj = mk &+ mem[Int(mj &+ mem[Int(mi)])]
            mk = mi &+ mk &+ mem[Int(mj)]
            memSwap(Int(mi), with: Int(mj))
        }
        
        i = mi
        j = mj
        k = mk
    }
    
    private func whip(times: Int) {
        update(times: times)
        w = w &+ 2
    }
    
    private func shuffle() {
        whip(times: 512); crush()
        whip(times: 512); crush()
        whip(times: 512)
        a = 0
    }
    
    private func absorb(nibble n: Int) {
        if a == 128 { shuffle() }
        memSwap(Int(a), with: 128 + n)
        a = a &+ 1
    }
    
    public func absorb(byte: UInt8) {
        absorb(nibble: Int(byte) & 0x0F)
        absorb(nibble: (Int(byte) >> 4) & 0x0F)
    }
    
    public func absorbStop() {
        if a == 128 { shuffle() }
        a = a &+ 1
    }
    
    public func absorb(number n: Int) {
        if n > 255 { absorb(number: (n >> 8)) }
        absorb(byte: UInt8(n & 0xFF))
    }
    
    public func soak(utf8: String) {
        for x in utf8.utf8 {
            absorb(byte: x)
        }
    }
    
    public func soak<T: Sequence>(seq: T) where T.Iterator.Element == UInt8 {
        for x in seq {
            absorb(byte: x)
        }
    }
  
    private func drip() -> UInt8 {
        // N.B. if a isn't 0 the caller must shuffle()!
        update(times: 1)
        z = mem[Int(j &+ mem[Int(i &+ mem[Int(z &+ k)])])]
        return z
    }
    
    
    public func skip(amount: Int) {
        if a > 0 { shuffle() }
        for _ in 1...amount {
            drip()
        }
    }
    
    public func squeeze(tgt: inout [UInt8]) {
        if a > 0 { shuffle() }
        for idx in 0..<tgt.count {
            tgt[idx] = drip()
        }
    }
    
    public func squeezeXOR(tgt: inout [UInt8], len: Int) {
        if a > 0 { shuffle() }
        for idx in 0..<len {
            tgt[idx] ^= drip()
        }
    }

    public func squeezeXOR(tgt: inout [UInt8]) {
        squeezeXOR(tgt: &tgt, len: tgt.count)
    }
    
}
