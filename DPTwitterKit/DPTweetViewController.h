//
//  DPTweetViewController.h
//  EventGenie
//
//  Created by Govi on 02/05/2013.
//  Copyright (c) 2013 GenieMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPTweetDelegate.h"

@class STTweetLabel;

@interface DPTweetViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *thumbnail;
@property (retain, nonatomic) IBOutlet UILabel *authorName;
@property (retain, nonatomic) IBOutlet UILabel *authorUsername;
@property (retain, nonatomic) IBOutlet UIButton *followButton;
@property (retain, nonatomic) IBOutlet UILabel *timestamp;
@property (retain, nonatomic) IBOutlet UIButton *replyButton;
@property (retain, nonatomic) IBOutlet UIButton *retweetButton;
@property (retain, nonatomic) IBOutlet UIButton *favouriteButton;
@property (retain, nonatomic) IBOutlet UIView *separatorView;
@property (retain, nonatomic) IBOutlet STTweetLabel *descriptionText;
@property (strong, nonatomic) NSDictionary *tweet;
@property (assign, nonatomic) id<DPTweetDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIView *containerView;

- (IBAction)followPressed:(id)sender;
- (IBAction)replyPressed:(id)sender;
- (IBAction)retweetPressed:(id)sender;
- (IBAction)favouritePressed:(id)sender;

@end
