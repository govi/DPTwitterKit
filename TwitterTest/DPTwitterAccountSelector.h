//
//  DPTwitterAccountSelector.h
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface DPTwitterAccountSelector : NSObject <UIActionSheetDelegate> {
    void(^onSelect)(ACAccount *selectedAccount);
}

@property (nonatomic, strong) ACAccount *currentAccount;
@property (nonatomic, strong) NSMutableArray *shownAccounts;
@property (nonatomic, strong) ACAccountStore *accountStore;

+(void) getCurrentAccount:(void(^)(ACAccount *account))selected;
+(void)selectAccount:(void(^)(ACAccount *account))selected;
+(DPTwitterAccountSelector *)sharedSelector;

@end
