//
//  ViewController.m
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "ViewController.h"
#import "DPTwitterService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DPTwitterService sharedService] registerController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSearchBox:nil];
    [super viewDidUnload];
}

- (IBAction)searchPressed:(id)sender {
    [[DPTwitterService sharedService] search:self.searchBox.text];
}

@end
