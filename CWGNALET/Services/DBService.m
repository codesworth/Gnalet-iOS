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


-(FIRStorageReference*)getMainStorageBucket
{
    return [[FIRStorage storage] reference];
}


-(FIRCollectionReference*)getReporterRef
{
    return [[DBService getMainref] collectionWithPath:@"Reporters"];
}

-(FIRDatabaseReference *)realTimeDBRef
{
    return [[[FIRDatabase database] reference] child:@"Locations"];
}

-(FIRCollectionReference*)getSupBodyRef
{
    return [[DBService getMainref] collectionWithPath:CS.C.REF_SUP_BODY];
}

-(FIRCollectionReference*)getSupunsolvedRef:(NSString*)body{
    return [[[[DBService getMainref] collectionWithPath:CS.C.REF_SUP_BODY]documentWithPath:body]collectionWithPath:CS.C.REF_SUP_UNSOLVED];
}

-(FIRCollectionReference*)getCaseref
{
    return [[DBService getMainref]collectionWithPath:@"Cases"];
    
}

-(void)setAnonyUserAccount:(NSString*)uid
{
    [[[self getReporterRef]documentWithPath:uid]setData:@{CS.C.REF_ID_USERNAME:CS.C.USER_ANONYMOX, @"firstname":@"", @"lastname": @"", @"email":@""} options:[FIRSetOptions merge]];
}

-(void)saveUserAccount:(Users*)user onF:(ExecuteAfterFinish)finish
{
    NSDictionary* data = @{
                           CS.C.REF_ID_USERNAME: user.username,
                           @"lastname":user.lastname,
                           @"email":user.email,
                           @"phone":user.phone
                           };
    [[[self getReporterRef]documentWithPath:user.uid]setData:data options:[FIRSetOptions merge] completion:^(NSError * _Nullable error) {
        finish(error);
    }];
}

+(NSString *)userDataFilePath
{
    NSString *docDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"User/user.plist"];
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:docDir isDirectory:&isDir]) {
        
    }else{
        [[NSFileManager defaultManager]createFileAtPath:docDir contents:nil attributes:nil];
    }
    
    return docDir;
}


-(NSNumber*)caseStatus:(Status)status
{
    switch (status) {
        case unsolved:
            return [NSNumber numberWithUnsignedInteger:0];
        case solved:
            return [NSNumber numberWithUnsignedInteger:1];
        case reopened:
            return [NSNumber numberWithUnsignedInteger:2];
        case unknown:
            return [NSNumber numberWithUnsignedInteger:3];
        case classified:
            return [NSNumber numberWithUnsignedInteger:4];
        default:
            return [NSNumber numberWithUnsignedInteger:5];
    }
}


-(void)upvotesChanges:(NSString*)caseID upvotes:(NSDictionary*)votes onFinish:(ExecuteAfterFinish _Nullable)finish
{
    [[_caseRef documentWithPath:caseID]updateData:votes completion:^(NSError * _Nullable error) {
        if (error == nil) {
            finish(nil);
        }
    }];
}

-(void)downChanges:(NSString* _Nonnull)caseID upvotes:(NSDictionary* _Nonnull)votes onFinish:(ExecuteAfterFinish _Nullable)finish
{
    [[_caseRef documentWithPath:caseID]updateData:votes completion:^(NSError * _Nullable error) {
        if (error == nil) {
            finish(nil);
        }
    }];
}



-(void)uploadCaseImage:(NSData* _Nonnull)data caseID:(NSString*)cid id:(NSString*)identifier onFinish:(ExecuteAfterFinish _Nullable)finish
{
    FIRStorageReference* ref = [[self getMainStorageBucket]child:identifier];
    FIRStorageUploadTask* task = [ref putData:data metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error uploading Imaging");
        }else{
            [[[self getCaseref]documentWithPath:cid]updateData:@{CS.C.CASE_IMGLNK : metadata.downloadURL.absoluteString}];
            finish(nil);
        }
    }];
    
}


