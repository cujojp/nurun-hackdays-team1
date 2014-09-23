//
//  ViewController.swift
//  DigiHood
//
//  Created by Brian Kenny on 9/23/14.
//  Copyright (c) 2014 nurun. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var beacons:[CLBeacon] = []
    var beaconIdentifiers:[BeaconDescriptor] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(beacons.count > 0) {
            return beacons.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MyIdentifier") as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyIdentifier")
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        let beacon:CLBeacon = beacons[indexPath.row]
        var proximityLabel:String! = ""
        
        switch beacon.proximity {
        case CLProximity.Far:
            proximityLabel = "Far"
            break
        case CLProximity.Near:
            proximityLabel = "Near"
            break
        case CLProximity.Immediate:
            proximityLabel = "Immediate"
            break
        default:
            break
        }
        
        cell!.textLabel?.text = proximityLabel
        
        let detailLabel:String = "Major: \(beacon.major.integerValue), " +
            "Minor: \(beacon.minor.integerValue), " +
            "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)" +
            "Internal name: \(beaconIdentifiers[0].beaconId)"
        cell!.detailTextLabel?.text = detailLabel
        
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    
}