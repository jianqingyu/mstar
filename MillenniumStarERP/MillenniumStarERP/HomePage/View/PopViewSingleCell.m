//
//  PopViewSingleCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "PopViewSingleCell.h"

@implementation PopViewSingleCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"singleCell";
    PopViewSingleCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[PopViewSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PopViewSingleCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setCellWithInfo:(NSArray *)list forInPath:(NSIndexPath *)indexPath atIdx:(NSInteger)index{
    if (list.count){
        self.tagView.preferredMaxLayoutWidth = SDevWidth;
        self.tagView.padding   = UIEdgeInsetsMake(10, 10, 10, 10);
        self.tagView.insets    = 12;
        self.tagView.lineSpace = 8;
        self.tagView.section = indexPath.section;
        [self.tagView removeAllTags];
        //Add Tags
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             SKTag *tag = [SKTag tagWithText:obj];
             if(idx == index){
                 tag.textColor = MAIN_COLOR;
                 tag.Img = [UIImage imageNamed:@"iocn_lsel"];
             }else{
                 tag.textColor = [UIColor darkGrayColor];
                 tag.Img = [UIImage imageNamed:@"iocn_lsel2"];
             }
             tag.fontSize = 12;
             tag.padding = UIEdgeInsetsMake(6.5, 5.5, 6.5, 5.5);
             [self.tagView addTag:tag];
         }];
    }
}

@end
