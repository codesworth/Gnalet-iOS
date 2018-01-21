//
//  Users.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Predefs.h"
@interface Users : NSObject

@property(nonatomic,strong,nonnull)NSString* uid;
@property(nonatomic,strong,nonnull)NSString* username;
@property(nonatomic,strong,nullable)NSString* imgLnk;
@property(nonatomic, strong,nullable)NSNumber* gcPoints;

-(instancetype _Nonnull )initWithData:(NSDictionary*_Nonnull)data;

@end
