//
//  BeaconDescriptor.swift
//  DigiHood
//
//  Created by Brian Kenny on 9/23/14.
//  Copyright (c) 2014 nurun. All rights reserved.
//

import Foundation

struct BeaconDescriptor {
    var beaconId:String
    var identifier:String
    init(uuid:String,identifier:String) {
        self.beaconId = uuid
        self.identifier = identifier
    }
}