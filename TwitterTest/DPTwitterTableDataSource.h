//
//  DPTwitterTableDataSource.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPTweetViewCell.h"

@protocol DPTweetViewDelegate <NSObject>

@optional
-(void)presentViewController:(UIViewController *)controller;
-(void)followPressed:(NSString *)userId;
-(void)replyPressed:(NSString *)tweetId;
-(void)retweetPressed:(NSString *)tweetId;
-(void)favouritePressed:(NSString *)tweetId;
-(void)authorPressed:(NSString *)userId;
-(void)mentionsOpened:(NSString *)username;
-(void)weblinkOpened:(NSString *)link;
-(void)hashtagOpened:(NSString *)hashtag;

@end

@interface DPTwitterTableDataSource : NSObject <UITableViewDataSource, DPTweetViewCellDelegate>

@property (nonatomic, strong) NSArray *tweets;
@property (weak, nonatomic) id<DPTweetViewDelegate> delegate;

+(DPTwitterTableDataSource *)datasourceWithTweets:(NSArray *)array;

@end
