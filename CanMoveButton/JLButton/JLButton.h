//
//  JLButton.h
//  CanMoveButton
//
//  Created by love on 14-9-22.
//  Copyright (c) 2014年 JiangLong23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLButton : UIButton

@property (nonatomic,strong) NSString *btTitle;
@property (nonatomic,strong) UIColor *btBgColor;//按钮背景颜色
@property (nonatomic,strong) UIColor *btTextColor;
//@property (nonatomic,strong) NSString *bt
@property (nonatomic,strong) NSMutableArray *frameArray;//存放该按钮所有的能够移动到的位置区间

@end
