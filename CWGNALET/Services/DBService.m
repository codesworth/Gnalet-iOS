//
//  DBService.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "DBService.h"
#import "CWGNALET-Swift.h"

@implementation DBService


#pragma mark:- DatabaseRefs




+(instancetype)service{
    static DBService* serve = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serve = [[DBService alloc]init];
        [self getMainref];
    });
    
    return serve;
    
}

-(void)setMainRef:(FIRFirestore *)mainRef
{
    self.mainRef = mainRef;
}


+(FIRFirestore *)getMainref
{
    return [FIRFirestore firestore];
}


-(FIRCollectionReference*)getUserRef
{
    return [[DBService getMainref] collectionWithPath:@"Users"];
}

-(FIRCollectionReference*)getCaseref
{
    return [[DBService getMainref]collectionWithPath:@"Cases"];
    
}

-(void)saveUser:(NSString *)uid username:(NSString *)name imgLnk:(NSString *)link
{
    NSDictionary* d = @{CS.C.REF_ID_USERNAME:name,CS.C.REF_ID_IMG_LNK:link };
    [[[self getUserRef]documentWithPath:uid] setData:d options:[FIRSetOptions merge]];
}

@end
