//
//  TweetsListViewController.h
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTweetsListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) id<UITableViewDelegate> delegate;
@property (strong, nonatomic) id<UITableViewDataSource> datasource;

+(DPTweetsListViewController *)controllerForTweets:(NSArray *)array;

@end
