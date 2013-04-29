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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self handleAccounts];
}

-(void)handleAccounts {
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([accountType accessGranted])
    {
        // have access already
        [self _showListOfTwitterAccountsFromStore:_accountStore];
    }
    else
    {
        // need access first
        [_accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            
            if (granted)
            {
                [self _showListOfTwitterAccountsFromStore:_accountStore];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot link account without permission" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (void)_showListOfTwitterAccountsFromStore:(ACAccountStore *)accountStore
{
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Choose Account to Use" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    actions.tag = 2;
    
    NSMutableArray *shownAccounts = [NSMutableArray array];
    
    for (ACAccount *oneAccount in twitterAccounts)
    {
        NSLog(@"%@", oneAccount.username);
        [actions addButtonWithTitle:oneAccount.username];
        [shownAccounts addObject:oneAccount];
    }
    [actions addButtonWithTitle:@"Cancel"];
    actions.cancelButtonIndex = [twitterAccounts count] + 1;
    
    self.shownAccounts = shownAccounts;
    
    [actions showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        self.currentAccount = [_shownAccounts objectAtIndex:buttonIndex];
        [self searchTwitter];
    }
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
            self.statuses = json[@"statuses"];
            [self.tableView reloadData];         
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPTweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DPTweetViewCell"];
    if(!cell) {
        cell = [DPTweetViewCell newCell];
    }
    NSDictionary *tweet = [_statuses objectAtIndex:indexPath.row];
    cell.timestamp.text = [tweet objectForKey:@"created_at"];
    cell.authorName.text = [tweet valueForKeyPath:@"user.name"];
    cell.authorUsername.text = [NSString stringWithFormat:@"@%@", [tweet valueForKeyPath:@"user.screen_name"]];
    cell.descriptionText.text = [tweet objectForKey:@"text"];
    cell.retweetButton.selected = [[tweet objectForKey:@"retweeted"] boolValue];
    int rtCount = [[tweet objectForKey:@"retweet_count"] intValue];
    if(rtCount > 0) {
        if(rtCount < 1000)
            cell.rtCount.text = [NSString stringWithFormat:@"%d", rtCount];
        else
            cell.rtCount.text = @"999";
    }
    else
        cell.rtCount.text = @"";
    cell.favouriteButton.selected = [[tweet objectForKey:@"favorited"] boolValue];
    int favCount = [[tweet objectForKey:@"favorite_count"] intValue];
    if(favCount > 0) {
        if(favCount < 1000)
            cell.favCount.text = [NSString stringWithFormat:@"%d", favCount];
        else
            cell.favCount.text = @"999";
    }
    else
        cell.favCount.text = @"";
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_statuses count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
