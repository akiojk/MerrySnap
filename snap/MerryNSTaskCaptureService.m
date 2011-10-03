//
//  MerryNSTaskCaptureService.m
//  snap
//
//  Created by Qiushi on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryNSTaskCaptureService.h"

@implementation MerryNSTaskCaptureService

- (id)initWithMerrySnapDelegate: (id) delegate
{
    self = [super init];
    if (self) {
        merrySnapDelegate = delegate;
        systemScreenCaptureTaskArguments = [[NSMutableArray alloc] initWithObjects:@"-c", @"-i", nil];
    }
    
    return self;
}

- (void) startCapture
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemCaptureFinishes) name:NSTaskDidTerminateNotification object:nil];
    systemScreenCaptureTask = [[NSTask alloc] init];
    [systemScreenCaptureTask setLaunchPath:@"/usr/sbin/screencapture"];
    [systemScreenCaptureTask setArguments: systemScreenCaptureTaskArguments];

    generalPasteBoardChangeCount = [[NSPasteboard generalPasteboard] changeCount];
    [systemScreenCaptureTask launch];
}

- (void) systemCaptureFinishes
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:nil];
    
    NSInteger currentGeneralPasteBoardChangeCount = [[NSPasteboard generalPasteboard] changeCount];
    if(currentGeneralPasteBoardChangeCount != generalPasteBoardChangeCount && [NSImage canInitWithPasteboard:[NSPasteboard generalPasteboard]])
    {
        generalPasteBoardChangeCount = currentGeneralPasteBoardChangeCount;
        
//        NSLog(@"successfully created. now fetching Pasteboard");
        NSImage *capturedImageFromPasteboard = [[NSImage alloc] initWithPasteboard: [NSPasteboard generalPasteboard]];
        NSBitmapImageRep *capturedImageRep = [[capturedImageFromPasteboard representations] objectAtIndex:0];
        NSData *capturedImageData = [capturedImageRep representationUsingType:NSPNGFileType properties:nil];
        
        [merrySnapDelegate performSelector:@selector(doUpload:) withObject: capturedImageData];
        
    }
    else
    {
        NSLog(@"User cancelled the saving.");
    }
}

@end
