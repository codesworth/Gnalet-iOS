//
//  CategoryVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 11/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "CategoryVC.h"

@interface CategoryVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSMutableArray* lists;


@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    NSArray* arr = @[    CS.ABANDONED_ACCIDENT,
                         CS.ECG,
                         CS.POTHOLES,
                         CS.SANITATION,
                         CS.OTHERS];
    self.lists = [[NSMutableArray alloc]initWithArray:arr];
    // Do any additional setup after loading the view.
}


#pragma warning - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"NewReqGen"]){
        GenReqVC* vc = [segue destinationViewController];
        NSString* title = (NSString*)sender;
        [vc setCatTitle:title];
    }else{
        RequestVCR* vc = [segue destinationViewController];
        NSString* title = (NSString*)sender;
        [vc setCatTitle:title];
    }

}

#pragma mark:- TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
    [self config:cell at:indexPath.row];
    return cell;
}

-(void)config:(UITableViewCell*)cell at:(NSUInteger)index
{
    UILabel* l = [cell viewWithTag:100];
    [l setText:[self.lists objectAtIndex:index]];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* option = [_lists objectAtIndex:indexPath.row];
    if (indexPath.row == 0){
       [self performSegueWithIdentifier:@"NewRequestR" sender:option];
    }else{
        [self performSegueWithIdentifier:@"NewReqGen" sender:option];
    }
    
}


@end





/*
 
 Road and Transport || ABANDONED/ACCIDENT VEHICLE",
 @"Garbage and Waste Disposal",
 @"Street Light",
 @"Public Safety || POTHOLES",
 @"General Maintenance",
 @"Electricity || ELECTRICAL /ECG",
 @"Water and Sanitation || SANITATION",
 @"Abandoned Vehicle",
 @"Suspicious Activity || OTHERS"
 
 */
