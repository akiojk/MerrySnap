//
//  MerryAuthenticationService.m
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryAuthenticationService.h"


#define AUTH_STAGE_REQUEST_TOKEN 101
#define AUTH_STAGE_ACCESS_TOKEN 102

@implementation MerryAuthenticationService

@synthesize oaConsumer;
@synthesize oaToken;

- (id)initWithMerrySnapDelegate: (id) delegate
{
    self = [super init];
    if (self) {
        merrySnapDelegate = delegate;
    }
    
    return self;
}

- (void) startAuthenticationWithOAConsumer: (OAConsumer *) _oaConsumer OAToken: (OAToken *) _oaToken
{
    globalOAConsumer = _oaConsumer; // for global use
    
    merryAuthWindowController = [[MerryAuthWindowController alloc] initWithMerryAuthenticationService: self];
    
    currentAuthStage = AUTH_STAGE_REQUEST_TOKEN;
    
    OADataFetcher *oaDataFetcher = [[OADataFetcher alloc] init];
    
    OAMutableURLRequest *oaMutableURLRequest = [[OAMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"]
                                                                               consumer: globalOAConsumer 
                                                                                  token: _oaToken 
                                                                                  realm: nil
                                                                      signatureProvider: nil];
    [oaMutableURLRequest setHTTPMethod: @"POST"];
    
    [oaDataFetcher fetchDataWithRequest: oaMutableURLRequest 
                               delegate: self 
                      didFinishSelector: @selector(requestTokenTicket:didFinishWithData:)
                        didFailSelector: @selector(requestTokenTicket:didFailWithError:)];
    
    
}

- (void) fetchAccessTokenWithOAuthVerifier: (NSString *) verifier
{
    currentAuthStage = AUTH_STAGE_ACCESS_TOKEN;
    
    OADataFetcher *oaDataFetcher = [[OADataFetcher alloc] init];
    
    
    [globalOAToken setValue: verifier forKey:@"verifier"];
    
    NSLog(@"we are using these stuff to grab access token: key: %@\nsecret: %@\nverifier: %@", [globalOAToken key], [globalOAToken secret], [globalOAToken verifier]);
    
    OAMutableURLRequest *oaMutableURLRequest = [[OAMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://api.twitter.com/oauth/access_token"]
                                                                               consumer: globalOAConsumer 
                                                                                  token: globalOAToken
                                                                                  realm: nil 
                                                                      signatureProvider: nil];
    
    [oaMutableURLRequest setHTTPMethod: @"POST"];
    
    [oaDataFetcher fetchDataWithRequest: oaMutableURLRequest 
                               delegate: self 
                      didFinishSelector: @selector(requestTokenTicket:didFinishWithData:)
                        didFailSelector: @selector(requestTokenTicket:didFailWithError:)];
    
    
}


#pragma mark --- OAConsumer Delegates - --

- (void) requestTokenTicket: (OAServiceTicket *) ticket didFinishWithData:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog(@"responseBody: %@", responseBody);
    
    if([ticket didSucceed])
    {
        if(currentAuthStage == AUTH_STAGE_REQUEST_TOKEN)
        {
            globalOAToken = [[OAToken alloc] initWithHTTPResponseBody: responseBody];
            NSLog(@"requestToken: %@", [globalOAToken key]);
            
            [merryAuthWindowController openAuthURL: [NSURL URLWithString: 
                                                     [NSString stringWithFormat:
                                                      @"https://api.twitter.com/oauth/authorize?force_login=true&oauth_token=%@"
                                                      , [globalOAToken key]]]];
            
            // let MerryAuthWindowController handle the interaction, and pass back an oauth_verifier
            
            
        }
        else if(currentAuthStage == AUTH_STAGE_ACCESS_TOKEN)
        {
            globalOAToken = [[OAToken alloc] initWithHTTPResponseBody: responseBody];
            NSLog(@"Got accesstoken. Key = %@, Secret = %@", [globalOAToken key], [globalOAToken secret]);
            
//            [globalOAToken storeInUserDefaultsWithServiceProviderName: KEYCHAIN_SPNAME  prefix: KEYCHAIN_PREFIX];
            [globalOAToken storeInDefaultKeychainWithAppName: KEYCHAIN_PREFIX serviceProviderName:KEYCHAIN_SPNAME];
            
            NSURL *urlForValues = [NSURL URLWithString: [NSString stringWithFormat: @"http://ak.io/?%@", responseBody]];
            
            NSLog(@"we have screen_name=%@, user_id=%@", [MerryUtil queryStringFromURL: urlForValues forKey:@"screen_name"], [MerryUtil queryStringFromURL: urlForValues forKey:@"user_id"]);
            
            // save screen_name & stuff
            
            [[NSUserDefaults standardUserDefaults] setObject: [MerryUtil queryStringFromURL: urlForValues forKey:@"screen_name"] forKey:USER_DEFAULT_SCREEN_NAME];
            [[NSUserDefaults standardUserDefaults] setObject: [MerryUtil queryStringFromURL: urlForValues forKey:@"user_id"] forKey:USER_DEFAULT_USER_ID];
            [[NSUserDefaults standardUserDefaults] synchronize]; // force saving
            
            [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_LOGGED_IN object: [[NSUserDefaults standardUserDefaults] objectForKey: USER_DEFAULT_SCREEN_NAME]];
            
        }
    }
    
}

- (void) requestTokenTicket: (OAServiceTicket *) ticket didFailWithError:(NSData *)data
{
    NSLog(@"something went wrong.  ");
    [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_PLEASE_RETRY_AUTH object:nil]; 
    
}

@end
