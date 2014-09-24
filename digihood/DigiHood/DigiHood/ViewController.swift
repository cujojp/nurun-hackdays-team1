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
    @IBOutlet weak var dontation: UILabel!
    @IBOutlet weak var callToAction: UILabel!
    @IBOutlet weak var moreInfo: UILabel!
    @IBOutlet weak var swipeCatcher: UIView!
    
    @IBOutlet weak var abeaconData: UILabel!
    @IBOutlet weak var marcusData: UILabel!
    @IBOutlet weak var robertaData: UILabel!
    @IBOutlet weak var tableView: UITableView!

//    let tapRec = UITapGestureRecognizer()
//    let pinchRec = UIPinchGestureRecognizer()
//    let swipeRec = UISwipeGestureRecognizer()
//    let longPressRec = UILongPressGestureRecognizer()
//    let rotateRec = UIRotationGestureRecognizer()
//    let panRec = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        swipeCatcher.addGestureRecognizer(swipeRec)
//        swipeRec.addTarget(self, action: "showConfirmation")
//        swipeCatcher.userInteractionEnabled = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    func showConfirmation() {
//        let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
//        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
//        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    func updateDataFor(beacon:CLBeacon) {
        var curLabel:UILabel!
        var detailLabel:String = "Major: \(beacon.major.integerValue), " +
            "Minor: \(beacon.minor.integerValue), " +
            "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
        
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
        
        switch beacon.proximityUUID.UUIDString {
        case "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6":
            // marcus
            detailLabel = "I am Marcus! I am " + proximityLabel + " " + detailLabel
            curLabel = marcusData
            break
        case "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA7":
            // abeacon
            detailLabel = "I am Abeacon! " + proximityLabel + " " + detailLabel
            curLabel = abeaconData
            break
        case "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA8":
            // roberta
        break
        default:
            break
        }
        curLabel.text = detailLabel
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
        
        let detailLabel:String = "Whois: \(beaconIdentifiers[indexPath.row].identifier) " +
            "UUID: \(beacon.proximityUUID.UUIDString)" +
            "Major: \(beacon.major.integerValue), " +
            "Minor: \(beacon.minor.integerValue), " +
            "RSSI: \(beacon.rssi as Int), "
        
        cell!.detailTextLabel?.text = detailLabel
        
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    
}