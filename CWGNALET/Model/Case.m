//
//  Case.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "Case.h"
#import "CWGNALET-Swift.h"

@implementation Case

-(instancetype)init
{
    return [super init];
}


-(instancetype)initWithDocument:(NSDictionary *)doc
{
    self = [super init];
    if (self) {
        self.c_id = [doc objectForKey:CS.C.CASE_ID];
        self.c_title = [doc objectForKey :CS.C.CASE_NAME];
        self.c_imageLink = [doc objectForKey:CS.C.CASE_IMGLNK];
        self.c_description = [doc objectForKey:CS.C.CASE_DESC];
        self.sup_body = [doc objectForKey:CS.C.CASE_SUP_BODY];
        self.status = [self makeStatus:[doc objectForKey:CS.C.CASE_STATUS]];
        self.upVotes = (NSDictionary*)[doc objectForKey:CS.C.CASE_UP_VOTES];
        self.downVotes = (NSDictionary*)[doc objectForKey:CS.C.CASE_DOWN_VOTES];
        self.date = [doc objectForKey:CS.C.REF_DATE];
        self.extras = [doc objectForKey:CS.C.REF_XTRAS];
        self.reporter = [doc objectForKey:CS.C.REF_REPORTER];
        self.reporterUID = [doc objectForKey:CS.C.USER_UID__];
        self.latitude = [(NSNumber*)[doc objectForKey:CS.LATITUDE]doubleValue];
        self.longitude = [(NSNumber*)[doc objectForKey:CS.LONGITUDE]doubleValue];
        self.location = [doc objectForKey:CS.LOCATION];
    }
    return self;
}

-(Status)makeStatus:(NSNumber*) number
{
    NSUInteger num = [number unsignedIntegerValue];
    switch (num) {
        case 0:
            return unsolved;
            case 1:
            return solved;
        case 2:
            return reopened;
        case 3:
            return classified;
            
        default:
            return unknown;
    }
}

@end
