//
//  GenReqVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 2/22/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "GenReqVC.h"

@interface GenReqVC ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *locationField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *describeView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *reporterField;
@property (nonatomic, strong) CLLocationManager* manager;
@property (weak, nonatomic) IBOutlet UIImageView *imageVieew;
@property (strong, nonatomic) IBOutlet UIPickerView *authorityPicker;
@property (strong, nonatomic) NSMutableArray<NSString*>* authorities;
@property (nonatomic) BOOL canPick;
@property (weak, nonatomic) IBOutlet  JVFloatLabeledTextField *authoritButton;
@property (weak, nonatomic) IBOutlet UIButton *picbutton;
@property (nonatomic, strong) NSString* supBody;
@property (nonatomic, strong) NSString* pick;
@property (nonatomic, strong) UIImagePickerController* picker;
@property (nonatomic, strong) GeoFire* geofire;
@property (nonatomic, strong) CLLocation* myLocation;
@property (nonatomic, strong) CLGeocoder* geoCoder;
@property (nonatomic, strong,nullable) UITextField* activeField;
@property (nonatomic)CGFloat keyboardHeight;
@property (nonatomic)CGPoint lastoffset;
@property (weak, nonatomic) IBOutlet  UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *submitButt;
@property (nonatomic, strong) Users* user;
@property(nonatomic)BOOL scrollable;
@property (nonatomic, strong) CCActivityHUD* activityHUD;

@end

@implementation GenReqVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.catTitle];
    _canPick = YES;
    [_authoritButton setDelegate:self];
    NSArray* objs = @[ @"Accra Metropolitan Assembly", @"Tema Metropolitan Assembly"];
    [_locationField setDelegate:self];
    [_authoritButton setDelegate:self];
    [_reporterField setDelegate:self];
    [_describeView setDelegate:self];
    [self setScrollable:YES];
    _geoCoder = [CLGeocoder new];
    _manager = [CLLocationManager new];
    _manager.delegate = self;
    _geofire = [[GeoFire alloc]initWithFirebaseRef:[[DBService service] realTimeDBRef]];
    NSLog(@"Geofire ref %@", _geofire.firebaseRef);
    _authorities = [NSMutableArray arrayWithArray:objs];
    _picker = [UIImagePickerController new];
    _picker.delegate = self;
    UIToolbar* tb = [UIToolbar new];
    [tb setFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(toolbarDone)];
    [tb setItems:@[btn]];
    [_authorityPicker addSubview:tb];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returText:)]];
    [self setUser:[NSKeyedUnarchiver unarchiveObjectWithFile:[DBService userDataFilePath]]];
    [self.reporterField setText:[[NSUserDefaults standardUserDefaults]stringForKey:CS.C.REF_ID_USERNAME]];
    // Do any additional setup after loading the view.
}


-(void)returText:(UIGestureRecognizer*)gesture
{
    if (_activeField) {
        [_activeField resignFirstResponder];
        [self setActiveField:nil];
    }
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self locationAuthorization];
}

-(void)locationAuthorization
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_manager setDesiredAccuracy:(kCLLocationAccuracyBest)];
        [_manager startUpdatingLocation];
    }else{
        [_manager requestWhenInUseAuthorization];
    }
}

-(void)toolbarDone
{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect frame = CGRectMake(0, self.view.frame.size.height + 300, self.view.frame.size.width, 300);
        [_authorityPicker setFrame:frame];
    }];
}


-(void)animatePicker
{
    [UIView animateWithDuration:0.7 animations:^{
        CGRect frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [_authorityPicker setFrame:frame];
    }];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    [_authorityPicker setFrame:frame];
    [self.view addSubview:_authorityPicker];
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


-(BOOL)validateFields
{
    if (_locationField.text.length != 0 > 3 && _authoritButton.text != nil && _describeView.text.length > 10 && _imageVieew.image != nil){
        return YES;
    }
    return NO;
}


- (IBAction)submittPressed:(id)sender {
    
    if ([self validateFields]){
        
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"Adjust" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.activityHUD showWithType:CCActivityHUDIndicatorTypeDynamicArc];
            [self submitIssue];
        }];
        
        UIAlertController* alert = [CS createAlert:@"Confirm" :@"Please confirm that location and details are accurate" actions:@[ac,ac2]];
        [self presentViewController:alert animated:YES completion:^{}];

    }

}

-(void)submitIssue
{
    Case* aCase = [[Case alloc]init];
    NSString* key =[[DBService service]getCaseKey];
    [aCase setC_id:key];
    [aCase setDate:[NSDate date]];
    [aCase setStatus:unsolved];
    [aCase setC_title:self.catTitle];
    [aCase setReporter:_reporterField.text];
    [aCase setUpVotes:@{[[NSUserDefaults standardUserDefaults]stringForKey:CS.C.USER_UID__]: @YES}];
    [aCase setDownVotes:@{[[NSUserDefaults standardUserDefaults]stringForKey:CS.C.USER_UID__]: @YES}];

    [aCase setSup_body:_supBody];
    [aCase setC_description:_describeView.text];
    [aCase setLocation:_locationField.text];
    [aCase setLongitude:_myLocation.coordinate.longitude];
    [aCase setLatitude:_myLocation.coordinate.latitude];
    [aCase setReporterUID:[[NSUserDefaults standardUserDefaults]stringForKey:CS.C.USER_UID__]];
    [aCase setC_imageLink:@""];
    NSDictionary* extras = @{};
    [aCase setExtras:extras];
    NSLog(@"The geofire is %@", _geofire);
    [_geofire setLocation:_myLocation forKey:aCase.c_id];
    NSData* data = UIImageJPEGRepresentation(_imageVieew.image, 0.05);
    NSLog(@"The size of image is %lu", data.length);
    [[DBService service]reportCase:aCase body:[self getBodySup:self.catTitle] imgData:data onFinish:^(id _Nullable object){
        [_activityHUD dismiss];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self presentViewController:[CS createAlert:@"Success" :@"Request was successfully submitted" actions:@[ac]] animated:YES completion:^{}];
    } error:^(NSError * _Nullable error) {
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [self presentViewController:[CS createAlert:@"Error" :@"Error submitting Request. Please make sure you have internet connection and try again" actions:@[ac]] animated:YES completion:^{}];
    }];
}

