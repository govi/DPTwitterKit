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
    [[DPTwitterService sharedService].wrapper getSearchTweetsWithQuery:searchString successBlock:^(NSDictionary *response) {
        [self performSelectorOnMainThread:@selector(openTwitterList:) withObject:[response objectForKey:@"statuses"] waitUntilDone:NO];
    } errorBlock:^(NSError *error) {
        NSLog(@"Request Error: %@", [error localizedDescription]);
    }];
}

-(void)openTwitterList:(NSArray *)items {
    DPTweetsListViewController *tweets = [DPTweetsListViewController controllerForTweets:items];
    ((DPTwitterTableDataSource *)tweets.datasource).delegate = self;
    [self presentViewController:tweets];
}

-(BOOL)action:(DPTweetAction)action item:(NSString *)string {
    BOOL handled = NO;
    switch (action) {
        case DPTweetActionMentions:
        case DPTweetActionHashtag:
            [self search:string];
            handled = YES;
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
