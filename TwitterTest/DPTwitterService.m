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
    [self.wrapper getSearchTweetsWithQuery:searchString successBlock:^(NSDictionary *response) {
        [self openTwitterList:[[DPTweetsCache sharedCache] addTweets:[response objectForKey:@"statuses"]] andTitle:searchString];
    } errorBlock:^(NSError *error) {
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

-(void)refreshTweet:(NSString *)idString {
    [self.wrapper getStatusWithID:idString successBlock:^(NSDictionary *status) {
        [[DPTweetsCache sharedCache] updateTweet:status byId:idString];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
    } errorBlock:^(NSError *error) {
        NSLog(@"refresh Error : %@", [error localizedDescription]);
    }];
}

-(void)openTwitterList:(NSArray *)items andTitle:(NSString *)string {
    UIViewController<DPTweetsDisplay> *tweets = [DPTweetsListViewController controllerForTweets:items];
    ((DPTwitterTableDataSource *)tweets.datasource).delegate = self;
    tweets.navigationItem.title = string;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
    [self performSelector:@selector(presentViewController:) withObject:tweets afterDelay:0.5];//cache takes a while to propogate. 
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
            break;
        case DPTweetActionFollow:
            
            break;
        case DPTweetActionWeblink:
            if (!handled) {
                TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:string]];
                [self presentViewController:webBrowser];
                handled = YES;
            }
            break;
        default:
            break;
    }
    return handled;
}

-(void)presentViewController:(UIViewController *)c {
    if(controller)
        [controller.navigationController pushViewController:c animated:YES];
}

@end