-(NSString*)getBodySup:(NSString*)str
{
    
    if([str isEqualToString:CS.ABANDONED_ACCIDENT]){
        return @"Vehicular";
    }else if([str isEqualToString:CS.POTHOLES]){
        return @"Potholes";
    }else if([str isEqualToString:CS.SANITATION]){
        return @"Sanitation";
    }else if([str isEqualToString:CS.ECG]){
        return @"ECG";
    }else{
        return @"Others";
    }
}



#pragma mark:- UIPickedelegtes && UITextFieldDelegates


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_authorities count];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* auth = [_authorities objectAtIndex:row];
    return auth;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* pick = [_authorities objectAtIndex:row];
    self.pick = pick;
    [_authoritButton setText:pick];
    if (row == 0){
        _supBody = CS.C.REF_AMA_;
    }else{
        _supBody = CS.C.REF_TMA_;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self setActiveField:textField];
    [self setLastoffset:self.scrollView.contentOffset];
    if (_canPick && textField == _authoritButton){
        [self.view endEditing:YES];
        
        [_authorityPicker setDelegate:self]; [_authorityPicker setDataSource:self];
        [self animatePicker];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_activeField resignFirstResponder];
    [self setActiveField:nil];
    return YES;
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    if (_scrollable) {
        if (_keyboardHeight == 0) {
            //return;
        }
        CGRect ks = ((NSValue*)[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]).CGRectValue;
        [self setKeyboardHeight:ks.size.height];
        [UIView animateWithDuration:0.3 animations:^{
            self.constraintContentHeight.constant = _constraintContentHeight.constant + _keyboardHeight;
        }];
        
        CGFloat db = _scrollView.frame.size.height - _activeField.frame.origin.y - _activeField.frame.size.height;
        CGFloat cols = _keyboardHeight - db;
        
        if (cols < 0) {
            //return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.lastoffset.x, cols + 10);
            //        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
            //        [self.scrollView setContentOffset:bottomOffset animated:YES];
            //[_scrollView scrollToViewWithView:_submitButt animated:YES];
            [_scrollView scrollToBottom];
        }];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self setScrollable:NO];
    return true;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self setScrollable:YES];
    return TRUE;
}


-(void)keyboardWillHide:(NSNotification*)notification
{
    if (_scrollable) {
        [UIView animateWithDuration:0.3 animations:^{
            self.constraintContentHeight.constant = self.constraintContentHeight.constant - _keyboardHeight;
            [_scrollView setContentOffset:_lastoffset];
        }];
        self.keyboardHeight = 0;
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_picbutton setTitle:@"" forState:(UIControlStateNormal)];
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData* data = UIImageJPEGRepresentation(image, 0.05);
    NSLog(@"The size of image is %lu", data.length);
    [_imageVieew setImage:image];
}






-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)picbuttonPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:nil];
    }else{
        [self presentViewController:self.picker animated:YES completion:^{}];
    }
    
}

-(void)setLocation:(CLPlacemark*)placeMark
{
    if (placeMark.subLocality){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationField setText:placeMark.subLocality];
            
        });
    }else if (placeMark.locality){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationField setText:placeMark.locality];
            
        });
    }else if(placeMark.subAdministrativeArea){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationField setText:placeMark.subAdministrativeArea];
            
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationField setText:@"Unknown"];
            
        });
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count > 0){
        CLLocation* location = [locations lastObject];
        _myLocation = location;
        NSLog(@"My location be %d, %@lu, %d",_myLocation.coordinate.longitude, _myLocation.hash, _myLocation.coordinate.longitude);
        //[[[DBService service]realTimeDBRef]updateChildValues:@{@"loc":@"Madmadddd"}];
        [manager stopUpdatingLocation];
        [_manager setDelegate:nil];
        [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error == nil && placemarks){
                CLPlacemark* mark = [placemarks lastObject];
                [self setLocation:mark];
                
            }
        }];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error occured with location servicce %@", error.localizedDescription);
    [manager stopUpdatingLocation];
    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertController* alert = [CS createAlert:@"Error" :@"An Error Occurred Updating location, Check if you have a working cellular network and wifi" actions:@[ac]];
    [self presentViewController:alert animated:YES completion:^{}];
}

//- (void)setLocationValue:(CLLocation *)location
//                  forKey:(NSString *)key
//{
//    NSDictionary *value;
//    NSString *priority;
//    NSLog(@"Location is %@", location.debugDescription);
//    if (location != nil) {
//        NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
//        NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude];
//        NSString *geoHash = [GFGeoHash newWithLocation:location.coordinate].geoHashValue;
//        value = @{ @"l": @[ lat, lng ], @"g": geoHash };
//        priority = geoHash;
//    } else {
//        value = nil;
//        priority = nil;
//    }
//    [[[[DBService service]realTimeDBRef]child:key]updateChildValues:value withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        if (error) {
//            NSLog(@"The error occurred here %@", error);
//        }else{
//            NSLog(@"Succesfull write at %@", value);
//        }
//    }];
//}

@end
