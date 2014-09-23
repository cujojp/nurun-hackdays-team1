//
//  ProximityServiceManager.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-21.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "ProximityServiceManager.h"
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXTransmitter.h>

@interface ProximityServiceManager () <FYXServiceDelegate>


@end

static ProximityServiceManager *_sharedManager = nil;
@implementation ProximityServiceManager

+ (instancetype)sharedManager
{
    {
        if(!_sharedManager)
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _sharedManager = [[ProximityServiceManager alloc] init];
                [_sharedManager prepare];
            });
        }
        return _sharedManager;
    }
}

#pragma mark - Private Methods

-(void)prepare
{
    [FYX startService:self];
    
}

#pragma mark - FYXSessionDelegate
- (void)sessionStarted
{
    NSLog(@"Proximity Manager: sessionStarted");
    [self proximityServiceManagerLog:@"Proximity Manager: sessionStarted"];

}

- (void)sessionCreateFailed:(NSError *)error
{
    NSString *log = [NSString stringWithFormat:@"Proximity Manager: session created failed %@", error.description];
    [self proximityServiceManagerLog:log];

}

- (void)sessionEnded
{
    
    NSString *log = [NSString stringWithFormat:@"Proximity Manager: session ended"];
    [self proximityServiceManagerLog:log];
    
}

- (void)sessionEndFailed:(NSError *)error
{
    NSString *log = [NSString stringWithFormat:@"Proximity Manager: session End failed %@", error.description];
    [self proximityServiceManagerLog:log];
}

- (void)sessionDataDeleted
{
    NSLog(@"Proximity Manager: session data deleted");
    NSString *log = [NSString stringWithFormat:@"Proximity Manager: session data deleted"];
    [self proximityServiceManagerLog:log];
}

- (void)sessionDataDeleteFailed:(NSError *)error
{
    NSString *log = [NSString stringWithFormat:@"Proximity Manager: session Data Delete  failed %@", error.description];
    [self proximityServiceManagerLog:log];
}



#pragma mark - FYXServiceDelegate

-(void)serviceStarted
{
    
    
    NSString *log = [NSString stringWithFormat:@"Proximity Manager: started"];
    [self proximityServiceManagerLog:log];
    
    
    [FYX enableLocationUpdates];
    
}

- (void)startServiceFailed:(NSError *)error
{

    NSString *log = [NSString stringWithFormat:@"Proximity Manager: failed %@", error.description];
    [self proximityServiceManagerLog:log];
}

//#pragma mark - FYXVisitDelegate
//- (void)didArrive:(FYXVisit *)visit;
//{
//    // this will be invoked when an authorized transmitter is sighted for the first time
//    NSString *log = [NSString stringWithFormat:@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name];
//    [self proximityServiceManagerLog:log];
//    
//}
//- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
//{
//    // this will be invoked when an authorized transmitter is sighted during an on-going visit
//    NSString *log = [NSString stringWithFormat:@"I received a sighting!!! %@", visit.transmitter.name];
////    [self proximityServiceManagerLog:log];
//}
//
//- (void)didDepart:(FYXVisit *)visit;
//{
//    // this will be invoked when an authorized transmitter has not been sighted for some time
//    NSString *log = [NSString stringWithFormat:@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name];
//    [self proximityServiceManagerLog:log];
//    
//    log = [NSString stringWithFormat:@"I was around the beacon for %f seconds", visit.dwellTime];
//    [self proximityServiceManagerLog:log];
//}

#pragma mark - Public methods

-(void)restartManager
{
    [self prepare];
}


-(void)proximityServiceManagerLog:(NSString*)logMessage
{
    NSLog(logMessage);

    if ([self.logDelegate respondsToSelector:@selector(proximityServiceManagerDidLog:)]) {
        [self.logDelegate proximityServiceManagerDidLog:logMessage];
    }
}

@end
