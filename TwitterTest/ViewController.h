//
//  ViewController.h
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegment;
@property (weak, nonatomic) IBOutlet UITextField *searchBox;

- (IBAction)searchPressed:(id)sender;

@end
