//
//  MyRequestsVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "MyRequestsVC.h"

@interface MyRequestsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<Case*>* cases;
@property (nonatomic, weak)IBOutlet UITableView* tableView;
@property (nonatomic, strong)CCActivityHUD* activityHUD;

@end

@implementation MyRequestsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //[self fetchCases];
    [self setActivityHUD:[CCActivityHUD new]];
}

- (void)fetchCases
{
    [[DBService service]fetchMyReports:^(NSMutableArray<Case *> * _Nullable cases) {
        self.cases = cases;
        [self.activityHUD dismiss];
        [self.tableView reloadData];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.activityHUD showWithType:CCActivityHUDIndicatorTypeDynamicArc];;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{});
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -: UITableViewDelegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cases count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssuesCells* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IssuesCells class]) forIndexPath:indexPath];
    Case* acase = [_cases objectAtIndex:indexPath.row];
    [cell configureCells:acase];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Case *acase = [_cases objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"issuedet" sender:acase];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"issuedet"]) {
        Case* acase = (Case*)sender;
        RequestDetailsVC* vc = [segue destinationViewController];
        [vc setAcase:acase];
    }
}




@end
