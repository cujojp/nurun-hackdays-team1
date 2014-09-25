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
    var application:UIApplication!
    var locationManager1: CLLocationManager?
    var locationManager2: CLLocationManager?
    var locationManager3: CLLocationManager?
    var lastMarcusProximity:CLProximity?
    var lastAbeaconProximity:CLProximity?
    var lastRobertaProximity:CLProximity?
    var lastProximity: CLProximity?
    
    var beaconIdentifiers: [BeaconDescriptor] = []
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.application = application
        
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

    func getNotificationDataFor() {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        let state = application.applicationState
        if (state == UIApplicationState.Inactive || state == UIApplicationState.Background) {
            // go to screen relevant to Notification content
            println("I GOT A MESSAGE FROM BACKGROUND STATE!!!")
            let viewController:ViewController = window!.rootViewController as ViewController
            viewController.logo.hidden = true

        } else {
            // App is in UIApplicationStateActive (running in foreground)
            // perhaps show an UIAlertView
            println("I GOT A MESSAGE FROM INTERNAL STATE!!!")
        }

    }

}

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!, whichBeacon:String?) {
        let notification:UILocalNotification = UILocalNotification()
        println("NOTIFICAITON MESSAGE: \(message)")
        var name = whichBeacon?
        if name == nil {
            name = "Hoody"
        }
        switch message {
            case "No beacons are nearby":
                break   
            case "You are far away from the beacon":
                break
            case "You are near the beacon":

                notification.alertBody = "\(name) says hello! Tap to see more"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                break
            case "You are in the immediate proximity of the beacon":
                notification.alertBody = "\(name) is very close to you! Tap to see more."
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                break
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.startUpdatingLocation()
        
        NSLog("You entered a region")
        sendLocalNotificationWithMessage("You entered a region", whichBeacon: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        NSLog("You exited a region")
        sendLocalNotificationWithMessage("You exited a region", whichBeacon: nil)
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            let viewController:ViewController = window!.rootViewController as ViewController
            var message:String = ""
            var curBeacon:String = ""
            
            let state = application.applicationState
            if (state == UIApplicationState.Inactive || state == UIApplicationState.Background) {
                // go to screen relevant to Notification content
                println("I GOT A MESSAGE FROM BACKGROUND STATE!!!")
                let viewController:ViewController = window!.rootViewController as ViewController
                viewController.logo.hidden = true
                
            } else {
                // App is in UIApplicationStateActive (running in foreground)
                // perhaps show an UIAlertView
                println("I GOT A MESSAGE FROM INTERNAL STATE!!!")
            }
            
            if(beacons.count > 0) {
                //println("beacons.count \(beacons.count)")
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon

                switch nearestBeacon.proximityUUID.UUIDString {
                    case "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6":
                    // marcus
                        if(lastMarcusProximity == nearestBeacon.proximity) {
                            return
                        }
                        curBeacon = "Marcus"
                        lastMarcusProximity = nearestBeacon.proximity
                    break
                    case "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA7":
                    // abeacon
                        if(lastAbeaconProximity == nearestBeacon.proximity) {
                            return
                        }
                        curBeacon = "Abeacon"
                        lastAbeaconProximity = nearestBeacon.proximity
                    break
                    case "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA8":
                    // roberta
                        if(lastRobertaProximity == nearestBeacon.proximity) {
                            return
                        }
                        curBeacon = "Roberta"
                        lastRobertaProximity = nearestBeacon.proximity
                    break
                    default:
                    break
                    
                }

                println("I am \(region.identifier)")
                println("I am the nearest beacon \(nearestBeacon.proximityUUID.UUIDString)")

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
                return
            }
            
            NSLog("%@", message)
            sendLocalNotificationWithMessage(message, whichBeacon: curBeacon)
    }
}