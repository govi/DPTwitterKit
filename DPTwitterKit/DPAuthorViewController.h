//
//  DPAuthorViewController.h
//  TwitterTest
//
//  Created by Govi on 02/05/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPTweetDelegate.h"
#import "DPTweetsListViewController.h"

@class STTweetLabel;

@interface DPAuthorViewController : DPTweetsListViewController

@property (strong, nonatomic) NSDictionary *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweets;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) id<DPTweetDelegate> delegate;
@property (weak, nonatomic) IBOutlet STTweetLabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (strong, nonatomic) IBOutlet UIView *headerView;

- (IBAction)followPressed:(id)sender;

@end
