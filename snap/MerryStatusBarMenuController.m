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
        [dropDownMainMenu setDelegate: self];
        
        merrySnapDelegate = delegate;
        [NSBundle loadNibNamed: @"MerryStatusBarMenu" owner:self]; 
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(newUserSignedIn:) name: NOTIFICATION_LOGGED_IN  object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(userHasSignedOut) name: NOTIFICATION_LOGGED_OUT  object: nil];
        
        NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSSquareStatusItemLength];
        NSImage *iconImage = [NSImage imageNamed: @"MerrySnapIcon24x24.png"];
        [iconImage setSize: NSMakeSize(24, 24)];
        NSImage *iconImageInv = [NSImage imageNamed: @"MerrySnapIcon24x24i.png"];
        [iconImageInv setSize: NSMakeSize(24, 24)];
        
        [statusItem setImage: iconImage];
        [statusItem setAlternateImage: iconImageInv];
        [statusItem setMenu: dropDownMainMenu];
        [statusItem setHighlightMode: YES];
        [statusItem retain];
        
    }
    
    return self;
}

- (void) newUserSignedIn: (NSNotification *) notification
{

}

- (void) userHasSignedOut
{

}

- (IBAction) aboutMerrySnapMenuItemClickedBy: (id) sender
{
    [NSApp orderFrontStandardAboutPanel: self];
    
//    [NSApp orderFrontStandardAboutPanelWithOptions:<#(NSDictionary *)#>];
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

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
    
    NSString *screen_name = [[NSUserDefaults standardUserDefaults] valueForKey: USER_DEFAULT_SCREEN_NAME];
    
    if(menuItem == signInMenuItem)
    {
        [menuItem setTitle: screen_name ? [NSString stringWithFormat: @"Signed in as %@", screen_name] : @"Sign in..."];
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
