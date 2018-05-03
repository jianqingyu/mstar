//
//  FMDataTool.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/3.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetDriInfo.h"
@interface FMDataTool : NSObject
+ (instancetype)sharedDataBase;

#pragma mark - driInfo
- (void)addDriInfo:(SetDriInfo *)dri;
- (void)deleteDriInfo:(SetDriInfo *)dri;
- (void)updateDriInfo:(SetDriInfo *)dri;
- (NSMutableArray *)getInfoArrFromSql:(NSString *)sql;
- (NSMutableArray *)getAllDriInfo;
- (NSMutableArray *)getAllSelDriInfo;
@end
