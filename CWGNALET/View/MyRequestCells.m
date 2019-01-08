 //
//  MyRequestCells.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "MyRequestCells.h"

@implementation MyRequestCells

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configure:(Case*)acase
{
    [self.reqTitlelbl setText:acase.c_title];
    [self.reqMoredetlbl setText:acase.c_description];
    [self.upvotelbl setText:[NSString stringWithFormat:@"%lu", (unsigned long)acase.upVotes]];
    [self.dwnvotelbl setText:[NSString stringWithFormat:@"%lu", (unsigned long)acase.downVotes]];
}




@end
