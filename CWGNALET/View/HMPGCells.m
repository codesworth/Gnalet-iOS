//
//  HMPGCells.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 11/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "HMPGCells.h"

@interface HMPGCells()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *namelbl;

@end

@implementation HMPGCells


-(void)configureCell:(NSString *)name
{
    [_namelbl setText:name];
}



@end
