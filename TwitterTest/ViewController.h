//
//  ViewController.h
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ACAccount *currentAccount;
@property (nonatomic, strong) NSMutableArray *shownAccounts;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *statuses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
