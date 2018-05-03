//
//  SetDriViewController.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/9.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "SetDriViewController.h"
#import "FMDataTool.h"
#import "SetDriInfo.h"
#import "SetDriScopeView.h"
#import "SetDriTableViewCell.h"
@interface SetDriViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic,   weak) SetDriScopeView *editView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end

@implementation SetDriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置下单范围";
    self.listArr = [[FMDataTool sharedDataBase]getAllDriInfo].mutableCopy;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView reloadData];
    for (UIButton *btn in self.btns) {
        [btn setLayerWithW:3 andColor:BordColor andBackW:0.5];
    }
    [self setupPopView];
}
#pragma mark -- CustomPopView
- (void)setupPopView{
    SetDriScopeView *popV = [SetDriScopeView creatSetDriView];
    popV.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    popV.back = ^(BOOL isAdd, id model) {
        if (isAdd) {
            if ([model isKindOfClass:[NSDictionary class]]) {
                id key = [model allKeys][0];
                [self.listArr setObject:model[key] atIndexedSubscript:[key intValue]-1];
            }else{
                [self.listArr addObject:model];
            }
            [self.tableView reloadData];
        }
        [self dismissCustomView];
    };
    [self.view addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(0);
    }];
    self.editView = popV;
}
//change弹出frame
- (void)openAndDismissPopView:(BOOL)isYes{
    if (isYes) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SDevHeight);
            }];
            [self.editView layoutIfNeeded];//强制绘制
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self.editView layoutIfNeeded];//强制绘制
        }];
    }
}

- (void)openCustomView{
    [self openAndDismissPopView:YES];
}

- (void)dismissCustomView{
    [self openAndDismissPopView:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetDriTableViewCell *cusCell = [SetDriTableViewCell cellWithTableView:tableView];
    cusCell.info = self.listArr[indexPath.row];
    return cusCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SetDriInfo * info = self.listArr[indexPath.row];
    self.editView.index = (int)indexPath.row+1;
    self.editView.info = info;
    [self openCustomView];
}
//左滑可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SetDriInfo *info = self.listArr[indexPath.row];
        [self.listArr removeObject:info];
        [[FMDataTool sharedDataBase]deleteDriInfo:info];
        [self.tableView reloadData];
    }
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (IBAction)addClick:(id)sender {
    self.editView.index = 0;
    self.editView.info = [SetDriInfo new];
    [self openCustomView];
}

- (IBAction)sureClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
