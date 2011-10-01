//
//  MerryEmptyWindowService.h
//  snap
//
//  Created by Qiushi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MerryEmptyWindowView.h"

@interface MerryEmptyWindowService : NSWindow 
{
    id merryCaptureServiceDelegate;
}
- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag;
- (void) captureWithRectString: (NSString *) rectString;

@property (nonatomic, retain) id merryCaptureServiceDelegate;

@end
