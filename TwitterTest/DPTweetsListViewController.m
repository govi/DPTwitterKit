//
//  TweetsListViewController.m
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTweetsListViewController.h"
#import "DPTwitterTableDataSource.h"
#import "DPTwitterTableDelegate.h"

@interface DPTweetsListViewController ()

@end

@implementation DPTweetsListViewController
@synthesize datasource, delegate;

+(DPTweetsListViewController *)controllerForTweets:(NSArray *)array {
    DPTweetsListViewController *twController = [[DPTweetsListViewController alloc] init];
    twController.delegate = [[DPTwitterTableDelegate alloc] init];
    twController.datasource = [DPTwitterTableDataSource datasourceWithTweets:array];
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
    self.listView.dataSource = self.datasource;
    self.listView.delegate = self.delegate;
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self.listView selector:@selector(reloadData) name:kDPTweetsUpdatedNotification object:nil];
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

@end
