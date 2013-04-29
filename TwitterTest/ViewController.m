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
#import "DPTwitterAccountSelector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DPTwitterAccountSelector getCurrentAccount:^(ACAccount *account) {
        self.currentAccount = account;
        [self searchTwitter];
    }];
}

-(void) searchTwitter {
    NSURL *searchURL = [NSURL URLWithString:@"http://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"genie" forKey:@"q"];
    TWRequest *request = [[TWRequest alloc] initWithURL:searchURL parameters:parameters requestMethod:TWRequestMethodGET];
    request.account = _currentAccount;
    NSLog(@"%@", _currentAccount.username);
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData)
        {
            NSError *parseError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
            DPTweetsListViewController *c = [DPTweetsListViewController controllerForTweets:json[@"statuses"]];
            [self.navigationController pushViewController:c animated:YES];
            if (!json)
            {
                NSLog(@"Parse Error: %@", parseError);
            }
        }
        else
        {
            NSLog(@"Request Error: %@", [error localizedDescription]);
        }
    }];
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
}
@end
