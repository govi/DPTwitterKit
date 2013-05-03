//
//  NSDictionary+Extensions.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extensions)

-(id)nullsafeValueForKeyPath:(NSString *)keyPath;
-(id)nullsafeObjectForKey:(NSString *)key;

@end
