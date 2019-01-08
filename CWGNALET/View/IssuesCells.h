//
//  IssuesCells.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 30/03/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@interface IssuesCells : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backlay;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property (weak, nonatomic) IBOutlet UILabel *uplabel;
@property (weak, nonatomic) IBOutlet UILabel *dnlabel;

-(void)configureCells:(Case*_Nonnull)acase;
@end
