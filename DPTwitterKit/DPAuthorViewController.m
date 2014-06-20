//
//  DPAuthorViewController.m
//  TwitterTest
//
//  Created by Govi on 02/05/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPAuthorViewController.h"
#import "NSDictionary+Extensions.h"
#import "UIColor+Extras.h"
#import <UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import "STTweetLabel.h"
#import "DPTweetsCache.h"

@interface DPAuthorViewController ()

@end

@implementation DPAuthorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self decorate];
    [self loadUserInformation];
    [self.listView setTableHeaderView:self.headerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUser) name:kDPUserUpdatedNotification object:nil];
}

-(void)refreshUser {
    self.user = [[DPTweetsCache sharedCache] userWithId:[self.user objectForKey:@"screen_name"]];
    [self loadUserInformation];
}

-(void)decorate {
    __block DPAuthorViewController *c = self;
    [self.descriptionText setCallbackBlock:^(STLinkActionType actionType, NSString *link) {
        // determine what the user clicked on
        switch (actionType) {
                // if the user clicked on an account (@_max_k)
            case STLinkActionTypeAccount:
                if(c.delegate && [c.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [c.delegate tweet:nil action:DPTweetActionMentions item:link];
                break;
                
                // if the user clicked on a hashtag (#thisisreallycool)
            case STLinkActionTypeHashtag:
                if(c.delegate && [c.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [c.delegate tweet:nil action:DPTweetActionHashtag item:link];
                break;
                
                // if the user clicked on a website (http://github.com/SebastienThiebaud)
            case STLinkActionTypeWebsite:
                if(c.delegate && [c.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [c.delegate tweet:nil action:DPTweetActionWeblink item:link];
                break;
        }
    }];
    
    self.avatar.layer.cornerRadius = 5.0;
    self.avatar.clipsToBounds = YES;
    self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatar.layer.borderWidth = 3.0;
}

-(void)loadUserInformation {
    self.favorites.text = [NSString stringWithFormat:@"%d", [[self.user objectForKey:@"favorites_count"] intValue]];
    self.followers.text = [NSString stringWithFormat:@"%d", [[self.user objectForKey:@"followers_count"] intValue]];
    self.following.text = [NSString stringWithFormat:@"%d", [[self.user objectForKey:@"friends_count"] intValue]];
    self.username.text = [self.user objectForKey:@"name"];
    self.profileBackground.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"0x%@", [self.user objectForKey:@"profile_background_color"]]];
    [self.profileBackground setImageWithURL:[NSURL URLWithString:[[self.user objectForKey:@"profile_banner_url"] stringByAppendingString:@"/mobile_retina"]]];
    [self.avatar setImageWithURL:[NSURL URLWithString:[[self.user objectForKey:@"profile_image_url"] stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]]];
    self.tweets.text = [NSString stringWithFormat:@"%d", [[self.user objectForKey:@"statuses_count"] intValue]];
    self.locationText.text = [self.user nullsafeObjectForKey:@"location"];
     self.screenName.text = [NSString stringWithFormat:@"@%@", [self.user objectForKey:@"screen_name"]];
    
    self.followButton.layer.cornerRadius = 5.0;
    self.followButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followButton.layer.borderWidth = 1.0;
    self.followButton.selected = [[self.user nullsafeValueForKeyPath:@"follow_request_sent"] boolValue] || [[self.user nullsafeValueForKeyPath:@"following"] boolValue];
    if(self.followButton.selected) {
        [self.followButton setImage:[UIImage imageNamed:@"tw_followed.png"] forState:UIControlStateNormal];
    } else {
        [self.followButton setImage:[UIImage imageNamed:@"tw_follow.png"] forState:UIControlStateNormal];
    }
    self.descriptionText.text = [self.user nullsafeObjectForKey:@"description"];
    float wd = self.descriptionText.frame.size.width;
    [self.descriptionText sizeToFit];
    CGRect rect = self.descriptionText.frame;
    rect.size.width = wd;
    self.descriptionText.frame = rect;
    
    rect = self.headerView.frame;
    rect.size.height = self.descriptionText.frame.size.height + self.descriptionText.frame.origin.y + 5;
    self.headerView.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [self setProfileBackground:nil];
    [self setAvatar:nil];
    [self setUsername:nil];
    [self setScreenName:nil];
    [self setTweets:nil];
    [self setFollowing:nil];
    [self setFavorites:nil];
    [self setFollowers:nil];
    [self setFollowButton:nil];
    [self setDescriptionText:nil];
    [self setLocationText:nil];
    [self setHeaderView:nil];
    [super viewDidUnload];
}

- (IBAction)followPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
        [self.delegate tweet:[NSString stringWithFormat:@"%d", [[self.user nullsafeObjectForKey:@"following"] intValue]] action:DPTweetActionFollow item:[self.user objectForKey:@"screen_name"]];
}

@end
