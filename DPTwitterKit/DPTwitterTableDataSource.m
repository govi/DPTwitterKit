//
//  DPTwitterTableDataSource.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTwitterTableDataSource.h"
#import "DPTweetViewCell.h"
#import "DPTweetsCache.h"

@implementation DPTwitterTableDataSource

+(DPTwitterTableDataSource *)datasourceWithTweets:(NSArray *)array {
    DPTwitterTableDataSource *d = [[DPTwitterTableDataSource alloc] init];
    d.tweets = array;
    return d;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPTweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DPTweetViewCell"];
    if(!cell) {
        cell = [DPTweetViewCell newCell];
        cell.delegate = self.delegate;
    }
    NSString *tweetId = [_tweets objectAtIndex:indexPath.row];
    NSDictionary *tweet = nil;
    if(tweetId)
        tweet = [[DPTweetsCache sharedCache] tweetWithId:tweetId];
    if (tweet) {
        [cell displayTweet:tweet];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
}

-(void)dealloc {
    [[DPTweetsCache sharedCache] removeTweetsById:self.tweets];
}

@end
