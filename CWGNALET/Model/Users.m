//
//  Users.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "Users.h"

@implementation Users

-(instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.uid = [data objectForKey:CS.C.USER_UID__];
        self.username = [data objectForKey:CS.C.REF_ID_USERNAME];
        self.imgLnk = [data objectForKey:CS.C.REF_ID_IMG_LNK];
        self.gcPoints = [data objectForKey:CS.C.REF_GC_POINTS];
    }
    return self;
}

@end
