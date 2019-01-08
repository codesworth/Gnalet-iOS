//
//  TypeDefs.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 2/22/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

#ifndef TypeDefs_h
#define TypeDefs_h
#import "Case.h"

typedef void(^ErrorBlock)(NSError* _Nullable error);
typedef void (^ExecuteAfterFinish)(id _Nullable object);
typedef void(^Execute)(void);
typedef void(^CaseBlock)(Case* _Nullable aCase);
typedef  void(^ReportsBlock)(NSMutableArray<Case*>* _Nullable);

#endif /* TypeDefs_h */
