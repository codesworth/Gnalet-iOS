//
//  Users.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "Users.h"

@implementation Users

-(instancetype)init
{
    return [super init];
}

-(instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.uid = [data objectForKey:CS.C.USER_UID__];
        self.username = [data objectForKey:CS.C.REF_ID_USERNAME];
        //self.firstname = [data objectForKey:@"firstname"];
        self.lastname = [data objectForKey:@"lastname"];
        self.email = [data objectForKey:@"email"];
        self.imgLnk = [data objectForKey:CS.C.REF_ID_IMG_LNK];
        self.gcPoints = [data objectForKey:CS.C.REF_GC_POINTS];
        _phone = [data objectForKey:@"phone"];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _uid = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(uid))];
        _username = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userName))];
        //_firstname = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(firstname))];
        _lastname = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lastname))];
        _email = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(email))];
        _imgLnk = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imgLnk))];
        _gcPoints = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imgLnk))];
        _phone = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(phone))];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uid forKey:NSStringFromSelector(@selector(uid))];
    [aCoder encodeObject:_username forKey:NSStringFromSelector(@selector(userName))];
    //[aCoder encodeObject:_firstname forKey:NSStringFromSelector(@selector(firstname))];
    [aCoder encodeObject:_lastname forKey:NSStringFromSelector(@selector(lastname))];
    [aCoder encodeObject:_email forKey:NSStringFromSelector(@selector(email))];
    [aCoder encodeObject:_imgLnk forKey:NSStringFromSelector(@selector(imgLnk))];
    [aCoder encodeObject:_gcPoints forKey:NSStringFromSelector(@selector(gcPoints))];
    [aCoder encodeObject:_phone forKey:NSStringFromSelector(@selector(phone))];
}

@end
