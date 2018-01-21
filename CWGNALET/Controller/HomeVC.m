//
//  HomeVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 11/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong, nonnull) IBOutlet UICollectionView* collectionView;
@property(nonatomic, nonnull, strong) NSMutableArray* options;
@end



@implementation HomeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    self.options = [[NSMutableArray alloc]initWithCapacity:4];
    NSArray* obj = @[@"New Request", @"My Requests", @"Issues Nearby", @"Reporter"];
    _options = [obj mutableCopy];
    // Do any additional setup after loading the view.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - TableView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return _options.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMPGCells* cell = (HMPGCells*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HMPGCells class]) forIndexPath:indexPath];
    [cell configureCell:[_options objectAtIndex:indexPath.row]];
    return  cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 150);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString* option = [_options objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Categories" sender:nil];
}




@end
