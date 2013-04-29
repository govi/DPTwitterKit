//
//  TweetsListViewController.h
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPTweetViewCell.h"

@protocol DPTweetViewControllerDelegate <NSObject>

@optional
-(void)followPressed:(NSString *)userId;
-(void)replyPressed:(NSString *)tweetId;
-(void)retweetPressed:(NSString *)tweetId;
-(void)favouritePressed:(NSString *)tweetId;
-(void)authorPressed:(NSString *)userId;
-(void)mentionsOpened:(NSString *)userId;
-(void)weblinkOpened:(NSString *)userId;
-(void)hashtagOpened:(NSString *)hashtag;

@end


@interface DPTweetsListViewController : UIViewController <DPTweetViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *tweets;
@property (weak, nonatomic) id <DPTweetViewControllerDelegate> delegate;

+(DPTweetsListViewController *)controllerForTweets:(NSArray *)array;

@end
