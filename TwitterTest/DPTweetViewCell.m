//
//  DPTwitterViewCell.m
//  TwitterTest
//
//  Created by Govi on 26/04/2013.
//  Copyright (c) 2013 Genie-Connect. All rights reserved.
//

#import "DPTweetViewCell.h"
#import "STTweetLabel.h"

@implementation DPTweetViewCell

+(DPTweetViewCell *)newCell {
    DPTweetViewCell *cell = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:@"DPTweetViewCell" ofType:@"nib"]]) {
        NSArray *ar = [[NSBundle mainBundle] loadNibNamed:@"DPTweetViewCell" owner:nil options:nil];
        for(id obj in ar) {//load the nib and search for the cell
            if([obj isKindOfClass:[UITableViewCell class]]) {
                cell = obj;
                break;
            }
        }
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followPressed:(id)sender {
}

- (IBAction)replyPressed:(id)sender {
}

- (IBAction)retweetPressed:(id)sender {
}

- (IBAction)favouritePressed:(id)sender {
}

- (IBAction)authorPressed:(id)sender {
}

@end
