//
//  TweetsListViewController.h
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPTweetsDisplay.h"

@interface DPTweetsListViewController : UIViewController<DPTweetsDisplay> {
    id<UITableViewDelegate> tableDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *listView;


@end
