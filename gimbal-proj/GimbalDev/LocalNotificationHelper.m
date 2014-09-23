//
//  LocalNotificationHelper.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-29.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "LocalNotificationHelper.h"

@implementation LocalNotificationHelper

+(void)displayNotificationWithString:(NSString *)notificationString
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    [notification setAlertBody:notificationString];
    [notification setFireDate:nil];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}

@end
