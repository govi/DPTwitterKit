//
//  DPTweetDelegate.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDPTweetsAvailableNotification @"new tweets"
#define kDPTweetsUpdatedNotification @"upd tweets"
#define kDPUserUpdatedNotification @"upd user"

typedef enum {
    DPTweetActionFollow,
    DPTweetActionReply,
    DPTweetActionRetweet,
    DPTweetActionFavourite,
    DPTweetActionAuthor,
    DPTweetActionMentions,
    DPTweetActionWeblink,
    DPTweetActionHashtag,
    DPTweetActionOpenTweet
} DPTweetAction;

@class DPTwitterTableDataSource;

@protocol DPTweetDelegate <NSObject>

-(BOOL)tweet:(NSString *)tweetId action:(DPTweetAction)action item:(NSString *)string;

@optional
-(void)presentViewController:(UIViewController *)controller;

@end