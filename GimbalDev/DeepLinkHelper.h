//
//  DeepLinkHelper.h
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-29.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalNotificationHelper.h"

@interface DeepLinkHelper : NSObject

+(void)handleDeepLinkURL:(NSURL*)url;

@end
