//
//  DPTwitterViewCell.h
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTweetLabel;

@protocol DPTweetViewCellDelegate <NSObject>

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


@interface DPTweetViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorUsername;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet STTweetLabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *rtCount;
@property (weak, nonatomic) IBOutlet UILabel *favCount;
@property (weak, nonatomic) id <DPTweetViewCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *tweet;

- (IBAction)followPressed:(id)sender;
- (IBAction)replyPressed:(id)sender;
- (IBAction)retweetPressed:(id)sender;
- (IBAction)favouritePressed:(id)sender;
- (IBAction)authorPressed:(id)sender;
-(void)displayTweet:(NSDictionary *)tweet;
+(DPTweetViewCell *)newCell;

@end
