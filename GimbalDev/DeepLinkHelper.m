//
//  DeepLinkHelper.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-29.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "DeepLinkHelper.h"

@implementation DeepLinkHelper

+(void)handleDeepLinkURL:(NSURL*)url
{
    //let's show a notification
    [LocalNotificationHelper displayNotificationWithString:@"Audemars Piguet. We have the 2014 Royal Oak Novelties at our NYC Boutique."];
}

@end
