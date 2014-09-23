//
//  ProximityServiceManager.h
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-21.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FYX/FYX.h>

@protocol ProximityServiceManagerLogDelegate <NSObject>

-(void)proximityServiceManagerDidLog:(NSString*)logMessage;

@end

@interface ProximityServiceManager : NSObject <FYXSessionDelegate>

+ (instancetype)sharedManager;
-(void)restartManager;

@property (nonatomic,weak) id<ProximityServiceManagerLogDelegate> logDelegate;

@end
