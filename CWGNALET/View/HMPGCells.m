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

-(NSString*)imageForIndex:(NSUInteger)index
{
    NSArray* list = @[@"add", @"list", @"streetmap", @"user"];
    return [list objectAtIndex:index];
}


-(void)configureCell:(NSString *)name index:(NSUInteger)index
{
    [_namelbl setText:name];
    [_imageView setImage:[UIImage imageNamed:[self imageForIndex:index]]];
}



@end
