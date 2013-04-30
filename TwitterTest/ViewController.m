//
//  ViewController.m
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "ViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "DPTweetViewCell.h"
#import "STTweetLabel.h"
#import "DPTweetsListViewController.h"
#import "DPTwitterService.h"
#import "STTwitterAPIWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DPTwitterService sharedService];
    [self.searchSegment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSearchSegment:nil];
    [self setSearchBox:nil];
    [super viewDidUnload];
}

- (IBAction)searchPressed:(id)sender {
    [[DPTwitterService sharedService].wrapper getSearchTweetsWithQuery:self.searchBox.text successBlock:^(NSDictionary *response) {
        [self performSelectorOnMainThread:@selector(openTwitterList:) withObject:[response objectForKey:@"statuses"] waitUntilDone:NO];
    } errorBlock:^(NSError *error) {
        NSLog(@"Request Error: %@", [error localizedDescription]);
    }];
}

-(void)openTwitterList:(NSArray *)items {
    DPTweetsListViewController *c = [DPTweetsListViewController controllerForTweets:items];
    [self.navigationController pushViewController:c animated:YES];
}

-(void)mentionsOpened:(NSString *)username {
    self.searchBox.text = username;
    [self searchPressed:self.searchBox];
}

-(void)hashtagOpened:(NSString *)hashtag {
    self.searchBox.text = hashtag;
    [self searchPressed:self.searchBox];
}

@end
