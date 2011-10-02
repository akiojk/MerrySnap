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
        
        [dropDownMainMenu setAutoenablesItems: NO]; // We will take over the menu item enabling/disabling
        
        merrySnapDelegate = delegate;
        [NSBundle loadNibNamed: @"MerryStatusBarMenu" owner:self]; 
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(newUserSignedIn:) name: NOTIFICATION_LOGGED_IN  object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(userHasSignedOut) name: NOTIFICATION_LOGGED_OUT  object: nil];
        
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
    //TODO: Check if these setEnabled are still required after specifing the validateMenuItem stuff
    
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


// The following is declared in NSMenuValidation protocol. Our class must be the Target of the MenuItem to make it effect.
// Making our class target might be by making our class as NIB's File Owner & having MenuItem pointing to the IBActions

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
    
    NSString *screen_name = [[NSUserDefaults standardUserDefaults] valueForKey: USER_DEFAULT_SCREEN_NAME];
    
    if(menuItem == signInMenuItem)
    {
        [menuItem setTitle: [NSString stringWithFormat: @"Signed in as %@", screen_name]];
        return (screen_name == nil);    
    }
    else if(menuItem == signOutMenuItem)
    {
        return (screen_name != nil);
    }
    else
    {
        return YES;
    }
}

@end
