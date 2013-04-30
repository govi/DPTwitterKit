//
//  DPTweetDelegate.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DPTweetActionFollow,
    DPTweetActionReply,
    DPTweetActionRetweet,
    DPTweetActionFavourite,
    DPTweetActionAuthor,
    DPTweetActionMentions,
    DPTweetActionWeblink,
    DPTweetActionHashtag
} DPTweetAction;

@protocol DPTweetDelegate <NSObject>

-(BOOL)action:(DPTweetAction)action item:(NSString *)string;

@optional
-(void)presentViewController:(UIViewController *)controller;

@end