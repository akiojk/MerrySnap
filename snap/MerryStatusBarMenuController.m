//
//  MerryStatusBarMenuController.m
//  MerrySnap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryStatusBarMenuController.h"

@implementation MerryStatusBarMenuController

@synthesize aboutMerrySnapMenuItem;
@synthesize preferencesMenuItem;
@synthesize signInMenuItem;
@synthesize signOutMenuItem;
@synthesize terminateMenuItem;

@synthesize dropDownMainMenu;

- (id)initWithMerrySnapDelegate: (id) delegate
{
    self = [super init];
    if (self) {
        merrySnapDelegate = delegate;
        [NSBundle loadNibNamed: @"MerryStatusBarMenu" owner:self]; 
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(newUserSignedIn:) name: NOTIFICATION_LOGGED_IN  object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(userHasSignedOut) name: NOTIFICATION_LOGGED_OUT  object: nil];
        
        NSString *screen_name = [[NSUserDefaults standardUserDefaults] valueForKey: USER_DEFAULT_SCREEN_NAME];
        
        if (!screen_name) // user not logged in
        {
            [signInMenuItem setEnabled: YES];
            [signOutMenuItem setEnabled: NO];
        }
        else
        {
            [signInMenuItem setEnabled: NO];
            [signInMenuItem setTitle: [NSString stringWithFormat:@"Signed in as %@", screen_name]];
            [signOutMenuItem setEnabled: YES];
        }
        
        [dropDownMainMenu setAutoenablesItems: NO]; // We will take over the menu item enabling/disabling
        
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSSquareStatusItemLength];
        [statusItem setImage: [NSImage imageNamed: @"MerryIcon24x24.png"]];
        [statusItem setMenu: dropDownMainMenu];
        [statusItem setHighlightMode: YES];
        [statusItem retain];
    }
    
    return self;
}

- (void) newUserSignedIn: (NSNotification *) notification
{
    [signInMenuItem setEnabled: NO];
    [signInMenuItem setTitle: [NSString stringWithFormat:@"Signed in as %@", [notification object]]];
    [signOutMenuItem setEnabled: YES];
}

- (void) userHasSignedOut
{
    [signInMenuItem setEnabled: YES];
    [signInMenuItem setTitle: @"Sign in..."];
    [signOutMenuItem setEnabled: NO];
}

- (IBAction) aboutMerrySnapMenuItemClickedBy: (id) sender
{
    
}

- (IBAction) preferencesMenuItemClickedBy: (id) sender
{
    
    
}

- (IBAction) signInMenuItemClickedBy: (id) sender
{
    [merrySnapDelegate performSelector: @selector(startAuthentication) withObject: nil];
}

- (IBAction) signOutMenuItemClickedBy: (id) sender
{
    [merrySnapDelegate performSelector: @selector(removeKeyChainAndUserDefaults) withObject: nil];
}


- (IBAction) terminateMenuItemClickedBy: (id) sender
{
    [NSApp terminate: nil];
}

- (IBAction) orderFrontStandardAboutPanel: (id) sender
{
    
}
@end
