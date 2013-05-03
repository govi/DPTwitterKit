//
//  NSDictionary+Extensions.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

-(id)nullsafeValueForKeyPath:(NSString *)keyPath {
    id val = [self valueForKeyPath:keyPath];
    if([val isEqual:[NSNull null]])
        return nil;
    return val;
}

-(id)nullsafeObjectForKey:(NSString *)key {
    id val = [self objectForKey:key];
    if([val isEqual:[NSNull null]])
        return nil;
    return val;
}

@end
