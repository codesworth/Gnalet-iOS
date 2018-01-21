//
//  Case.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger,Status) {
    opened = 0,
    closed,
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
@property (nonatomic, nonnull, strong)NSString* c_imageLink;
@property (nonatomic, nonnull, strong)NSString* sup_body;
@property (nonatomic)NSUInteger upVotes;
@property (nonatomic)NSUInteger downVotes;
@property (nonatomic)Status status;
@property (nonatomic, nonnull, strong)NSString* reporter;
@property(nonatomic)CaseCategory  category;

-(instancetype _Nonnull )init;

-(instancetype _Nonnull )initWithDocument:(NSMutableDictionary* _Nonnull)doc;

@end
