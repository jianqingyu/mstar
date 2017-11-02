//
//  PopViewMultipleCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/12.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "PopViewMultipleCell.h"
#import "CommonUtils.h"
@implementation PopViewMultipleCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"multipleCell";
    PopViewMultipleCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[PopViewMultipleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PopViewMultipleCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setCellWithInfo:(NSArray *)list forInPath:(NSIndexPath *)indexPath{
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
             tag.sTextColor = [UIColor whiteColor];
             tag.textColor = [UIColor darkGrayColor];
             tag.bgImg = [CommonUtils createImageWithColor:DefaultColor];
             tag.sBgImg = [CommonUtils createImageWithColor:MAIN_COLOR];
             tag.fontSize = 12;
             tag.cornerRadius = 3;
             tag.padding = UIEdgeInsetsMake(6.5, 5.5, 6.5, 5.5);
             [self.tagView addTag:tag];
         }];
    }
}


@end
