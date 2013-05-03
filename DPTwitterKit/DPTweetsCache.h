//
//  DPTweetsCache.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPTweetsCache : NSObject {
    NSMutableDictionary *tweetsCache;
}

+(DPTweetsCache *)sharedCache;
-(NSArray *) addTweets:(NSArray *)array;
-(NSDictionary *)tweetWithId:(NSString *)idString;
-(void) removeTweetsById:(NSArray *)idArray;
-(void) updateTweet:(NSDictionary *)dict byId:(NSString *)idString;
-(void)updateUser:(NSDictionary *)dict byId:(NSString *)idString;
-(NSDictionary *)userWithId:(NSString *)idString;

@end
