//
//  VisistManager.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-29.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "VisistManager.h"
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXSightingManager.h>

@interface VisistManager() <FYXVisitDelegate>
{
    FYXVisitManager *_visitManager;
}

@end

@implementation VisistManager

-(id)init
{
    self = [super init];
    if (self) {
        //create a visit manager
        _visitManager = [FYXVisitManager new];
        _visitManager.delegate = self;
        [_visitManager startWithOptions:[self defaultOptions]];
    }
    return self;
}

-(NSMutableDictionary*)defaultOptions
{
    NSMutableDictionary *options = [NSMutableDictionary new];
    [options setObject:[NSNumber numberWithInt:5] forKey:FYXVisitOptionDepartureIntervalInSecondsKey];
    [options setObject:[NSNumber numberWithInt:FYXSightingOptionSignalStrengthWindowNone] forKey:FYXSightingOptionSignalStrengthWindowKey];
    [options setObject:[NSNumber numberWithInt:-75] forKey:FYXVisitOptionArrivalRSSIKey];
    [options setObject:[NSNumber numberWithInt:-90] forKey:FYXVisitOptionDepartureRSSIKey];

    return options;
}

#pragma mark - FYXVisitDelegate
- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSString *log = [NSString stringWithFormat:@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name];
    [self visitManagerLog:log];
    
}
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    NSString *log = [NSString stringWithFormat:@"Saw transmitter %@ at strength %@", visit.transmitter.name, RSSI];
    [self visitManagerLog:log];
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSString *log = [NSString stringWithFormat:@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name];
    [self visitManagerLog:log];
    
    log = [NSString stringWithFormat:@"I was around the beacon for %f seconds", visit.dwellTime];
    [self visitManagerLog:log];
}

-(void)visitManagerLog:(NSString*)logMessage
{
    NSLog(logMessage);
}

@end
