//
//  MerryUploadService.m
//  snap
//
//  Created by Qiushi on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryUploadService.h"


@implementation MerryUploadService
@synthesize MerrySnapDelegate;

- (id)initWithMerrySnapDelegate: (id) merrySnapDelegate
{
    self = [super init];
    if (self) 
    {
        [self setMerrySnapDelegate: merrySnapDelegate];
        
        uploadAsiQueue = [[ASINetworkQueue alloc] init];
        [uploadAsiQueue setMaxConcurrentOperationCount:1];
        [uploadAsiQueue setShouldCancelAllRequestsOnFailure: NO];
        [uploadAsiQueue setDelegate: self];
        [uploadAsiQueue setRequestDidFailSelector: @selector(requestFailed:)];
        [uploadAsiQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    }
    
    return self;
}


- (void) uploadWithData: (NSData *) data OAToken: (OAToken *) token
{ 
    
    /*ASIFormDataRequest *uploadReq = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://twitpic.com/api/upload"]];
     [uploadReq addPostValue:@"4k1o" forKey:@"username"];
     [uploadReq addPostValue:@"m#r!NTMR" forKey:@"password"];
     [uploadReq addData:data forKey:@"media"];
     
     [uploadReq setRequestMethod:@"POST"];
     
     [uploadAsiQueue addOperation: uploadReq];
     [uploadAsiQueue go];*/
    
    NSURL *twitpicServiceURL = [NSURL URLWithString: @"http://api.twitpic.com/2/upload.json"];
    NSString *twitterProviderURLString = @"https://api.twitter.com/1/account/verify_credentials.json";
    
    OAConsumer *oaConsumer = [[OAConsumer alloc] initWithKey: TWITTER_CONSUMER_KEY secret: TWITTER_CONSUMER_SECRET];
    
    OARequestHeader *requestHeader = [[OARequestHeader alloc] initWithProvider: twitterProviderURLString
                                                                        method: @"GET" 
                                                                      consumer: oaConsumer
                                                                         token: token
                                                                         realm: @"http://api.twitter.com/"];
    
    NSString *oauthHeaders = [requestHeader generateRequestHeaders];
    
    // prepare date
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat: @"YYYY.MM.dd HH:mm"];
    NSString *currentDateString = [currentDateFormatter stringFromDate: [NSDate date]];
    
    ASIFormDataRequest *uploadReq = [ASIFormDataRequest requestWithURL: twitpicServiceURL];
    
    [uploadReq addRequestHeader: @"X-Verify-Credentials-Authorization" value: oauthHeaders];
    [uploadReq addRequestHeader: @"X-Auth-Service-Provider" value: twitterProviderURLString];
    [uploadReq addPostValue: TWITPIC_API_KEY forKey: @"key"];
    [uploadReq addPostValue: [NSString stringWithFormat: @"%@ by MerrySnap", currentDateString] forKey: @"message"];
    [uploadReq addData: data forKey: @"media"];
    
    [uploadReq setRequestMethod: @"POST"];
    
    [uploadAsiQueue addOperation: uploadReq];
    [uploadAsiQueue go];
    
    
}

- (void) requestFinished: (ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"responseString: %@", responseString);
    
    switch([request responseStatusCode])
    {
        case 200:
        {
            twitpicReturnResultSet = [[request responseString] yajl_JSON];
            NSString *resultURLString = [twitpicReturnResultSet valueForKey:@"url"];
            NSString *resultID = [twitpicReturnResultSet valueForKey:@"id"];
            
            NSLog(@"Getting URL: %@, id: %@", resultURLString, resultID);
            
            [[NSPasteboard generalPasteboard] clearContents];
            [[NSPasteboard generalPasteboard] declareTypes: [NSArray arrayWithObject: NSStringPboardType] owner:nil];
            [[NSPasteboard generalPasteboard] setString: resultURLString forType: NSStringPboardType];
            
            [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_UPLOAD_SUCCESS object: resultURLString];
            
            break;
            
        }
        case 400:
        {
            NSLog(@"Error 400 = Request Failed. Missing parameters.");
            [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_UPLOAD_FAILED object: nil];
            break;
        }
        default:
        {
            NSLog(@"Error Number Zero = Request Failed. ");
            [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_UPLOAD_FAILED object: nil];
            break;
        }
            
    }
    
}

- (void) requestFailed: (ASIHTTPRequest *) request
{
    NSString *responseString = [request responseString];
    NSLog(@"responseStringFailed: %@", responseString);
    
    switch([request responseStatusCode])
    {
        case 401:
        {
            NSLog(@"Error 401 = Twitter is down or auth took too long to complete");
            [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_UPLOAD_FAILED object: nil];
            
            break;
        }
        default:
        {
            NSLog(@"Error Unspecified = Something that has to be investigated with twitpic");
            [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_UPLOAD_FAILED object: nil];
            break;
        }
    }
}

@end
