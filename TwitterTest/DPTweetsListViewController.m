//
//  TweetsListViewController.m
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTweetsListViewController.h"
#import "DPTweetViewCell.h"
#import "TSMiniWebBrowser.h"

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
        cell.delegate = self;
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

-(void)followPressed:(NSString *)userId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(followPressed:)]) {
        [self.delegate followPressed:userId];
    }
}

-(void)replyPressed:(NSString *)tweetId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyPressed:)]) {
        [self.delegate replyPressed:tweetId];
    }
}

-(void)retweetPressed:(NSString *)tweetId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(retweetPressed:)]) {
        [self.delegate retweetPressed:tweetId];
    }
}

-(void)favouritePressed:(NSString *)tweetId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(favouritePressed:)]) {
        [self.delegate favouritePressed:tweetId];
    }
}

-(void)authorPressed:(NSString *)userId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorPressed:)]) {
        [self.delegate authorPressed:userId];
    }
}

-(void)mentionsOpened:(NSString *)username {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mentionsOpened:)]) {
        [self.delegate mentionsOpened:username];
    }
}

-(void)weblinkOpened:(NSString *)link {
    if (self.delegate && [self.delegate respondsToSelector:@selector(weblinkOpened:)]) {
        [self.delegate weblinkOpened:link];
    } else {
        TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:link]];
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
}

-(void)hashtagOpened:(NSString *)hashtag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hashtagOpened:)]) {
        [self.delegate hashtagOpened:hashtag];
    }
}

@end
