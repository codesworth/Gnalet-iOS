//
//  MapsVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 30/03/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "MapsVC.h"

@interface MapsVC ()<CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *moptions;
@property (weak, nonatomic) IBOutlet UISegmentedControl *optionsseg;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic) BOOL mapHasCenteredOnce;
@property (nonatomic) BOOL myLocation;
@property (strong, nonatomic) GMSCameraPosition *camera;
@property (strong, nonatomic) GeoFire* geoFire;
@property (strong, nonatomic) NSMutableDictionary<NSString*, Case*>* nearByCases;
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) NSMutableArray<Case*>* cases;


@end

@implementation MapsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapHasCenteredOnce = NO;
    _locationManager = [CLLocationManager new];
    _nearByCases = [NSMutableDictionary new];
    _cases = [NSMutableArray new];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    _locationManager.delegate = self;
 _geoFire = [[GeoFire alloc]initWithFirebaseRef:[[DBService service]realTimeDBRef]];
    _camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:12];
    _mapView = [GMSMapView mapWithFrame:self.view.frame camera:_camera];
    _mapView.myLocationEnabled = YES;
    [self.view addSubview:_mapView];
    [_mapView setDelegate:self];
    [self locationAuthorization];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:_moptions];
    //[self.tableview setFrame:self.view.frame];
    
}

- (IBAction)optionsChanged:(id)sender {
    UISegmentedControl* segy = (UISegmentedControl*)sender;
    if (segy.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:_mapView];
    }else{
        [self.view bringSubviewToFront:_tableview];
    }
}

-(void)locationAuthorization
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    }else{
        [_locationManager requestWhenInUseAuthorization];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    }
}


//- (void)loadView {
//    // Create a GMSCameraPosition that tells the map to display the
//    // coordinate -33.86,151.20 at zoom level 6.
//    _camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:12];
//    _mapView = [GMSMapView mapWithFrame:self.view.frame camera:_camera];
//    _mapView.myLocationEnabled = YES;
//    [self.view addSubview:_mapView];
//    //[_mapView addSubview:_mview];
//    [_mapView setDelegate:self];
//    // Creates a marker in the center of the map.
//    
//}


- (void)showReport:(CLLocation*)location
{
    GFCircleQuery* query = [_geoFire queryAtLocation:location withRadius:5];
    [query observeEventType:(GFEventTypeKeyEntered) withBlock:^(NSString * _Nonnull key, CLLocation * _Nonnull location) {
        NSLog(@"The Indexed keyKey is %@",key);
        [[DBService service] fetchReport:key onFinish:^(Case * _Nullable aCase) {
            if (aCase){
                [self gen_set_Marker:aCase];
                [self updateCaseArray:aCase];
                [_nearByCases setObject:aCase forKey:key];
            
            }
        }];
    }];
}

-(void)gen_set_Marker:(Case*)acase
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(acase.latitude, acase.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.title = acase.c_title;
    marker.userData = acase;
    [marker setMap:self.mapView];
}
-(void)updateCaseArray:(Case*)acase
{
    if (![_cases containsObject:acase]) {
        [_cases addObject:acase];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count > 0){
        CLLocation* location = [locations lastObject];
        _myLocation = location;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        marker.title = @"My Location";
        //marker.snippet = @"Australia";
        marker.map = _mapView;
        _camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:15];
        [_mapView setCamera:_camera];
        [self showReport:location];
        [manager stopUpdatingLocation];
        
    }
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    Case* mcase = marker.userData;
    [self performSegueWithIdentifier:@"isseudet" sender:mcase];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}

#pragma mark:- UITABLEVIEW Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cases.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Case* acase = [_cases objectAtIndex:indexPath.row];
    IssuesCells* cells = (IssuesCells*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IssuesCells class]) forIndexPath:indexPath];
    [cells configureCells:acase];
    return cells;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Case* acase = [_cases objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"isseudet" sender:acase];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"isseudet"]) {
        Case* acase = (Case*)sender;
        RequestDetailsVC* vc = [segue destinationViewController];
        [vc setAcase:acase];
    }
}

@end
