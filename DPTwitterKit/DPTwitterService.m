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
#import "DPAuthorViewController.h"
#import "DPTwitterTableDelegate.h"
#import "STTwitterAccountSelector.h"

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
        NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedTwitterUsername];
        if (string && [[STTwitterAccountSelector sharedSelector] hasConfiguredAccounts] == STTwitterAccountConfigStatusSelected) {
            self.currentService = DPTwitterAccountServiceOS;
        } else
            self.currentService = DPTwitterAccountServiceApp;
    }
    return self;
}

-(STTwitterAPIWrapper *)wrapper {
    @autoreleasepool {
        if(!_wrapper) {
            [self createAWrapper];
        }
    }
    return _wrapper;
}

-(void) createAWrapper {
    __block DPTwitterService *service = self;
    switch (self.currentService) {
        case DPTwitterAccountServiceOS: {
            self.wrapper = [STTwitterAPIWrapper twitterAPIWithOAuthOSX];//try to get OS level auth
            [self.wrapper verifyCredentialsWithSuccessBlock:^(NSString *username) {
                //verified os level auth
                NSLog(@"verifid oslevel");
                [[NSNotificationCenter defaultCenter] postNotificationName:kDPTwitterRegCompleteNotification object:nil];
            } errorBlock:^(NSError *error) {
                service.wrapper = nil;
                NSLog(@"OS level auth failed. %@", [error localizedDescription]);
                [[NSNotificationCenter defaultCenter] postNotificationName:kDPTwitterRegErrorNotification object:error];
                self.wrapper = [STTwitterAPIWrapper twitterAPIApplicationOnlyWithConsumerKey:[self twitterKey] consumerSecret:[self twitterSecret]];//my demo keys
                [service.wrapper verifyCredentialsWithSuccessBlock:^(NSString *username) {
                    //verified application keys
                    NSLog(@"verifid app level");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDPTwitterRegCompleteNotification object:nil];
                } errorBlock:^(NSError *error) {
                    service.wrapper = nil;
                    NSLog(@"Application keys failed as well. %@", [error localizedDescription]);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDPTwitterRegErrorNotification object:error];
                }];
            }];
        }
            break;
        case DPTwitterAccountServiceApp: {
            self.wrapper = [STTwitterAPIWrapper twitterAPIApplicationOnlyWithConsumerKey:[self twitterKey] consumerSecret:[self twitterSecret]];//my demo keys
            [self.wrapper verifyCredentialsWithSuccessBlock:^(NSString *username) {
                //verified application keys
                NSLog(@"verifid app level");
                [[NSNotificationCenter defaultCenter] postNotificationName:kDPTwitterRegCompleteNotification object:nil];
            } errorBlock:^(NSError *error) {
                service.wrapper = nil;
                NSLog(@"Application keys failed as well. %@", [error localizedDescription]);
                [[NSNotificationCenter defaultCenter] postNotificationName:kDPTwitterRegErrorNotification object:error];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(NSString *)twitterKey {
    return @"IzHQTmqxddy19BJlM3LPA";
}

-(NSString *)twitterSecret {
    return @"o77XKFyDdRDpQ5vfi57kjHke55AIRNqc8n3GFH7X9ZU";
}

-(void)setCurrentService:(DPTwitterAccountService)c {
    _currentService = c;
    self.wrapper = nil;
    [self wrapper];
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
    if([self checkAuthenticationType]) {
        [self.wrapper postStatusRetweetWithID:idString successBlock:^(NSDictionary *status) {
            [self refreshTweet:idString];
        } errorBlock:^(NSError *error) {
            NSLog(@"Retweet Error: %@", [error localizedDescription]);
        }];
    }
}

-(void)favourite:(BOOL)state forId:(NSString *)idString {
    if([self checkAuthenticationType]) {
        [self.wrapper postFavoriteState:state forStatusID:idString successBlock:^(NSDictionary *status) {
            [self refreshTweet:idString];
        } errorBlock:^(NSError *error) {
            NSLog(@"favourite error: %@", [error localizedDescription]);
        }];
    }
}

-(void)follow:(NSString *)u forTweet:(NSString *)tweet {
    if([self checkAuthenticationType]) {
        [self.wrapper postFollow:u successBlock:^(NSDictionary *user) {
            if(tweet)
                [self refreshTweet:tweet];
            else
                [self refreshUser:u];
        } errorBlock:^(NSError *error) {
            NSLog(@"follow error: %@", [error localizedDescription]);
        }];
    }
}

-(void)unfollow:(NSString *)u forTweet:(NSString *)tweet {
    [self.wrapper postUnfollow:u successBlock:^(NSDictionary *user) {
        if(tweet)
            [self refreshTweet:tweet];
        else
            [self refreshUser:u];
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

-(void)refreshUser:(NSString *)idString {
    [self.wrapper getUserInformationFor:idString successBlock:^(NSDictionary *user) {
        [[DPTweetsCache sharedCache] updateUser:user byId:idString];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDPUserUpdatedNotification object:nil];
    } errorBlock:^(NSError *error) {
        NSLog(@"refresh Error : %@", [error localizedDescription]);
    }];
}

-(void)replyToTweet:(NSString *)tweetId fromAuthor:(NSString *)name {
    if([self checkAuthenticationType]) {
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
}

-(BOOL)checkAuthenticationType {
    if(self.currentService == DPTwitterAccountServiceApp) {
        if([[STTwitterAccountSelector sharedSelector] hasConfiguredAccounts] == STTwitterAccountConfigStatusSelected) {
            self.currentService = DPTwitterAccountServiceOS;
        } else {
            [[[UIAlertView alloc] initWithTitle:@"You need to login to Twitter from your Device Settings and approve the application to use those credentials." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return NO;
        }
    }
    return YES;
}

-(void)search:(NSString *)searchString forController:(id<DPTweetsDisplay>)c {
    if(c) {
        ((DPTwitterTableDataSource *)c.datasource).delegate = self;
        [SVProgressHUD show];
    }
    
    [self.wrapper getSearchTweetsWithQuery:[searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] successBlock:^(NSDictionary *response) {
        NSMutableDictionary *responseDict = [response mutableCopy];
        [responseDict setObject:[NSDate date] forKey:@"downloadedAt"];
        if(c) {
            ((DPTwitterTableDataSource *)c.datasource).tweets = [[DPTweetsCache sharedCache] addTweets:[response objectForKey:@"statuses"]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
        [SVProgressHUD dismiss];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"Search Error: %@", [error localizedDescription]);
    }];
}

-(void)timeline:(NSString *)searchString forController:(id<DPTweetsDisplay>)c {
    if(c) {
        ((DPTwitterTableDataSource *)c.datasource).delegate = self;
        [SVProgressHUD show];
    }
    [self.wrapper getUserTimelineWithScreenName:searchString successBlock:^(NSArray *array) {
        if(c) {
            ((DPTwitterTableDataSource *)c.datasource).tweets = [[DPTweetsCache sharedCache]addTweets:array];
        }
        NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
        [responseDict setObject:[NSDate date] forKey:@"downloadedAt"];
        if(c) {
            ((DPTwitterTableDataSource *)c.datasource).tweets = [[DPTweetsCache sharedCache] addTweets:array];
        }
        [responseDict setObject:array forKey:@"statuses"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
        [SVProgressHUD dismiss];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"Search Error: %@", [error localizedDescription]);
    }];
}

-(void)openTwitterList:(NSArray *)items andTitle:(NSString *)string {
    UIViewController<DPTweetsDisplay> *tweets = [DPTweetsListViewController controllerForTweets:items];
    ((DPTwitterTableDataSource *)tweets.datasource).delegate = self;
    tweets.navigationItem.title = string;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDPTweetsUpdatedNotification object:nil];
    [self presentViewController:tweets];
}

-(BOOL)tweet:(NSString *)tweetId action:(DPTweetAction)action item:(NSString *)string {
    BOOL handled = NO;
    switch (action) {
        case DPTweetActionMentions:
            [self search:[[NSString stringWithFormat:@"from:%@", string] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            handled = YES;
            break;
        case DPTweetActionHashtag:
            [self search:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            if(tweet) {
                if([[tweet nullsafeValueForKeyPath:@"user.follow_request_sent"] boolValue] || [[tweet nullsafeValueForKeyPath:@"user.following"] boolValue])
                    [self unfollow:string forTweet:tweetId];
                else
                    [self follow:string forTweet:tweetId];
            } else {
                if([tweetId boolValue])
                    [self unfollow:string forTweet:nil];
                else
                    [self follow:string forTweet:nil];
            }
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
            NSDictionary *tweet = [[DPTweetsCache sharedCache] tweetWithId:tweetId];
            NSDictionary *user = [tweet objectForKey:@"user"];
            DPAuthorViewController *author = [[DPAuthorViewController alloc] init];
            author.user = user;
            author.delegate = self;
            author.datasource = [[DPTwitterTableDataSource alloc] init];
            [self timeline:[user objectForKey:@"screen_name"] forController:author];
            [self presentViewController:author];
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
