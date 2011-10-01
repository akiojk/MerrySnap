//
//  MerryUploadService.h
//  snap
//
//  Created by Qiushi on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import <OAuthConsumer/OAuthConsumer.h>
#import <YAJL/YAJL.h>
#import "MerryCredentials.h"
#import "OARequestHeader.h"

@interface MerryUploadService : NSObject 
{
    id MerrySnapDelegate;
    NSURLConnection *uploadConn;
    ASINetworkQueue *uploadAsiQueue;
    
    NSArray *twitpicReturnResultSet;
}

- (id)initWithMerrySnapDelegate: (id) merrySnapDelegate;

- (void) uploadWithData: (NSData *) data OAToken: (OAToken *) token;

@property (nonatomic, retain) id MerrySnapDelegate;

@end
