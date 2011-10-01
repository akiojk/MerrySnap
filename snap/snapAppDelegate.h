//
//  snapAppDelegate.h
//  snap
//
//  Created by Qiushi on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
//////////
// Josh Notes:
//
//  libz.1.2.3.dylib is essential
//  Background running is defined by LSUIElement = 1 in Info.plist

#import <Cocoa/Cocoa.h>

#import "MerryCaptureService.h"
#import "MerryUploadService.h"
#import "MerryNSTaskCaptureService.h"
#import "MerryAuthenticationService.h"
#import "MerryCredentials.h"

#import "MerryGrowlDelegate.h"
#import "MerryStatusBarMenuController.h"


#import <OAuthConsumer/OAuthConsumer.h>
#import "JFHotkeyManager.h"


@interface snapAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
//    MerryCaptureService *merryCaptureService;
    
    JFHotkeyManager *hotkeyManager;
    
    MerryUploadService *merryUploadService;
    MerryNSTaskCaptureService *merryNSTaskCaptureService;
    MerryAuthenticationService *merryAuthenticationService;
    
    MerryGrowlDelegate *merryGrowlDelegate;
    MerryStatusBarMenuController *merryStatusBarMenuController;
    
    OAToken *accessToken;
    OAConsumer *oaConsumer;

    IBOutlet NSMenu *statusMenu;
    
    JFHotKeyRef merryHotKeyRef;
    
    
}


- (void) doUpload: (NSData *)uploadData;
- (void) prepareForUse;
- (void) startAuthentication;
- (void) removeKeyChainAndUserDefaults;


@property (nonatomic, retain) OAToken *accessToken;

@property (assign) IBOutlet NSWindow *window;

@end
