//
//  DPTwitterService.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTwitterService.h"
#import "STTwitterAPIWrapper.h"
#import "DPTweetsListViewController.h"
#import "DPTwitterTableDataSource.h"
#import "TSMiniWebBrowser.h"
#import "DPTweetsCache.h"
#import "SVProgressHUD.h"
#import "NSDictionary+Extensions.h"
#import <Twitter/Twitter.h>
#import "REComposeViewController.h"
#import "DPTweetViewController.h"

@implementation DPTwitterService

+(DPTwitterService *)sharedService {
    static DPTwitterService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

-(id)init {
    self = [super init];
    if(self) {
        [self wrapper];
    }
    return self;
}

-(STTwitterAPIWrapper *)wrapper {
    if(!_wrapper) {
        self.wrapper = [STTwitterAPIWrapper twitterAPIWithOAuthOSX];//try to get OS level auth
        [_wrapper verifyCredentialsWithSuccessBlock:^(NSString *username) {
            //verified os level auth
        } errorBlock:^(NSError *error) {
            NSLog(@"OS level auth failed. %@", [error localizedDescription]);
            self.wrapper = [STTwitterAPIWrapper twitterAPIApplicationOnlyWithConsumerKey:@"IzHQTmqxddy19BJlM3LPA" consumerSecret:@"o77XKFyDdRDpQ5vfi57kjHke55AIRNqc8n3GFH7X9ZU"];//my demo keys
            [_wrapper verifyCredentialsWithSuccessBlock:^(NSString *username) {
                //verified application keys
            } errorBlock:^(NSError *error) {
                NSLog(@"Application keys failed as well. %@", [error localizedDescription]);
                self.wrapper = nil;//setting this nil, so it will try to get all this everytime a call to get the wrapper is made. although.. not at the same time.
            }];
        }];
    }
    return _wrapper;
}

-(void)registerController:(UIViewController *)c {
    controller = c;
}

-(void)search:(NSString *)searchString {
    [SVProgressHUD show];
    [self.wrapper getSearchTweetsWithQuery:searchString successBlock:^(NSDictionary *response) {
        [self openTwitterList:[[DPTweetsCache sharedCache] addTweets:[response objectForKey:@"statuses"]] andTitle:searchString];
        [SVProgressHUD dismiss];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"Search Error: %@", [error localizedDescription]);
    }];
}

-(void)retweet:(NSString *)idString {
    [self.wrapper postStatusRetweetWithID:idString successBlock:^(NSDictionary *status) {
        [self refreshTweet:idString];
    } errorBlock:^(NSError *error) {
        NSLog(@"Retweet Error: %@", [error localizedDescription]);
    }];
}

-(void)favourite:(BOOL)state forId:(NSString *)idString {
    [self.wrapper postFavoriteState:state forStatusID:idString successBlock:^(NSDictionary *status) {
        [self refreshTweet:idString];
    } errorBlock:^(NSError *error) {
        NSLog(@"favourite error: %@", [error localizedDescription]);
    }];
}

-(void)follow:(NSString *)user forTweet:(NSString *)tweet {
    [self.wrapper postFollow:user successBlock:^(NSDictionary *user) {
        [self refreshTweet:tweet];
    } errorBlock:^(NSError *error) {
        NSLog(@"follow error: %@", [error localizedDescription]);
    }];
}

-(void)unfollow:(NSString *)user forTweet:(NSString *)tweet {
    [self.wrapper postUnfollow:user successBlock:^(NSDictionary *user) {
        [self refreshTweet:tweet];
    } errorBlock:^(NSError *error) {
        NSLog(@"unfollow error: %@", [error localizedDescription]);
    }];
}

-(void)refreshTweet:(NSString *)idString {
    [self.wrapper getStatusWithID:idString successBlock:^(NSDictionary *status) {
        [[DPTweetsCache sharedCache] updateTweet:status byId:idString];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
    } errorBlock:^(NSError *error) {
        NSLog(@"refresh Error : %@", [error localizedDescription]);
    }];
}

-(void)replyToTweet:(NSString *)tweetId fromAuthor:(NSString *)name {
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.text = [NSString stringWithFormat:@"@%@", name];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter-bird-dark-bgs.png"]];
    titleImageView.frame = CGRectMake(0, 0, 110, 40);
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    composeViewController.navigationItem.titleView = titleImageView;
    [composeViewController.navigationBar setTintColor:[UIColor colorWithRed:34/255.0 green:158/255.0 blue:213/255.0 alpha:1.0]];
    composeViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:194/255.0 alpha:1];
    composeViewController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:29/255.0 green:118/255.0 blue:143/255.0 alpha:1];
    composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        if (result == REComposeResultPosted) {
            [SVProgressHUD showWithStatus:@"Replying"];
            [self.wrapper postStatusUpdate:composeViewController.text inReplyToStatusID:tweetId placeID:nil lat:nil lon:nil successBlock:^(NSDictionary *status) {
                [SVProgressHUD showSuccessWithStatus:@"Replied"];
            } errorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Failed"];
                NSLog(@"reply Error : %@", [error localizedDescription]);
            }];
        }
    };
    [composeViewController presentFromRootViewController];
}

-(void)openTwitterList:(NSArray *)items andTitle:(NSString *)string {
    UIViewController<DPTweetsDisplay> *tweets = [DPTweetsListViewController controllerForTweets:items];
    ((DPTwitterTableDataSource *)tweets.datasource).delegate = self;
    ((DPTwitterTableDataSource *)tweets.delegate).delegate = self;
    tweets.navigationItem.title = string;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
    [self presentViewController:tweets];
}

-(BOOL)tweet:(NSString *)tweetId action:(DPTweetAction)action item:(NSString *)string {
    BOOL handled = NO;
    switch (action) {
        case DPTweetActionMentions:
        case DPTweetActionHashtag:
            [self search:string];
            handled = YES;
            break;
        case DPTweetActionRetweet:
            [self retweet:string];
            handled = YES;
            break;
        case DPTweetActionFavourite:
            [self favourite:[string boolValue] forId:tweetId];
            handled = YES;
            break;
        case DPTweetActionFollow: {
            NSDictionary *tweet = [[DPTweetsCache sharedCache] tweetWithId:tweetId];
            if([[tweet nullsafeValueForKeyPath:@"user.follow_request_sent"] boolValue] || [[tweet nullsafeValueForKeyPath:@"user.following"] boolValue])
                [self unfollow:string forTweet:tweetId];
            else
                [self follow:string forTweet:tweetId];
        }
            handled = YES;
            break;
        case DPTweetActionWeblink:
            if (!handled) {
                [self openURL:string];
                handled = YES;
            }
            break;
        case DPTweetActionReply:
            [self replyToTweet:tweetId fromAuthor:string];
            handled = YES;
            break;
        case DPTweetActionAuthor: {
            [self openURL:[NSString stringWithFormat: @"http://m.twitter.com/%@", string]];
            handled = YES;
        }
            break;
        case DPTweetActionOpenTweet: {
            DPTweetViewController *c = [[DPTweetViewController alloc] init];
            c.tweet = [[DPTweetsCache sharedCache] tweetWithId:tweetId];
            c.delegate = self;
            [self presentViewController:c];
            handled = YES;
        }
            break;
        default:
            break;
    }
    return handled;
}

-(void)openURL:(NSString *)url {
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:url]];
    [self presentViewController:webBrowser];
}

-(void)presentViewController:(UIViewController *)c {
    if(controller)
        [controller.navigationController pushViewController:c animated:YES];
}

@end
