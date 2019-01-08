//
//  ReportAnnotation.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 2/23/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#import "ReportAnnotation.h"

@implementation ReportAnnotation

- (instancetype)init
{
    return [super init];
}




-(instancetype)initWith:(CLLocationCoordinate2D)coordinate title:(NSString *)title uid:(NSString*)uid
{
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.caseID= uid;
        
    }
    return self;
}

@end
