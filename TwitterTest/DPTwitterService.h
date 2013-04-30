//
//  DPTwitterService.h
//  TwitterTest
//
//  Created by Govi on 30/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTwitterAPIWrapper;

@interface DPTwitterService : NSObject

@property (nonatomic, strong) STTwitterAPIWrapper *wrapper;

+(DPTwitterService *)sharedService;

@end
