//
//  Case.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger,Status) {
    unsolved = 0,
    solved,
    reopened,
    unknown,
    classified,
};

typedef NS_ENUM(NSUInteger, CaseCategory) {
    Road_Transport = 0,
    Garbage_Waste,
    Street_Light,
    Public_Safety,
    General_Maintenance,
    Electricity,
    Water_Sanitation
    
};

@interface Case : NSObject

#pragma mark:- IVARS

@property (nonatomic, nonnull, strong)NSString* c_id;
@property (nonatomic, nonnull, strong)NSString* c_title;
@property (nonatomic, nonnull, strong)NSString* c_description;
@property (nonatomic, nullable, strong)NSString* c_imageLink;
@property (nonatomic, nonnull, strong)NSString* sup_body;
@property (nonatomic,nonnull, strong)NSDictionary* upVotes;
@property (nonatomic, nonnull, strong)NSDictionary* downVotes;
@property (nonatomic)Status status;
@property (nonatomic, nonnull, strong)NSString* reporter;
@property (nonatomic, nonnull, strong)NSString* reporterUID;
@property(nonatomic, strong,nullable)NSDictionary*  extras;
@property (nonatomic, nonnull, strong)NSDate* date;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic,strong) NSString* location;
//@property (nonatomic) NSUInteger upcount;
//@property (nonatomic) NSUInteger dwncount;
-(instancetype _Nonnull )init;

-(instancetype _Nonnull )initWithDocument:(NSDictionary* _Nonnull)doc;


@end
