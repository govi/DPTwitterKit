//
//  DPTweetsDisplay.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPTweetsDisplay <NSObject>

+(UIViewController<DPTweetsDisplay> *)controllerForTweets:(NSArray *)array;

@property (strong, nonatomic) id<UITableViewDelegate> delegate;
@property (strong, nonatomic) id<UITableViewDataSource> datasource;

@end
