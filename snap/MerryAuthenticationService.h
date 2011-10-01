//
//  MerryAuthenticationService.h
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerryAuthWindowController.h"
#import <OAuthConsumer/OAuthConsumer.h>
#import "MerryCredentials.h"

@interface MerryAuthenticationService : NSObject
{
    id merrySnapDelegate;
    MerryAuthWindowController *merryAuthWindowController;
    OAToken *globalOAToken;
    OAConsumer *globalOAConsumer;
    
    NSInteger currentAuthStage;
}

- (id)initWithMerrySnapDelegate: (id) delegate;

- (void) startAuthenticationWithOAConsumer: (OAConsumer *) _oaConsumer OAToken: (OAToken *) _oaToken;
- (void) fetchAccessTokenWithOAuthVerifier: (NSString *) verifier;

@property (nonatomic, retain) OAToken *oaToken;
@property (nonatomic, retain) OAConsumer *oaConsumer;

@end
