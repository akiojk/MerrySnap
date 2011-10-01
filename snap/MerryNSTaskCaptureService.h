//
//  MerryNSTaskCaptureService.h
//  snap
//
//  Created by Qiushi on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerryNSTaskCaptureService : NSObject
{
    id merrySnapDelegate;
    NSTask *systemScreenCaptureTask;
    NSMutableArray *systemScreenCaptureTaskArguments;
    NSString *fileNameWithTimeStamp;
    NSInteger generalPasteBoardChangeCount;
}

- (id)initWithMerrySnapDelegate: (id) delegate;
- (void) startCapture;
- (void) systemCaptureFinishes;

@end
