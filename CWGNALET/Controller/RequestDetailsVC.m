//
//  RequestDetailsVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "RequestDetailsVC.h"

@interface RequestDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *reqTitle;
@property (weak, nonatomic) IBOutlet UITextView *reqDetail;
@property (weak, nonatomic) IBOutlet UILabel *reqDaterep;
@property (weak, nonatomic) IBOutlet UIButton *reqStatus;

@property (weak, nonatomic) IBOutlet UIButton *upvoteButt;
@property (weak, nonatomic) IBOutlet UILabel *uplable;
@property (weak, nonatomic) IBOutlet UIButton *dwnButt;
@property (weak, nonatomic) IBOutlet UILabel *dwnlable;
@property (weak, nonatomic) IBOutlet UILabel *reporter;

@end

@implementation RequestDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.reqStatus setUserInteractionEnabled:NO];
    [self updateUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateUI
{
    [self.reqTitle setText:_acase.c_title];
    [self.reqDetail setText:_acase.c_description];
    [self.reqDaterep setText:[NSString stringWithFormat:@"Request made on %@ by %@.", [self getDateStringFromDate], _acase.reporter]];
    NSUInteger up = [_acase.upVotes count] - 1;
    NSUInteger dwn = [_acase.upVotes count] - 1;
    [_dwnlable setText:[NSString stringWithFormat:@"%lu", (unsigned long)dwn]];
    [_uplable setText:[NSString stringWithFormat:@"%lu", (unsigned long)up]];
    [self.reqStatus setTitle:[self status] forState:(UIControlStateNormal)];
    
}


-(NSString* )status{
    NSLog(@"The status is %lu", _acase.status);
    if (_acase.status == unsolved) {
        return @"UNSOLVED";
    }else if (_acase.status == solved){
        return @"SOLVED";
    }else if (_acase.status == reopened){
        return @"REOPENED";
    }else{
        return @"UNKNOWN";
    }
}

-(IBAction)uplablePressed:(id)sender
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([_acase.upVotes objectForKey:uid]){
        
    }else{
        if ([_acase.downVotes objectForKey:uid]) {
            NSMutableDictionary* dr = [_acase.downVotes mutableCopy];
            [dr removeObjectForKey:uid];
            [_acase setDownVotes:dr];
            NSMutableDictionary* ur = [_acase.upVotes mutableCopy];
            [ur setObject:@YES forKey:uid];
            [_acase setUpVotes:ur];
            [[DBService service] upvotesChanges:_acase.c_id upvotes:_acase.upVotes onFinish:nil];
            [[DBService service] downChanges:_acase.c_id upvotes:_acase.downVotes onFinish:nil];
            NSUInteger up = [_acase.upVotes count] - 1;
            NSUInteger dwn = [_acase.downVotes count] - 1;
            [_dwnlable setText:[NSString stringWithFormat:@"%lu", (unsigned long)dwn]];
            [_uplable setText:[NSString stringWithFormat:@"%lu", (unsigned long)up]];

        }else{
            NSMutableDictionary* ur = [_acase.upVotes mutableCopy];
            [ur setObject:@YES forKey:uid];
            [_acase setUpVotes:ur];
            [[DBService service] upvotesChanges:_acase.c_id upvotes:_acase.upVotes onFinish:nil];
            NSUInteger up = [_acase.upVotes count] - 1;
            //NSUInteger dwn = [_acase.upVotes count];
            //[_dwnlable setText:[NSString stringWithFormat:@"%lu", (unsigned long)dwn]];
            [_uplable setText:[NSString stringWithFormat:@"%lu", (unsigned long)up]];

        }
    }
}


-(IBAction)downlablePressed:(id)sender
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([_acase.downVotes objectForKey:uid]){
        
    }else{
        if ([_acase.upVotes objectForKey:uid]) {
            NSMutableDictionary* dr = [_acase.upVotes mutableCopy];
            [dr removeObjectForKey:uid];
            _acase.upVotes = dr;
            NSMutableDictionary* ur = [_acase.downVotes mutableCopy];
            [ur setObject:@YES forKey:uid];
            [_acase setDownVotes:ur];
            [[DBService service] upvotesChanges:_acase.c_id upvotes:_acase.upVotes onFinish:nil];
            [[DBService service] downChanges:_acase.c_id upvotes:_acase.downVotes onFinish:nil];
            NSUInteger up = [_acase.upVotes count] - 1;
            NSUInteger dwn = [_acase.downVotes count] - 1;
            [_dwnlable setText:[NSString stringWithFormat:@"%lu", (unsigned long)dwn]];
            [_uplable setText:[NSString stringWithFormat:@"%lu", (unsigned long)up]];

            
        }else{
            NSMutableDictionary* ur = [_acase.downVotes mutableCopy];
            [ur setObject:@YES forKey:uid];
            [_acase setDownVotes:ur];
            [[DBService service] downChanges:_acase.c_id upvotes:_acase.downVotes onFinish:nil];
            //NSUInteger up = [_acase.upVotes count];
            NSUInteger dwn = [_acase.downVotes count]-1;
            [_dwnlable setText:[NSString stringWithFormat:@"%lu", (unsigned long)dwn]];
            //[_uplable setText:[NSString stringWithFormat:@"%lu", (unsigned long)up]];

        }
    }
}



-(NSString*)getDateStringFromDate
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        // Output: 2011-05-01 13:15:08
        dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm";
    });
    
    return [dateFormatter stringFromDate:_acase.date];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
