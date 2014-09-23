//
//  SightingManager.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-29.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "SightingManager.h"
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXTransmitter.h>

@interface SightingManager() <FYXSightingDelegate>
{
    FYXSightingManager *_sightingManager;
}

@end

@implementation SightingManager


-(id)init
{
    self = [super init];
    if (self) {
        _sightingManager = [[FYXSightingManager alloc] init];
        _sightingManager.delegate = self;
        [_sightingManager scan];
    }
    return self;
}

-(void)didReceiveSighting:(FYXTransmitter *)transmitter time:(NSDate *)time RSSI:(NSNumber *)RSSI
{
    
    NSString *log = [NSString stringWithFormat:@"Saw transmitter %@ at strength %@", transmitter.name, RSSI];
    [self sightingManagerLog:log];
    
}

-(void)sightingManagerLog:(NSString*)logMessage
{
    NSLog(logMessage);
}

@end
