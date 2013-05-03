//
//  DPTwitterService.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPTwitterTableDataSource.h"
#import "DPTweetsDisplay.h"

@class STTwitterAPIWrapper;

@interface DPTwitterService : NSObject <DPTweetDelegate> {
    UIViewController *controller;
}

@property (nonatomic, strong) STTwitterAPIWrapper *wrapper;

+(DPTwitterService *)sharedService;
-(void)registerController:(UIViewController *)c;
-(void)search:(NSString *)searchString;
-(void)openURL:(NSString *)url;
-(void)search:(NSString *)searchString forController:(id<DPTweetsDisplay>)c;
-(void)timeline:(NSString *)searchString forController:(id<DPTweetsDisplay>)c;

@end
