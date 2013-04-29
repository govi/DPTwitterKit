//
//  TweetsListViewController.m
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTweetsListViewController.h"
#import "DPTweetViewCell.h"

@interface DPTweetsListViewController ()

@end

@implementation DPTweetsListViewController

+(DPTweetsListViewController *)controllerForTweets:(NSArray *)array {
    DPTweetsListViewController *twController = [[DPTweetsListViewController alloc] init];
    twController.tweets = array;
    return twController;
}


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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPTweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DPTweetViewCell"];
    if(!cell) {
        cell = [DPTweetViewCell newCell];
    }
    NSDictionary *tweet = [_tweets objectAtIndex:indexPath.row];
    [cell displayTweet:tweet];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0;
}

@end
