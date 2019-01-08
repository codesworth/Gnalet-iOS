//
//  ReporterVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "ReporterVC.h"

@interface ReporterVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstNameTxtField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *lastNameTx;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailRx;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTx;
@property (strong, nonatomic) NSString *uid;
@end

@implementation ReporterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _uid = [[NSUserDefaults standardUserDefaults]stringForKey:CS.C.USER_UID__];
    // Do any additional setup after loading the view.
    [self fetchUser];
    [_emailRx setText:@""];
    _emailRx.delegate = self;
    _phoneTx.delegate = self;
    _firstNameTxtField.delegate = self;
    [_firstNameTxtField setText:@""];
    [_lastNameTx setText:@""];
    [_phoneTx setText:@""];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

-(void) fetchUser
{

    [[DBService service]fetchUser:_uid completion:^(id  _Nullable object) {
        if([object isKindOfClass:[Users class]]){
            Users *user = (Users*)object;
            [[NSUserDefaults standardUserDefaults]setObject:user.username forKey:CS.C.REF_ID_USERNAME];
            [self updateUser:user];
            BOOL did = [NSKeyedArchiver archiveRootObject:user toFile:[DBService userDataFilePath]];
            if (did) {
                NSLog(@"Arcgived succesfiiullu");
            }else{
                NSLog(@"Arcgived Fsilure");
            }
        }
    }];
}

-(void)updateUser:(Users*)user
{
    [self.firstNameTxtField setText:user.username];
    [self.lastNameTx setText:user.lastname];
    [self.emailRx setText:user.email];
    [self.phoneTx setText:user.phone];
}
- (IBAction)userSaved:(id)sender {
    
    if (_phoneTx.text.length > 0 && _phoneTx.text.length != 10) {
        UIAlertAction* ac = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        [self presentViewController:[CS createAlert:@"Error" :@"Please enter a valid phone number if you want to add a phone number" actions:@[ac]] animated:YES completion:nil];
    }else{
        Users* user = [Users new];
        [user setUid:_uid];
        [user setUsername:_firstNameTxtField.text];
        [user setLastname:_lastNameTx.text];
        [user setEmail:_emailRx.text];
        [user setPhone:_phoneTx.text];
        if (_firstNameTxtField.text.length < 1) {
            [user setUsername:CS.C.USER_ANONYMOX];
        }
        [[NSUserDefaults standardUserDefaults]setObject:user.username forKey:CS.C.REF_ID_USERNAME];
        [[DBService service]saveUserAccount:user onF:^(id  _Nullable object) {
            if ([object isKindOfClass:[NSError class]]) {
                [self presentViewController:[CS createAlert:@"Error" :@"Error occurred wiles saving reporter info. Please check your network settings and try again" actions:@[[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}]]] animated:YES completion:nil];
            }else{
                [self presentViewController:[CS createAlert:@"Success" :@"Reporter info succesfully saved" actions:@[[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]]] animated:YES completion:nil];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
