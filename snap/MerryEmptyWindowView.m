//
//  MerryEmptyWindowView.m
//  snap
//
//  Created by Qiushi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryEmptyWindowView.h"

@implementation MerryEmptyWindowView

@synthesize merryEmptyWindowService;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        NSLog(@"view got frame: %@", NSStringFromRect(frame));
        NSTrackingArea *ta = [[NSTrackingArea alloc] initWithRect: [self bounds] options:NSTrackingMouseMoved|NSTrackingActiveAlways owner:self userInfo:nil];
        [self addTrackingArea: ta];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void) viewDidMoveToWindow
{
    // code from : http://www.natestedman.com/post/getting-mouse-events-from-a-transparent-nswindow/
    // We are adding a new CALayer to the View.
    // This CALayer intercepts everything while keeping itself as transparent,
    // which solves the problem that a transparent NSWindows passes all mouse events to windows behind.
    
    
    [self setWantsLayer: YES];
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    [[self layer] setOpacity: 0.0];
    [CATransaction commit];
    
    [NSCursor hide];
//    cursorImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"a" ofType:@"png"]];
    cursorImage = [NSImage imageNamed:@"a.png"];
    NSLog(@"event mouselocation: %@", NSStringFromPoint([NSEvent mouseLocation]));
    [cursorImage drawAtPoint: [NSEvent mouseLocation] fromRect: NSZeroRect  operation: NSCompositeSourceOver fraction:1.0];
    [self setNeedsDisplay: YES];
    
    
}

- (void) mouseMoved:(NSEvent *)theEvent
{
    NSLog(@"moved");
        [cursorImage drawAtPoint: [NSEvent mouseLocation] fromRect: NSZeroRect  operation: NSCompositeCopy fraction:1.0];
        NSLog(@"event mouselocation: %@", NSStringFromPoint([NSEvent mouseLocation]));
    [self setNeedsDisplay: YES];
}

#pragma mark Mouse Dragging, Clicking and Releasing Events - for Defining Capture Rects


- (void) mouseDragged:(NSEvent *)theEvent
{
    hasMouseDragged = YES;
    
    //    NSPoint event_loc = [theEvent locationInWindow];
    //    NSPoint local_pt = [self convertBaseToScreen: event_loc];
    //    NSLog(@"local_pt_for_dragged: %@", NSStringFromPoint(local_pt));
    
}

- (void) mouseDown:(NSEvent *)theEvent
{
    hasMouseDragged = NO;
    
    NSPoint event_loc = [theEvent locationInWindow];
    NSPoint local_pt = [[self window] convertBaseToScreen: event_loc];
    NSLog(@"local_pt_for_down: %@", NSStringFromPoint(local_pt));
    
    
    
    startingPoint = local_pt;
    
    
}

- (void) mouseUp:(NSEvent *)theEvent
{
    NSPoint event_loc = [theEvent locationInWindow];
    NSPoint local_pt = [[self window] convertBaseToScreen: event_loc];
    NSLog(@"local_pt_for_up: %@", NSStringFromPoint(local_pt));
    
    endingPoint = local_pt;
    
    
    if (hasMouseDragged)
    {
        CGRect captureRect = NSMakeRect((startingPoint.x < endingPoint.x? startingPoint.x : endingPoint.x), 
                                        [[NSScreen mainScreen] frame].size.height - (startingPoint.y > endingPoint.y? startingPoint.y : endingPoint.y),
                                        abs(startingPoint.x-endingPoint.x), 
                                        abs(startingPoint.y-endingPoint.y));
        
        NSLog(@"final rect:%@", NSStringFromRect(captureRect));
        
        [merryEmptyWindowService performSelector:@selector(captureWithRectString:) withObject: NSStringFromRect(captureRect)];
    }    
}


- (void) rightMouseDown:(NSEvent *)theEvent
{
    [NSCursor unhide];

    [merryEmptyWindowService performSelector:@selector(orderOut:) withObject:nil];
}

@end
