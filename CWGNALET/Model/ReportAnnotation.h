//
//  ReportAnnotation.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 2/23/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface ReportAnnotation : NSObject<MKAnnotation>

@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString* _Nonnull title;
@property(nonatomic, strong)NSString* _Nonnull caseID;


-(instancetype _Nonnull )init;

-(instancetype _Nonnull )initWith:(CLLocationCoordinate2D)coordinate title:(NSString* _Nonnull)title uid:(NSString*_Nonnull)uid;

@end
