//
//  DBService.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeDefs.h"
#import "Users.h"

@import Firebase;
@import FirebaseFirestore;
@import FirebaseStorage;
@import FirebaseDatabase;



@interface DBService : NSObject

@property (nonatomic, strong, nonnull)FIRFirestore* mainRef;
@property (nonatomic, strong, nonnull)FIRCollectionReference* userRef;
@property (nonatomic, strong, nonnull)FIRCollectionReference* caseRef;

+(FIRFirestore*_Nonnull)getMainref;

-(FIRCollectionReference*_Nonnull)getCaseref;
-(NSString* _Nonnull)getCaseKey;

+(instancetype _Nonnull)service;

-(FIRDatabaseReference*_Nonnull)realTimeDBRef;

-(void)reportCase:(Case* _Nullable)aCase body:(NSString* _Nonnull)body imgData:(NSData* _Nullable)data onFinish:(ExecuteAfterFinish _Nullable)finish error:(ErrorBlock _Nullable)errorblock;
-(void)fetchReport:(NSString* _Nonnull)key onFinish:(CaseBlock _Nullable)finish;
-(void)fetchMyReports:(ReportsBlock _Nonnull)completion;

-(void)saveUser:(NSString* _Nonnull)uid username:(NSString* _Nonnull)name imgLnk:(NSString* _Nonnull)link;

-(void)downChanges:(NSString* _Nonnull)caseID upvotes:(NSDictionary* _Nonnull)votes onFinish:(ExecuteAfterFinish _Nullable)finish;

-(void)upvotesChanges:(NSString*_Nonnull)caseID upvotes:(NSDictionary*_Nonnull)votes onFinish:(ExecuteAfterFinish _Nullable)finish;

-(void)fetchUser:(NSString*_Nonnull)uid completion:(ExecuteAfterFinish _Nonnull )handler;
-(void)saveUserAccount:(Users*_Nonnull)user onF:(ExecuteAfterFinish _Nonnull)finish;
+(NSString*_Nullable)userDataFilePath;

@end
