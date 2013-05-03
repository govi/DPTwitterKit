//
//  DPTweetViewController.m
//  EventGenie
//
//  Created by Govi on 02/05/2013.
//  Copyright (c) 2013 GenieMobile. All rights reserved.
//

#import "DPTweetViewController.h"
#import "STTweetLabel.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+Extensions.h"
#import "DPTweetsCache.h"
#import <QuartzCore/QuartzCore.h>

@interface DPTweetViewController ()

@end

static NSDateFormatter *formatter;
static NSDateFormatter *reader;

@implementation DPTweetViewController
@synthesize delegate;

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
    [self displayTweet:self.tweet];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTweet) name:kDPTweetsUpdatedNotification object:nil];
    self.navigationItem.title = @"Tweet";
}

-(void)refreshTweet {
    NSString *tweetId = [self.tweet objectForKey:@"id_str"];
    self.tweet = [[DPTweetsCache sharedCache] tweetWithId:tweetId];
    [self displayTweet:self.tweet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setThumbnail:nil];
    [self setAuthorName:nil];
    [self setAuthorUsername:nil];
    [self setFollowButton:nil];
    [self setTimestamp:nil];
    [self setTweet:nil];
    [self setReplyButton:nil];
    [self setRetweetButton:nil];
    [self setFavouriteButton:nil];
    [self setSeparatorView:nil];
    [self setDescriptionText:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}

-(void)decorate {
    __block DPTweetViewController *c = self;
    [self.descriptionText setCallbackBlock:^(STLinkActionType actionType, NSString *link) {
        // determine what the user clicked on
        switch (actionType) {
                // if the user clicked on an account (@_max_k)
            case STLinkActionTypeAccount:
                if(c.delegate && [c.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [c.delegate tweet:[c.tweet valueForKeyPath:@"id_str"] action:DPTweetActionMentions item:link];
                break;
                
                // if the user clicked on a hashtag (#thisisreallycool)
            case STLinkActionTypeHashtag:
                if(c.delegate && [c.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [c.delegate tweet:[c.tweet valueForKeyPath:@"id_str"] action:DPTweetActionHashtag item:link];
                break;
                
                // if the user clicked on a website (http://github.com/SebastienThiebaud)
            case STLinkActionTypeWebsite:
                if(c.delegate && [c.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [c.delegate tweet:[c.tweet valueForKeyPath:@"id_str"] action:DPTweetActionWeblink item:link];
                break;
        }
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorPressed:)];
    [self.authorName addGestureRecognizer:gesture];
    [self.authorUsername addGestureRecognizer:gesture];
    [self.thumbnail addGestureRecognizer:gesture];
    
    self.thumbnail.layer.cornerRadius = 5.0;
    self.thumbnail.clipsToBounds = YES;
}

-(void)displayTweet:(NSDictionary *)tweet {
    self.tweet = tweet;
    if(!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE, MMM dd, YYYY HH:mm";
        
        reader = [[NSDateFormatter alloc] init];
        reader.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    }
    self.timestamp.text = [formatter stringFromDate:[reader dateFromString:[tweet objectForKey:@"created_at"]]];
    self.authorName.text = [tweet valueForKeyPath:@"user.name"];
    self.authorUsername.text = [NSString stringWithFormat:@"@%@", [tweet valueForKeyPath:@"user.screen_name"]];
    self.retweetButton.selected = [[tweet objectForKey:@"retweeted"] boolValue];
    self.favouriteButton.selected = [[tweet objectForKey:@"favorited"] boolValue];
    self.followButton.selected = [[tweet nullsafeValueForKeyPath:@"user.follow_request_sent"] boolValue] || [[tweet nullsafeValueForKeyPath:@"user.following"] boolValue];
    if(self.followButton.selected) {
        [self.followButton setImage:[UIImage imageNamed:@"tw_followed.png"] forState:UIControlStateNormal];
    } else {
        [self.followButton setImage:[UIImage imageNamed:@"tw_follow.png"] forState:UIControlStateNormal];
    }
    [self.thumbnail setImageWithURL:[NSURL URLWithString:[tweet valueForKeyPath:@"user.profile_image_url"]]];
    
    
    self.descriptionText.text = [tweet objectForKey:@"text"];
    float width = self.descriptionText.frame.size.width;
    [self.descriptionText sizeToFit];
    CGRect rect = self.descriptionText.frame;
    rect.size.width = width;
    self.descriptionText.frame = rect;
    
    rect = self.separatorView.frame;
    rect.origin.y = self.descriptionText.frame.size.height + self.descriptionText.frame.origin.y + 8.0;
    self.separatorView.frame = rect;
    
    rect = self.replyButton.frame;
    rect.origin.y = self.separatorView.frame.origin.y + 9.0;
    self.replyButton.frame = rect;
    
    rect = self.retweetButton.frame;
    rect.origin.y = self.separatorView.frame.origin.y + 9.0;
    self.retweetButton.frame = rect;
    
    rect = self.favouriteButton.frame;
    rect.origin.y = self.separatorView.frame.origin.y + 9.0;
    self.favouriteButton.frame = rect;
    
    rect = self.timestamp.frame;
    rect.origin.y = self.separatorView.frame.origin.y + 9.0;
    self.timestamp.frame = rect;
    
    rect = self.containerView.frame;
    rect.size.height = self.retweetButton.frame.size.height + self.retweetButton.frame.origin.y  + 8.0;
    self.containerView.frame = rect;
    
    self.followButton.layer.cornerRadius = 5.0;
    self.followButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followButton.layer.borderWidth = 1.0;
}

- (IBAction)followPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
        [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionFollow item:[self.tweet valueForKeyPath:@"user.screen_name"]];
}

- (IBAction)replyPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
        [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionReply item:[self.tweet valueForKeyPath:@"user.screen_name"]];
}

- (IBAction)retweetPressed:(id)sender {
    BOOL retweeted = [[self.tweet objectForKey:@"retweeted"] boolValue];
    if(retweeted) {
        [[[UIAlertView alloc] initWithTitle:@"You have already retweeted this status." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Do you want to retweet this status?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
    }
}

- (IBAction)favouritePressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
        [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionFavourite item:[NSString stringWithFormat:@"%d", ![[self.tweet objectForKey:@"favorited"] boolValue]]];
}

- (IBAction)authorPressed:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
        [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionAuthor item:[self.tweet valueForKeyPath:@"user.screen_name"]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
            [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionRetweet item:[self.tweet valueForKeyPath:@"id_str"]];
    }
}

@end
