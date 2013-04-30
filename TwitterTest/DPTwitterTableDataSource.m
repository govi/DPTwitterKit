//
//  DPTwitterTableDataSource.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTwitterTableDataSource.h"
#import "TSMiniWebBrowser.h"

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
        cell.delegate = self;
    }
    NSDictionary *tweet = [_tweets objectAtIndex:indexPath.row];
    [cell displayTweet:tweet];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
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
        if(self.delegate && [self.delegate respondsToSelector:@selector(presentViewController:)])
            [self.delegate presentViewController:webBrowser];
    }
}

-(void)hashtagOpened:(NSString *)hashtag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hashtagOpened:)]) {
        [self.delegate hashtagOpened:hashtag];
    }
}

@end
