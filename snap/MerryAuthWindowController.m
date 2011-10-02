//
//  MerryAuthWindowController.m
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryAuthWindowController.h"

int windowWidth = 800;
int windowHeight = 750;

@implementation MerryAuthWindowController

@synthesize merryAuthWindowWindow;
@synthesize merryAuthWindowWebView;
@synthesize merryLogoView;
@synthesize merryProgressIndicator;

- (id)initWithMerryAuthenticationService: (id) delegate
{
    self = [super init];
    if (self) {
        
        [merryAuthWindowWindow orderOut: self];
        
        merryAuthenticationService = delegate;
        
        [NSBundle loadNibNamed:@"MerrySnapAuthWindow" owner:self];
        [merryAuthWindowWebView setFrameLoadDelegate: self];
        
        
        [merryAuthWindowWindow setStyleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask];
        
        [merryAuthWindowWindow setDelegate: self]; // this is purely to monitor when user closes merryAuthWindowWindow
        
        NSRect merryWindowWithMerryLogoViewRect = NSMakeRect([merryAuthWindowWindow frame].origin.x,
                                                             [merryAuthWindowWindow frame].origin.y,
                                                             [merryLogoView frame].size.width,
                                                             [merryLogoView frame].size.height);
        
        
        [merryProgressIndicator startAnimation: self]; // start progress bar
        
        [merryAuthWindowWindow setContentView: merryLogoView];
        [merryAuthWindowWindow makeKeyAndOrderFront: self];
        
        [merryAuthWindowWindow setFrame: merryWindowWithMerryLogoViewRect display:YES];
//        [merryAuthWindowWindow center];
        
    }
    
    return self;
}


- (void) windowDidLoad
{
    [super windowDidLoad];
}


- (void) openAuthURL: (NSURL *) url
{
    NSLog(@"we are opening url: %@", [url absoluteString]);
    
    [[merryAuthWindowWebView mainFrame] loadRequest: [NSURLRequest requestWithURL: url]];
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    // this means we finished loading twitter auth page. user will enter username/password and then jump to didReceiveServerRedir...
    
    //    NSRect merryWindowWithMerryAuthWindowWebViewRect = NSMakeRect([merryAuthWindowWindow frame].origin.x,
    //                                                                  [merryAuthWindowWindow frame].origin.y,
    //                                                                  [[[frame frameView] documentView] frame].size.width,
    //                                                                  [[[frame frameView] documentView] frame].size.height);
    
    
    NSRect merryWindowWithMerryAuthWindowWebViewRect = NSMakeRect( [merryAuthWindowWindow frame].origin.x + 0.5f*([merryLogoView frame].size.width - windowWidth),
                                                                  [merryAuthWindowWindow frame].origin.y + 0.5f*([merryLogoView frame].size.height - windowHeight),
                                                                  windowWidth,
                                                                  windowHeight);
    
    [[frame frameView] setAllowsScrolling: NO];
    
    //
    //    NSMutableDictionary *animDict = [NSMutableDictionary dictionaryWithCapacity: 2];
    //    [animDict setObject: merryLogoView forKey: NSViewAnimationTargetKey];
    //    [animDict setObject: NSViewAnimationFadeOutEffect forKey: NSViewAnimationEffectKey];
    //    
    //    NSViewAnimation *anim = [[NSViewAnimation alloc] initWithViewAnimations: [NSArray arrayWithObject: animDict]];
    //    [anim setDuration: 0.5];
    //    [anim startAnimation];
    
    
    [merryAuthWindowWindow setFrame: merryWindowWithMerryAuthWindowWebViewRect display: YES animate: YES];
    [merryAuthWindowWindow setContentView: merryAuthWindowWebView];
    
    
}



- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    NSURL *receivedURL = [[[frame provisionalDataSource] request] URL];
    NSLog(@"didstartprovisionalloadforframe. %@", [receivedURL absoluteString]);
    
    if ([[receivedURL absoluteString] hasPrefix: CALLBACK_URL_RETRY])
    {
        NSLog(@"user initial load/retrying");
    }
    else
    {
        if([[receivedURL absoluteString] hasPrefix: CALLBACK_URL_DENIED])
        {
            // prompt user that he has denied authorisation by popup or something.
            
            NSLog(@"denied. closing window.");
            
            [self postRetryAuthNotification];
            
        }
        else if([[receivedURL absoluteString] hasPrefix: CALLBACK_URL_PASSED])
        {
            NSLog(@"successfully authenticated. now finalizing authentication");
            
            NSString *oauthVerifier = [MerryUtil queryStringFromURL: receivedURL forKey: @"oauth_verifier"];
            
            NSLog(@"we got oauth verifier: %@", oauthVerifier);
            
            [merryAuthenticationService performSelector: @selector(fetchAccessTokenWithOAuthVerifier:) withObject: oauthVerifier]; // calling parent to grab access token
            
        } 
        else
        {
            // if url not known, open external safari and terminate authentication
            
            NSLog(@"redirecting to somewhere possibly outside the authentication flow: %@", [receivedURL absoluteString]);
            
            [[NSWorkspace sharedWorkspace] openURL: receivedURL]; // open external safari to avoid discouraging user
            
            [self postRetryAuthNotification];
            
        }
        
        [merryAuthWindowWebView setFrameLoadDelegate: nil]; // remove all delegates for a clean order out.
        
        [merryAuthWindowWindow orderOut: self];
    }
    
}




- (void) postRetryAuthNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_PLEASE_RETRY_AUTH object:nil];
}

#pragma mark NSWindowDelegate Method
- (void) windowWillClose:(NSNotification *)notification
{
    // NSWindowDelegateMethod
    NSLog(@"closing window");
//    [self postRetryAuthNotification];
}
/*
 
 - (void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame
 {
 NSURL *receivedURL = [[[frame provisionalDataSource] request] URL];
 
 NSLog(@"received server redirect: %@", [receivedURL absoluteString]);
 
 if([[receivedURL absoluteString] hasPrefix: FAKE_CALLBACK_URL_DENIED])
 {
 NSLog(@"User denied verification.");
 
 }
 else
 {
 NSLog(@"server redirecting to somewhere we don't handle yet: %@", [receivedURL absoluteString]);
 }
 
 [merryAuthWindowWindow orderOut: self]; // hides auth window
 }
 
 - (void)webView:(WebView *)sender willPerformClientRedirectToURL:(NSURL *)URL delay:(NSTimeInterval)seconds fireDate:(NSDate *)date forFrame:(WebFrame *)frame
 {
 
 // if user clicks NO, this method will be called and frame is redirecting to address http://www.flickr.com/
 
 NSLog(@"client redirect to url: %@", [URL absoluteString]);
 
 if([[URL absoluteString] hasPrefix: FAKE_CALLBACK_URL_PASSED])
 {
 NSLog(@"successfully authenticated. now finalizing authentication");
 
 NSString *oauthVerifier = [MerryUtil queryStringFromURL: URL forKey: @"oauth_verifier"];
 
 NSLog(@"we got oauth verifier: %@", oauthVerifier);
 
 [merryAuthenticationService performSelector: @selector(fetchAccessTokenWithOAuthVerifier:) withObject: oauthVerifier]; // calling parent to grab access token
 
 [merryAuthWindowWebView setFrameLoadDelegate: nil]; // remove all delegates for a clean order out.
 }
 else
 {
 NSLog(@"redirecting to somewhere? %@", [URL absoluteString]);
 }
 
 [merryAuthWindowWindow orderOut: self];
 }*/



@end
