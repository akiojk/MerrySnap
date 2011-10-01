//
//  MerryStatusBarMenuController.h
//  MerrySnap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerryCredentials.h"

@interface MerryStatusBarMenuController : NSObject
{
    IBOutlet NSMenuItem *aboutMerrySnapMenuItem;
    IBOutlet NSMenuItem *preferencesMenuItem;
    IBOutlet NSMenuItem *signInMenuItem;
    IBOutlet NSMenuItem *signOutMenuItem;
    IBOutlet NSMenuItem *terminateMenuItem;
    
    IBOutlet NSMenu *dropDownMainMenu;
    
    id merrySnapDelegate;
    
}
- (id)initWithMerrySnapDelegate: (id) delegate;

- (IBAction) aboutMerrySnapMenuItemClickedBy: (id) sender;
- (IBAction) preferencesMenuItemClickedBy: (id) sender;
- (IBAction) signInMenuItemClickedBy: (id) sender;
- (IBAction) signOutMenuItemClickedBy: (id) sender;
- (IBAction) terminateMenuItemClickedBy: (id) sender;

@property (nonatomic, retain) NSMenuItem *aboutMerrySnapMenuItem;
@property (nonatomic, retain) NSMenuItem *preferencesMenuItem;
@property (nonatomic, retain) NSMenuItem *signInMenuItem;
@property (nonatomic, retain) NSMenuItem *signOutMenuItem;
@property (nonatomic, retain) NSMenuItem *terminateMenuItem;
@property (nonatomic, retain) NSMenu *dropDownMainMenu;

@end
