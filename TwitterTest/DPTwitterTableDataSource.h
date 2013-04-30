//
//  DPTwitterTableDataSource.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPTweetDelegate.h"


@interface DPTwitterTableDataSource : NSObject <UITableViewDataSource, DPTweetDelegate>

@property (nonatomic, strong) NSArray *tweets;
@property (weak, nonatomic) id<DPTweetDelegate> delegate;

+(DPTwitterTableDataSource *)datasourceWithTweets:(NSArray *)array;

@end
