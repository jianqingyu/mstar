//
//  ScreenPopView.h
//  MillenniumStarERP
//
//  Created by yjq on 16/9/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#define COLUMN 4
#define ROWHEIHT 30
#define ROWSPACE 10
#define ROWWIDTH (SDevWidth - (COLUMN+1)*ROWSPACE)/COLUMN
typedef void (^ScreenPopViewBack)(NSDictionary *dic);
@interface ScreenPopView : UIView
@property (nonatomic,copy) NSArray *list;
@property (nonatomic,copy)ScreenPopViewBack popBack;
@end
