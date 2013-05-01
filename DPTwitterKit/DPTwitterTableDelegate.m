//
//  DPTwitterTableDelegate.m
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTwitterTableDelegate.h"
#import "DPTweetViewCell.h"

@implementation DPTwitterTableDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPTweetViewCell *cell = (DPTweetViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[DPTweetViewCell class]] && self.delegate && [self.delegate respondsToSelector:@selector(tweet:action:item:)]) {
        [self.delegate tweet:[cell.tweet objectForKey:@"id_str"] action:DPTweetActionOpenTweet item:[cell.tweet valueForKeyPath:@"user.screen_name"]];
    }
}

@end
