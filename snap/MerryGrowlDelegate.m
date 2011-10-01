//
//  MerryGrowlDelegate.m
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryGrowlDelegate.h"

#define CLICK_CONTEXT_SUCCESS @"click_context_success"
#define CLICK_CONTEXT_REAUTH @"click_context_reauth"

NSString *titleString = @"MerrySnap";

@implementation MerryGrowlDelegate

@synthesize picURLString;


- (id)init
{
    self = [super init];
    if (self) {
        
        [GrowlApplicationBridge setGrowlDelegate: self];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(postGrowlNotificationUploadSuccessful:) name: NOTIFICATION_UPLOAD_SUCCESS object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(postGrowlNotificationUploadFailed) name: NOTIFICATION_UPLOAD_FAILED object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(postGrowlNotificationLoggedIn:) name: NOTIFICATION_LOGGED_IN object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(postGrowlNotificationLoggedOut) name: NOTIFICATION_LOGGED_OUT object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(postGrowlNotificationRetryAuth) name: NOTIFICATION_PLEASE_RETRY_AUTH object: nil];
    }
    
    return self;
}

#pragma mark Growl Delegate Methods

- (void) growlNotificationTimedOut:(id)clickContext
{
    
}

- (void) growlNotificationWasClicked:(id)clickContext
{
 
    if([clickContext isEqual: CLICK_CONTEXT_SUCCESS])
    {
        [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: picURLString]];
    }
    else if([clickContext isEqual: CLICK_CONTEXT_REAUTH])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_RETRY_AUTH_GO object:nil];
    }
}

#pragma mark Growl Interaction Methods

- (void) postGrowlNotificationLoggedIn: (NSNotification *)notification
{
    NSString *descriptionString = [NSString stringWithFormat: @"Welcome %@! You are now logged in.\nTo start, press Command+Shift+5", [notification object]];
    [GrowlApplicationBridge notifyWithTitle: titleString
                                description: descriptionString
                           notificationName: @"Events"
                                   iconData: nil
                                   priority: 2
                                   isSticky: NO 
                               clickContext: nil];
}

- (void) postGrowlNotificationLoggedOut
{
    NSString *descriptionString = @"You are now logged out.";
    [GrowlApplicationBridge notifyWithTitle: titleString
                                description: descriptionString
                           notificationName: @"Events"
                                   iconData: nil
                                   priority: 2
                                   isSticky: NO 
                               clickContext: nil];
}

- (void) postGrowlNotificationRetryAuth
{
    NSString *descriptionString = @"Authentication is interrupted.\nTo restart, click MerrySnap icon and choose Log In.";
    [GrowlApplicationBridge notifyWithTitle: titleString
                                description: descriptionString
                           notificationName: @"Events"
                                   iconData: nil
                                   priority: 2
                                   isSticky: NO 
                               clickContext: nil]; // CLICK_CONTEXT_REAUTH = click to reauth
}

- (void) postGrowlNotificationUploadSuccessful: (NSNotification *) notification
{
    NSString *descriptionString = [NSString stringWithFormat: @"Upload was successful. URL has been sent to pasteboard.\n\n%@", [notification object]];
    [GrowlApplicationBridge notifyWithTitle: titleString
                                description: descriptionString
                           notificationName: @"Upload Finished"
                                   iconData: nil
                                   priority: 2
                                   isSticky: NO 
                               clickContext: CLICK_CONTEXT_SUCCESS];
    
}

- (void) postGrowlNotificationUploadFailed
{
    NSString *descriptionString = @"Upload failed.";
    [GrowlApplicationBridge notifyWithTitle: titleString
                                description: descriptionString
                           notificationName: @"Upload Failed"
                                   iconData: nil
                                   priority: 2
                                   isSticky: NO 
                               clickContext: nil];
    
}

@end
