//
//  DBService.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;
@import FirebaseFirestore;

@interface DBService : NSObject

@property (nonatomic, strong, nonnull)FIRFirestore* mainRef;
@property (nonatomic, strong, nonnull)FIRCollectionReference* userRef;
@property (nonatomic, strong, nonnull)FIRCollectionReference* caseRef;

+(FIRFirestore*_Nonnull)getMainref;
-(FIRCollectionReference*_Nonnull)getUserRef;
-(FIRCollectionReference*_Nonnull)getCaseref;

+(instancetype _Nonnull)service;



-(void)saveUser:(NSString* _Nonnull)uid username:(NSString* _Nonnull)name imgLnk:(NSString* _Nonnull)link;


@end
