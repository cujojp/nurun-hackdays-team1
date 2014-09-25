//
//  ViewController.swift
//  DigiHood
//
//  Created by Brian Kenny on 9/23/14.
//  Copyright (c) 2014 nurun. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var beacons:[CLBeacon] = []
    var beaconIdentifiers:[BeaconDescriptor] = []
    let serversDown:String = "http://digihood-webservice.herokuapp.com/api/update-beacon/"
    let localServer:String = "http://10.112.22.141:5000/api/update-beacon/"
    let MarcusId:String = "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"
    let RobertoId:String = "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA7"
    let Abeacon:String = "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA8"
    
    @IBOutlet weak var dontation: UILabel!
    @IBOutlet weak var callToAction: UILabel!
    @IBOutlet weak var moreInfo: UILabel!
    @IBOutlet weak var swipeCatcher: UIView!
    @IBOutlet weak var claimPrize: UIButton!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var noPrize: UILabel!
    @IBOutlet weak var abeaconData: UILabel!
    @IBOutlet weak var marcusData: UILabel!
    @IBOutlet weak var robertaData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBAction func submitPhoneNumber(sender: AnyObject) {
        let direction:String = "THANKS!"
        let more:String = "You should receive a text shortly with instructions."
        let session = NSURLSession.sharedSession()
        dontation.text = direction
        moreInfo.text = more
        submitButton.hidden = true
        phoneNumber.hidden = true
        
        println("!!!phoneNumber \(phoneNumber.text)")
        
        // create the request & response
        var request = NSMutableURLRequest(URL: NSURL(string: serversDown), cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        
        // create some JSON data and configure the request
        //let jsonString = "{\"id\":\"\(MarcusId)\",\"num\":1,\"str\":\"You are a bad ass\",\"num\":\"\(phoneNumber.text)\"}"
        let jsonString = "id=\(MarcusId)&phone=\(phoneNumber.text)"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        //application/x-www-form-urlencoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        println(jsonString)
        // send the request
        NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            println("HTTP response: \(httpResponse.statusCode)")
            println("Obj: \(httpResponse)")
        } else {
            println("No HTTP response")
        }

    }
    
    @IBAction func showRedemption(sender: AnyObject) {
        let direction:String = "GET YOUR PRIZE"
        let more:String = "Submit your phone number and  we’ll text you with redemption info."
        submitButton.hidden = false
        phoneNumber.hidden = false
        claimPrize.hidden = true
        dontation.text = direction
        moreInfo.text = more
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.hidden = true
        phoneNumber.hidden = true
        phoneNumber.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    func showConfirmation() {
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