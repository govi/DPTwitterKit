//
//  DPTwitterViewCell.m
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTweetViewCell.h"
#import "STTweetLabel.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+Extensions.h"

static NSDateFormatter *formatter;
static NSDateFormatter *reader;

@implementation DPTweetViewCell

+(DPTweetViewCell *)newCell {
    DPTweetViewCell *cell = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:@"DPTweetViewCell" ofType:@"nib"]]) {
        NSArray *ar = [[NSBundle mainBundle] loadNibNamed:@"DPTweetViewCell" owner:nil options:nil];
        for(id obj in ar) {//load the nib and search for the cell
            if([obj isKindOfClass:[UITableViewCell class]]) {
                cell = obj;
                [cell decorate];
                break;
            }
        }
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)decorate {
    [self.descriptionText setCallbackBlock:^(STLinkActionType actionType, NSString *link) {
        // determine what the user clicked on
        switch (actionType) {
                // if the user clicked on an account (@_max_k)
            case STLinkActionTypeAccount:
                if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionMentions item:link];
                break;
                
                // if the user clicked on a hashtag (#thisisreallycool)
            case STLinkActionTypeHashtag:
                if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionHashtag item:link];
                break;
                
                // if the user clicked on a website (http://github.com/SebastienThiebaud)
            case STLinkActionTypeWebsite:
                if(self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)])
                    [self.delegate tweet:[self.tweet valueForKeyPath:@"id_str"] action:DPTweetActionWeblink item:link];
                break;
        }
    }];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorPressed:)];
    [self.authorName addGestureRecognizer:gesture];
    [self.authorUsername addGestureRecognizer:gesture];
    [self.avatar addGestureRecognizer:gesture];
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
    self.descriptionText.text = [tweet objectForKey:@"text"];
    self.retweetButton.selected = [[tweet objectForKey:@"retweeted"] boolValue];
    int rtCount = [[tweet objectForKey:@"retweet_count"] intValue];
    if(rtCount > 0) {
        if(rtCount < 1000)
            self.rtCount.text = [NSString stringWithFormat:@"%d", rtCount];
        else
            self.rtCount.text = @"999";
    }
    else
        self.rtCount.text = @"";
    self.favouriteButton.selected = [[tweet objectForKey:@"favorited"] boolValue];
    int favCount = [[tweet objectForKey:@"favorite_count"] intValue];
    if(favCount > 0) {
        if(favCount < 1000)
            self.favCount.text = [NSString stringWithFormat:@"%d", favCount];
        else
            self.favCount.text = @"999";
    }
    else
        self.favCount.text = @"";
    self.followButton.selected = [[tweet nullsafeValueForKeyPath:@"user.follow_request_sent"] boolValue] || [[tweet nullsafeValueForKeyPath:@"user.following"] boolValue];
    if(self.followButton.selected) {
        [self.followButton setImage:[UIImage imageNamed:@"twitter-bird-white-on-blue.png"] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"twitter-bird-white-on-blue.png"] forState:UIControlStateHighlighted];
    } else {
        [self.followButton setImage:[UIImage imageNamed:@"twitter-bird-light-bgs.png"] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"twitter-bird-light-bgs.png"] forState:UIControlStateHighlighted];
    }
    [self.avatar setImageWithURL:[NSURL URLWithString:[tweet valueForKeyPath:@"user.profile_image_url"]]];
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
