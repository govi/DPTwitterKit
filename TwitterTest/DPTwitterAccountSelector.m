//
//  DPTwitterAccountSelector.m
//  TwitterTest
//
//  Created by Govi on 29/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTwitterAccountSelector.h"

@implementation DPTwitterAccountSelector

+(void) getCurrentAccount:(void(^)(ACAccount *account))selected {
    DPTwitterAccountSelector *s = [DPTwitterAccountSelector sharedSelector];
    if(s.currentAccount && selected)
        selected(s.currentAccount);
    else
        [self selectAccount:selected];
}

+(void)selectAccount:(void(^)(ACAccount *account))selected {
    DPTwitterAccountSelector *s = [DPTwitterAccountSelector sharedSelector];
    [s onSelectPerform:selected];
    [s handleAccounts];
}

+(DPTwitterAccountSelector *)sharedSelector {
    static DPTwitterAccountSelector *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[DPTwitterAccountSelector alloc] init];
    });
    return s;
}

-(void) onSelectPerform:(void(^)(ACAccount *account))selected {
    onSelect = selected;
}

-(void)handleAccounts {
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([accountType accessGranted])
    {
        // have access already
        [self _showListOfTwitterAccountsFromStore:_accountStore];
    }
    else
    {
        // need access first
        [_accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if (granted)
            {
                [self _showListOfTwitterAccountsFromStore:_accountStore];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot link account without permission" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (void)_showListOfTwitterAccountsFromStore:(ACAccountStore *)accountStore
{
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Choose Account to Use" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    actions.tag = 2;
    
    NSMutableArray *shownAccounts = [NSMutableArray array];
    for (ACAccount *oneAccount in twitterAccounts)
    {
        [actions addButtonWithTitle:oneAccount.username];
        [shownAccounts addObject:oneAccount];
    }
    self.shownAccounts = shownAccounts;
    if([twitterAccounts count] > 1) {
        [actions addButtonWithTitle:@"Cancel"];
        actions.cancelButtonIndex = [twitterAccounts count];
        
        [actions showInView: [UIApplication sharedApplication].keyWindow];
    } else {
        [self selectAccountAtIndex:0];
    }
}

-(void)selectAccountAtIndex:(int) index {
    if(onSelect) {
        onSelect([_shownAccounts objectAtIndex:index]);
        onSelect = nil;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        [self selectAccountAtIndex:buttonIndex];
    }
}

@end
