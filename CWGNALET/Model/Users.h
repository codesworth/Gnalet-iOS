//
//  Users.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWGNALET-Swift.h"
@interface Users : NSObject <NSCoding>

@property(nonatomic,strong,nonnull)NSString* uid;
@property(nonatomic,strong,nonnull)NSString* username;
//@property(nonatomic,strong,nullable)NSString* firstname;
@property(nonatomic,strong,nullable)NSString* lastname;
@property(nonatomic,strong,nullable)NSString* email;
@property(nonatomic,strong,nullable)NSString* imgLnk;
@property(nonatomic, strong,nullable)NSNumber* gcPoints;
@property(nonatomic, strong,nullable)NSString* phone;

-(instancetype _Nonnull )initWithData:(NSDictionary*_Nonnull)data;

@end
