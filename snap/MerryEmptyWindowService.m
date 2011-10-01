//
//  MerryEmptyWindowService.m
//  snap
//
//  Created by Qiushi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryEmptyWindowService.h"

@implementation MerryEmptyWindowService

@synthesize merryCaptureServiceDelegate;

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:[[NSScreen mainScreen] frame] styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
      
    if (self)
    {
        // mewv uses a transparent CALayer to intercept all mouse events while keeping transparent.
        MerryEmptyWindowView *merryEmptyWindowView = [[MerryEmptyWindowView alloc] initWithFrame: [self frame]];
        [merryEmptyWindowView setMerryEmptyWindowService: self];
        
        [self setContentView: merryEmptyWindowView];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setOpaque:NO];
        [self setLevel: NSMainMenuWindowLevel + 1]; // make it above menubar
        [self makeKeyAndOrderFront: nil];        
    }
      
    return self;
}

- (void) captureWithRectString: (NSString *) rectString
{
    [merryCaptureServiceDelegate performSelector:@selector(captureWithRectString:) withObject: rectString];
}

@end
