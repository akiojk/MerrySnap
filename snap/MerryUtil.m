//
//  MerryUtil.m
//  snap
//
//  Created by Qiushi on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryUtil.h"

@implementation MerryUtil

+ (NSString *) queryStringFromURL: (NSURL *) URL forKey: (id) key
{
    NSArray *parameters = [[URL query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    
    NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [parameters count]; i=i+2) 
        [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
    
    return [keyValueParm objectForKey: key];
    
}
@end
