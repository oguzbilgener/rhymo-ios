//
//  Array+Shuffle.swift
//  Rhymo
//
//  Created by Oguz Bilgener on 27/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//
//  From: https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3

import Foundation

extension Array
{
  /** Randomizes the order of an array's elements. */
  mutating func shuffle()
  {
    for _ in 0..<10
    {
      sort { (_,_) in arc4random() < arc4random() }
    }
  }
}