//
//  Array+slice.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 25/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//
//  From: http://vperi.com/2014/06/04/slicing-arrays-in-swift/

import Foundation

extension Array {
  func slice(args: Int...) -> Array {
    var s = args[0]
    var e = self.count - 1
    if args.count > 1 { e = args[1] }
    
    if e < 0 {
      e += self.count
    }
    
    if s < 0 {
      s += self.count
    }
    
    let count = (s < e ? e-s : s-e)+1
    let inc = s < e ? 1 : -1
    var ret = Array()
    
    var idx = s
    for var i=0;i<count;i++  {
      ret.append(self[idx])
      idx += inc
    }
    return ret
  }
}