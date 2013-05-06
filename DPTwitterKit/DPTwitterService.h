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

#define kDPTwitterRegCompleteNotification @"twitter completed registtation"

@class STTwitterAPIWrapper;

typedef enum {
    DPTwitterAccountServiceApp,
    DPTwitterAccountServiceOS,
    DPTwitterAccountServiceAppUser
} DPTwitterAccountService;

@interface DPTwitterService : NSObject <DPTweetDelegate> {
    UIViewController *controller;
}

@property (nonatomic, strong) STTwitterAPIWrapper *wrapper;
@property (nonatomic) DPTwitterAccountService currentService;

+(DPTwitterService *)sharedService;
-(void)registerController:(UIViewController *)c;
-(void)search:(NSString *)searchString;
-(void)openURL:(NSString *)url;
-(void)search:(NSString *)searchString forController:(id<DPTweetsDisplay>)c;
-(void)timeline:(NSString *)searchString forController:(id<DPTweetsDisplay>)c;

@end
