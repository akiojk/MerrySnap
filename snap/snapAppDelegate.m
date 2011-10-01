//
//  snapAppDelegate.m
//  snap
//
//  Created by Qiushi on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "snapAppDelegate.h"


@implementation snapAppDelegate

@synthesize window;
@synthesize accessToken;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    // since we are specifying LSUIELEMENT=1 to make the app Agent, this ensures that all windows pop out to the front rather than hid
    [NSApp activateIgnoringOtherApps: YES]; 

    
    // turn off the useless main window
    [[self window] orderOut: self];
    
    
    //    merryCaptureService = [[MerryCaptureService alloc] initWithMerrySnapDelegate:self];
    // Growl notifications
    merryGrowlDelegate = [[MerryGrowlDelegate alloc] init]; 
    
    // Set up statusmenu bar
    merryStatusBarMenuController = [[MerryStatusBarMenuController alloc] initWithMerrySnapDelegate: self];
    
    // Set up Hotkey
    hotkeyManager = [[JFHotkeyManager alloc] init];
    
    // direct the user for re-authentication shall fail
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(startAuthentication) name: NOTIFICATION_RETRY_AUTH_GO object:nil];
    
    NSLog(@"user default: %@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_SCREEN_NAME]);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_SCREEN_NAME]) // since there's no easy way to delete keychain token... we use userdefault check
    {
        [self startAuthentication];
        // start authentication
        
    }
    else
    {
        
        // try authentication
        
        //if authentication succeeds
        [self prepareForUse];
        
        //if authentication fails
        // drop credentials in keychain
        // re authenticate
    }
    
}

- (void) startAuthentication
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(prepareForUse) name: NOTIFICATION_LOGGED_IN object:nil]; // watch callbacks
    
    oaConsumer = [[OAConsumer alloc] initWithKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    merryAuthenticationService = [[MerryAuthenticationService alloc] initWithMerrySnapDelegate: self];
    
    [merryAuthenticationService startAuthenticationWithOAConsumer: oaConsumer OAToken: nil]; // accessToken is nil... we just want nil.
    
}

- (void) removeKeyChainAndUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: USER_DEFAULT_SCREEN_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: USER_DEFAULT_USER_ID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_LOGGED_OUT object: nil];
    
    // remove keybinding
    [hotkeyManager unbind: merryHotKeyRef];
    
}

- (void) prepareForUse
{
    accessToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:KEYCHAIN_SPNAME 
                                                                         prefix:KEYCHAIN_PREFIX];
    
    
    merryNSTaskCaptureService = [[MerryNSTaskCaptureService alloc] initWithMerrySnapDelegate: self];
    
    
    merryHotKeyRef = [hotkeyManager bind: @"command shift 5" 
                                  target: merryNSTaskCaptureService 
                                  action: @selector(startCapture)];
}

- (void) doUpload: (NSData *) uploadData
{
    NSLog(@"access token we got: key: %@ secret %@", [accessToken key], [accessToken secret]);
    merryUploadService = [[MerryUploadService alloc] initWithMerrySnapDelegate:self];
    [merryUploadService uploadWithData: uploadData OAToken: accessToken];
}


@end
