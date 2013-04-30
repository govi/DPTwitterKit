//
//  DPTwitterTableDataSource.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTwitterTableDataSource.h"
#import "TSMiniWebBrowser.h"
#import "DPTwitterService.h"
#import "DPTweetViewCell.h"

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

-(BOOL)action:(DPTweetAction)action item:(NSString *)string {
    BOOL handled = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(action:item:)])
        handled = [self.delegate action:action item:string];
    switch (action) {
        case DPTweetActionWeblink:
            if (!handled) {
                TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:string]];
                if(self.delegate && [self.delegate respondsToSelector:@selector(presentViewController:)]) {
                    [self.delegate presentViewController:webBrowser];
                    handled = YES;
                }
            }
            break;
        default:
            
            break;
    }
    return handled;
}

@end
