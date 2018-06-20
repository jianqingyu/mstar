//
//  UserOrderListVC.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/23.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,SecondeViewControllerChartType) {
    SecondeViewControllerChartTypeColumn =0,
    SecondeViewControllerChartTypeBar,
    SecondeViewControllerChartTypeArea,
    SecondeViewControllerChartTypeAreaspline,
    SecondeViewControllerChartTypeLine,
    SecondeViewControllerChartTypeSpline,
    SecondeViewControllerChartTypeStepLine,
    SecondeViewControllerChartTypeStepArea,
    SecondeViewControllerChartTypeScatter,
};
@interface UserOrderListVC : BaseViewController
@property (nonatomic, assign) SecondeViewControllerChartType chartType;
@end
