//
//  DPTweetsCache.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTweetsCache.h"

@implementation DPTweetsCache

+(DPTweetsCache *)sharedCache {
    static DPTweetsCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[DPTweetsCache alloc] init];
    });
    return cache;
}

-(id) init {
    self = [super init];
    if(self) {
        tweetsCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSArray *)addTweets:(NSArray *)array {
    NSArray *idArray = [array valueForKeyPath:@"id_str"];
    for(NSDictionary *tweet in array) {
        [tweetsCache setObject:tweet forKey:[tweet objectForKey:@"id_str"]];
    }
    return idArray;
}

-(void) removeTweetsById:(NSArray *)idArray {
    for(NSString *tweetId in idArray) {
        [tweetsCache removeObjectForKey:tweetId];
    }
}

-(NSDictionary *)tweetWithId:(NSString *)idString {
    id obj = [tweetsCache objectForKey:idString];
    if(obj == NULL)
        NSLog(@"%@", idString);
    return obj;
}

-(void)updateTweet:(NSDictionary *)dict byId:(NSString *)idString {
    [tweetsCache setObject:dict forKey:idString];
}

@end
