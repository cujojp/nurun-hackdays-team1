//
//  AppDelegate.swift
//  DigiHood
//
//  Created by Brian Kenny on 9/23/14.
//  Copyright (c) 2014 nurun. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager1: CLLocationManager?
    var locationManager2: CLLocationManager?
    var locationManager3: CLLocationManager?
    var lastProximity: CLProximity?
    var beaconIdentifiers: [BeaconDescriptor] = []
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        // setup beacons
        var b1:BeaconDescriptor = BeaconDescriptor(uuid:"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", identifier:"Marcus")
        var b2:BeaconDescriptor = BeaconDescriptor(uuid:"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA7", identifier:"Abeacon")
        var b3:BeaconDescriptor = BeaconDescriptor(uuid:"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA8", identifier:"Roberta")
        
        beaconIdentifiers.append(b1)
        beaconIdentifiers.append(b2)
        beaconIdentifiers.append(b3)
        
        // REGION 1
        var b1ID = b1.beaconId
        var b1String = b1.identifier
        var uid1 = NSUUID(UUIDString: b1ID)
        let beaconRegion1:CLBeaconRegion = CLBeaconRegion(proximityUUID: uid1, identifier: b1String)
        
        // initialize beacon manager
        locationManager1 = CLLocationManager()
        if(locationManager1!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager1!.requestAlwaysAuthorization()
        }
        
        locationManager1!.delegate = self
        locationManager1!.pausesLocationUpdatesAutomatically = false
        locationManager1!.startMonitoringForRegion(beaconRegion1)
        locationManager1!.startRangingBeaconsInRegion(beaconRegion1)
        locationManager1!.startUpdatingLocation()
        
        // REGION 2
        var b2ID = b2.beaconId
        var b2String = b2.identifier
        var uid2 = NSUUID(UUIDString: b2ID)
        let beaconRegion2:CLBeaconRegion = CLBeaconRegion(proximityUUID: uid2, identifier: b2String)
        // initialize beacon manager
        locationManager2 = CLLocationManager()
        if(locationManager2!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager2!.requestAlwaysAuthorization()
        }
        
        locationManager2!.delegate = self
        locationManager2!.pausesLocationUpdatesAutomatically = false
        locationManager2!.startMonitoringForRegion(beaconRegion2)
        locationManager2!.startRangingBeaconsInRegion(beaconRegion2)
        locationManager2!.startUpdatingLocation()

        // REGION 3
        var b3ID = b3.beaconId
        var b3String = b3.identifier
        var uid3 = NSUUID(UUIDString: b3ID)
        let beaconRegion3:CLBeaconRegion = CLBeaconRegion(proximityUUID: uid3, identifier: b3String)
        // initialize beacon manager
        locationManager3 = CLLocationManager()
        if(locationManager3!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager3!.requestAlwaysAuthorization()
        }
        
        locationManager3!.delegate = self
        locationManager3!.pausesLocationUpdatesAutomatically = false
        locationManager3!.startMonitoringForRegion(beaconRegion3)
        locationManager3!.startRangingBeaconsInRegion(beaconRegion3)
        locationManager3!.startUpdatingLocation()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.startUpdatingLocation()
        
        NSLog("You entered a region")
        sendLocalNotificationWithMessage("You entered a region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        NSLog("You exited a region")
        sendLocalNotificationWithMessage("You exited a region")
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            let viewController:ViewController = window!.rootViewController as ViewController
            //viewController.beacons = beacons as [CLBeacon]
            //viewController.beaconIdentifiers = beaconIdentifiers

            //viewController.tableView.reloadData()
            
            println("I am \(region.identifier)")
            
            var message:String = ""
            
            if(beacons.count > 0) {
                //println("beacons.count \(beacons.count)")
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon

//                if(nearestBeacon.proximity == lastProximity ||
//                nearestBeacon.proximity == CLProximity.Unknown) {
//                    return
//                }

                println("nearest beacon \(nearestBeacon.proximityUUID.UUIDString)")
//                lastProximity = nearestBeacon.proximity

                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    message = "You are far away from the beacon"
                case CLProximity.Near:
                    message = "You are near the beacon"
                case CLProximity.Immediate:
                    message = "You are in the immediate proximity of the beacon"
                case CLProximity.Unknown:
                    return
                }
                
                viewController.updateDataFor(nearestBeacon)
            } else {
                message = "No beacons are nearby"
            }
            
            
            NSLog("%@", message)
            sendLocalNotificationWithMessage(message)
    }
}