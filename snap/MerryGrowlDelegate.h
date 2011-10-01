//
//  MerryGrowlDelegate.h
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>
#import "MerryCredentials.h"

@interface MerryGrowlDelegate : NSObject <GrowlApplicationBridgeDelegate>
{
    NSString *picURLString;
}

- (void) postGrowlNotificationUploadSuccessful: (NSNotification *) notification;
- (void) postGrowlNotificationUploadFailed;


@property (nonatomic, retain) NSString *picURLString;
@end