-(void)reportCase:(Case *)aCase body:(NSString*)body imgData:(NSData*)data onFinish:(ExecuteAfterFinish _Nullable)finish error:(ErrorBlock)errorblock
{
    NSString* identifier = [NSString stringWithFormat:@"%@/%@.png", body,aCase.c_id];
    NSLog(@"The case report Key is %@", aCase.c_id);
    NSDictionary* docs = @{
                           CS.C.CASE_NAME : aCase.c_title,
                           CS.C.CASE_DESC : aCase.c_description,
                           CS.C.CASE_STATUS : [self caseStatus:aCase.status],
                           CS.C.CASE_IMGLNK : aCase.c_imageLink,
                           CS.C.CASE_SUP_BODY : aCase.sup_body,
                           CS.C.CASE_UP_VOTES : aCase.upVotes,
                           CS.C.CASE_DOWN_VOTES : aCase.downVotes,
                           CS.C.REF_DATE : aCase.date,
                           CS.C.REF_XTRAS : aCase.extras,
                           CS.C.REF_REPORTER : aCase.reporter,
                           CS.C.USER_UID__ : aCase.reporterUID,
                           CS.LATITUDE: [NSNumber numberWithDouble:aCase.latitude],
                           CS.LONGITUDE: [NSNumber numberWithDouble:aCase.longitude],
                           CS.LOCATION:aCase.location
                           };
    [[[self getCaseref] documentWithPath:aCase.c_id]setData:docs options:[FIRSetOptions merge] completion:^(NSError * _Nullable error) {
        if (error == nil) {
            
            NSLog(@"The case report Key is %@", aCase.c_id);
            [[[[[self getReporterRef]documentWithPath:aCase.reporterUID]collectionWithPath:CS.C.REF_REPORTS] documentWithPath:aCase.c_id] setData:@{aCase.c_id:@YES} options:[FIRSetOptions merge]];
            NSDictionary* d = @{@"id":aCase.c_id, @"ts":[NSNumber numberWithDouble:[CS unix_epoch_ts]]};
            [[[self getSupunsolvedRef:body] documentWithPath:aCase.c_id] setData:d options:[FIRSetOptions merge]];
            finish(nil);
        }else{
            errorblock(error);
        }
    }];
    [self uploadCaseImage:data caseID:aCase.c_id id:identifier onFinish:^(id _Nullable object){
        //finish();
    }];
}

-(void)fetchReport:(NSString *)key onFinish:(CaseBlock)finish
{
    [[[self getCaseref] documentWithPath:key]getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if ([snapshot exists]) {
            NSLog(@"Thesnapshot is %@",snapshot);
            NSDictionary* dict = [snapshot data];
            Case* acase = [[Case alloc]initWithDocument:dict];
            finish(acase);
        }
    }];
}

-(void)fetchMyReports:(ReportsBlock)completion
{
    NSMutableArray<Case*>* arr = [NSMutableArray new];
    __block NSUInteger counter = 0;
    NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:CS.C.USER_UID__];
    [[[[self getReporterRef]documentWithPath:uid]collectionWithPath:CS.C.REF_REPORTS]getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshots, NSError * _Nullable error) {
        if (!snapshots.isEmpty) {
            //NSDictionary* sd = [snapshots.doc data]
            for (FIRDocumentSnapshot* dsn in snapshots.documents) {
                NSLog(@"The snapshot is %@",snapshots.documents);
                NSLog(@"The Key is %@",dsn.documentID);
                //FIRDocumentReference* rf = [[self caseRef]documentWithPath:dsn.documentID];
            
//                NSLog(@"The demon that has taken my day %@", rf);
//                [[[self caseRef]documentWithPath:dsn.documentID]getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
//                    NSLog(@"Smnap shit is %@",snapshot.data);
//                }];
                [[[self getCaseref]documentWithPath:dsn.documentID]getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable resnapshot, NSError * _Nullable error) {
                    NSLog(@"Tleat we got here");
                    if ([resnapshot exists]){
                        counter++;
                        Case* acase = [[Case alloc]initWithDocument:resnapshot.data];
                        [arr addObject:acase];
                        
                        if (counter == snapshots.documents.count) {
                            completion(arr);
                        }
                    }
                }];
            }
        }
    }];
}


-(NSString *)getCaseKey
{
    FIRDocumentReference* key = [[self getCaseref]documentWithAutoID];
    return [key documentID];
}

-(void)saveUser:(NSString *)uid username:(NSString *)name imgLnk:(NSString *)link
{
    NSDictionary* d = @{CS.C.REF_ID_USERNAME:name,CS.C.REF_ID_IMG_LNK:link };
    [[[self getReporterRef]documentWithPath:uid] setData:d options:[FIRSetOptions merge]];
}

-(void)fetchUser:(NSString*)uid completion:(ExecuteAfterFinish)handler
{
    [[[self getReporterRef]documentWithPath:uid]getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error == nil && snapshot.exists){
            Users* user = [[Users alloc]initWithData:snapshot.data];
            handler(user);
        }
    }];
}

@end
