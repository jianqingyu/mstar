//
//  ArrayWithDict.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/10.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ArrayWithDict.h"

@implementation ArrayWithDict

+ (NSArray *)DateWithDict:(NSDictionary *)dict{
    NSMutableArray * mutA = [NSMutableArray new];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"recMaterials"]) {
            NSArray *dictArr = obj[@"list"];
            for (NSDictionary *dict in dictArr) {
                NSArray *arr = @[dict[@"typeName"],dict[@"recMWeight"],dict[@"recMRatio"],dict[@"RecGoldPrice"],dict[@"RecMMoney"]];
                [mutA addObject:arr];
            }
        }
        if ([key isEqualToString:@"recProcessExpenseses"]) {
            NSArray *dictArr = obj[@"list"];
            for (NSDictionary *dict in dictArr) {
                NSArray *arr = @[dict[@"typeName"],dict[@"recPQuantity"],dict[@"recPUPrice"],dict[@"recPFeeAddTotal"],dict[@"sampleFee"],dict[@"recPMoney"]];
                [mutA addObject:arr];
            }
        }
        if ([key isEqualToString:@"recOtherProcessExpenseses"]) {
            NSArray *dictArr = obj[@"list"];
            for (NSDictionary *dict in dictArr) {
                NSArray *arr = @[dict[@"enChase"],dict[@"recOQuantity"],dict[@"recOUPrice"],dict[@"recOMoney"]];
                [mutA addObject:arr];
            }
        }
        if ([key isEqualToString:@"recStones"]) {
            NSArray *dictArr = obj[@"list"];
            for (NSDictionary *dict in dictArr) {
                NSArray *arr = @[dict[@"stoneTypeName"],dict[@"comeFrom"],dict[@"recSStoneSN"],dict[@"recSQuantity"],dict[@"recSWeight"],dict[@"recSUPrice"],dict[@"recSMoney"]];
                [mutA addObject:arr];
            }
        }
    }];
    return mutA.copy;
}

@end
