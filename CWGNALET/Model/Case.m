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


-(instancetype)initWithDocument:(NSMutableDictionary *)doc
{
    self = [super init];
    if (self) {
        self.c_id = [doc objectForKey:CS.C.CASE_ID];
        self.c_title = [doc objectForKey :CS.C.CASE_NAME];
        self.c_imageLink = [doc objectForKey:CS.C.CASE_IMGLNK];
        self.c_description = [doc objectForKey:CS.C.CASE_DESC];
        self.sup_body = [doc objectForKey:CS.C.CASE_SUP_BODY];
        self.status = 
        (Status)[doc objectForKey:CS.C.CASE_STATUS];
        self.upVotes = (NSUInteger)[doc objectForKey:CS.C.CASE_UP_VOTES];
        self.downVotes = (NSUInteger)[doc objectForKey:CS.C.CASE_DOWN_VOTES];
    
        
    }
    return self;
}

@end
