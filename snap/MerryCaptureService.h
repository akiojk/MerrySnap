//
//  MerryCaptureService.h
//  snap
//
//  Created by Qiushi on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MerryEmptyWindowService;

@interface MerryCaptureService : NSObject
{
    id merrySnapDelegate;
    MerryEmptyWindowService *merryEmptyWindowService;
}

- (id) initWithMerrySnapDelegate: (id) delegate;
- (void) setOutputImage:(CGImageRef) outputImage; 
- (void) captureWithRectString: (NSString *) rectString;

@end
