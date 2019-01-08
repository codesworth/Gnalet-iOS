//
//  RequestDetailsVC.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"
#import "DBService.h"

@interface RequestDetailsVC : UIViewController
@property (strong, nonatomic) Case* acase;
@end
