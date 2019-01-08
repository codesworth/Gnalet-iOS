//
//  HomeVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 11/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate>

@property(nonatomic, strong, nonnull) IBOutlet UICollectionView* collectionView;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *messagelbl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infobutt;
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



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    __block BOOL firsted = [[NSUserDefaults standardUserDefaults] boolForKey:CS.C.FIRST_RUN];
    if (!firsted){
        [_overlay setHidden:NO];
        [_activity startAnimating];
        [[AuthService auth]signInAnonymously:^(id _Nullable object ){
            //End animation success connection
            if (object == nil) {
                [_overlay setHidden:YES];
                [_activity stopAnimating];
                UIAlertAction* ac = [UIAlertAction actionWithTitle:@"Dismiss" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
                [self presentViewController:[CS createAlert:@"Success" :@"Initialized Succesfully" actions:@[ac]] animated:YES completion:^{
                }];
                firsted = YES;
                [[NSUserDefaults standardUserDefaults] setBool:firsted forKey:CS.C.FIRST_RUN];
            }
        } errorCompletion:^{
            //Error establishing connection
        }];
    }
    
    
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
    [cell configureCell:[_options objectAtIndex:indexPath.row] index:indexPath.row];
    return  cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"Categories" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"MyRequest" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"Maps" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"Reporter" sender:nil];
            break;
        default:
            break;
    }
    
}
- (IBAction)newreq:(id)sender {
    
    [self performSegueWithIdentifier:@"Categories" sender:nil];
}

- (IBAction)myreqs:(id)sender {
     [self performSegueWithIdentifier:@"MyRequest" sender:nil];
}

- (IBAction)nearby:(id)sender {
    [self performSegueWithIdentifier:@"Maps" sender:nil];
}

- (IBAction)reporter:(id)sender {
    [self performSegueWithIdentifier:@"Reporter" sender:nil];
}

- (IBAction)infoTapped:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alert addAction:[UIAlertAction actionWithTitle:@"About" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIAlertAction* ac = [UIAlertAction actionWithTitle:@"Dismiss" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        [self presentViewController:[CS createAlert:@"GNALET" :@"GHALET version 1.01" actions:@[ac]] animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Feedback" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIAlertAction* ac = [UIAlertAction actionWithTitle:@"Dismiss" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        [self presentViewController:[CS createAlert:@"GNALET" :@"GHALET version 1.01" actions:@[ac]] animated:YES completion:nil];
    }]];
        alert.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:alert animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [alert popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.infobutt;
    popController.delegate = self;


    
}


@end
