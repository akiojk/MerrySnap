//
//  MerryEmptyWindowView.h
//  snap
//
//  Created by Qiushi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface MerryEmptyWindowView : NSView
{
    NSPoint startingPoint;
    NSPoint endingPoint;
    
    BOOL hasMouseDragged;
    id merryEmptyWindowService;
    
    NSImage *cursorImage;
    
    
}

@property (nonatomic, retain) id merryEmptyWindowService;

@end
