//
//  NearbyVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 1/21/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "NearbyVC.h"

@interface NearbyVC ()<MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic) BOOL mapHasCenteredOnce;
@property (strong, nonatomic) GeoFire* geoFire;
@property (strong, nonatomic) NSMutableDictionary<NSString*, Case*>* nearByCases;
@property (strong, nonatomic) NSMutableArray<Case*>* cases;
@end

@implementation NearbyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _nearByCases = [NSMutableDictionary new];
    _cases = [NSMutableArray new];
    _mapHasCenteredOnce = NO;
    _locationManager = [CLLocationManager new];
    [_mapView setDelegate:self];
    [_mapView setUserTrackingMode:(MKUserTrackingModeFollow)];
    _geoFire = [[GeoFire alloc]initWithFirebaseRef:[[DBService service]realTimeDBRef]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    // Do any additional setup after loading the view.
}

-(void)updateCaseArray:(Case*)acase
{
    if ([_nearByCases objectForKey:acase.c_id] == nil){
        [_cases addObject:acase];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self locationAuthorization];
}

-(void)locationAuthorization
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_mapView setShowsUserLocation:YES];
        [self showReport:[[CLLocation alloc]initWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude]];
    }else{
        [_locationManager requestWhenInUseAuthorization];
        
    }
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_mapView setShowsUserLocation:YES];
    }
}


-(void)centerMapOnLOcation:(CLLocation*)location
{
    MKCoordinateRegion coordinate = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200);
    [_mapView setRegion:coordinate animated:YES];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation.location) {
        [self centerMapOnLOcation:userLocation.location];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView* anoview;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        anoview = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"User"];
        [anoview setImage:[UIImage imageNamed:@"jtatum"]];
    }else if ([mapView dequeueReusableAnnotationViewWithIdentifier:CS.C.ID_CASE_ANNO]){
        anoview = [mapView dequeueReusableAnnotationViewWithIdentifier:CS.C.ID_CASE_ANNO];
        [anoview setAnnotation:annotation];
        
    }else{
        anoview = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:CS.C.ID_CASE_ANNO];
        [anoview setRightCalloutAccessoryView:[UIButton buttonWithType:(UIButtonTypeDetailDisclosure)]];
        [anoview setAnnotation:annotation];
    }
    if ([annotation isKindOfClass:[ReportAnnotation class]]) {
        [anoview setCanShowCallout:YES];
        ReportAnnotation* reno = (ReportAnnotation*)annotation;
        [anoview setImage:[UIImage imageNamed:reno.title]];
        //UIButton* but = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, 30, 30)];
    }
    
    
    return anoview;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[ReportAnnotation class]]) {
        ReportAnnotation* anno = (ReportAnnotation*)view.annotation;
        Case* acase = [_nearByCases objectForKey:anno.caseID];
        [self performSegueWithIdentifier:@"" sender:acase];
    }
}


-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    CLLocation* loc = [[CLLocation alloc]initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    [self showReport:loc];
}

- (void)showReport:(CLLocation*)location
{
    GFCircleQuery* query = [_geoFire queryAtLocation:location withRadius:2.5];
    [query observeEventType:(GFEventTypeKeyEntered) withBlock:^(NSString * _Nonnull key, CLLocation * _Nonnull location) {
        [[DBService service] fetchReport:key onFinish:^(Case * _Nullable aCase) {
            if (aCase){
                [self updateCaseArray:aCase];
                [_nearByCases setObject:aCase forKey:key];
                ReportAnnotation* anno = [[ReportAnnotation alloc]initWith:location.coordinate title:aCase.c_title uid:aCase.c_id];
                
                [_mapView addAnnotation:anno];
            }
        }];
    }];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
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
    MyRequestCells* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyRequestCells class]) forIndexPath:indexPath];
    Case* acase = [_cases objectAtIndex:indexPath.row];
    [cell configure:acase];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Case* acase = [_cases objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"" sender:acase];
}

@end
