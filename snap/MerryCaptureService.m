//
//  MerryCaptureService.m
//  snap
//
//  Created by Qiushi on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryCaptureService.h"
#import "MerryEmptyWindowService.h"

#define kCGNullWindowID ((CGWindowID)0)

@implementation MerryCaptureService

- (id) initWithMerrySnapDelegate: (id) delegate
{
    self = [super init];
    if (self) 
    {
        merrySnapDelegate = delegate;
        
        merryEmptyWindowService = [[MerryEmptyWindowService alloc] init];
        [merryEmptyWindowService setMerryCaptureServiceDelegate: self];
        
    }
    
    return self;
}


- (void) setOutputImage:(CGImageRef) outputImage
{
    if(outputImage != nil)
    {
        NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage: outputImage];
        NSData *outputData ;
        outputData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];

//        [merrySnapDelegate performSelector:@selector(doUpload:) withObject:outputData];

        [outputData writeToFile:@"/Users/qiushi/Desktop/merrysnap.png" atomically:YES];
    }
}

- (void) captureWithRectString: (NSString *) rectString
{
//    CGImageRef screenShot = CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    CGRect targetRect = NSRectFromString(rectString);
    CGImageRef screenShot = CGWindowListCreateImage(targetRect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);

    [self setOutputImage: screenShot];
    
    CGImageRelease(screenShot);
}

@end
