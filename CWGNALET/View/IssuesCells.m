//
//  IssuesCells.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 30/03/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "IssuesCells.h"

@implementation IssuesCells

- (void)awakeFromNib {
    [super awakeFromNib];
    [_backlay.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    _backlay.layer.shadowRadius = 3.0;
    _backlay.layer.shadowOffset = CGSizeMake(0, 3);
}



-(void)configureCells:(Case*)acase
{
    [self.title setText:acase.c_title];
    [_sender setText:acase.reporter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
