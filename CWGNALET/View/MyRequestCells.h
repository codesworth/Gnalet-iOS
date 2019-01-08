//
//  MyRequestCells.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@interface MyRequestCells : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *   _Nullable reqTitlelbl;

@property (weak, nonatomic) IBOutlet UILabel * _Nullable reqMoredetlbl;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable upvotelbl;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable dwnvotelbl;



-(void)configure:(Case* _Nonnull)acase;

@end
