//
//  Logger.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 07/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import Foundation

func log (string: String, filename: NSString = __FILE__) {
    NSLog("\(filename.lastPathComponent): \(string)")
}

