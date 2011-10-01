//
//  MerryAuthWindowController.h
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "MerryCredentials.h"
#import "MerryUtil.h"

@interface MerryAuthWindowController : NSWindowController <NSWindowDelegate>
{
    IBOutlet NSWindow *merryAuthWindowWindow;
    IBOutlet WebView *merryAuthWindowWebView;
    IBOutlet NSView *merryLogoView;
    IBOutlet NSProgressIndicator *merryProgressIndicator;
    id merryAuthenticationService;
    
}

- (id)initWithMerryAuthenticationService: (id) delegate;
- (void) openAuthURL: (NSURL *) url;
- (void) postRetryAuthNotification;


@property (nonatomic, retain) NSWindow *merryAuthWindowWindow;
@property (nonatomic, retain) WebView *merryAuthWindowWebView;
@property (nonatomic, retain) NSView *merryLogoView;
@property (nonatomic, retain) NSProgressIndicator *merryProgressIndicator;

@end
