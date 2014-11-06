//
//  JLButton.m
//  CanMoveButton
//
//  Created by love on 14-9-22.
//  Copyright (c) 2014年 JiangLong23. All rights reserved.
//

#import "JLButton.h"
#define Duration 0.2

@interface JLButton (){
    BOOL contain;//是否包含
    CGPoint startPoint;
    CGPoint movingPoint;
    CGPoint originPoint;
    CGPoint _btCenter;
}
@property (nonatomic,strong) UIButton *rightAndTopButton;

@end

@implementation JLButton

-(NSMutableArray *)frameArray{
    if (!_frameArray) {
        _frameArray = [NSMutableArray array];
    }
    return _frameArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self getUpButtonWith:frame];
        
    }
    return self;
}

-(void)awakeFromNib{
    [self getUpButtonWith:self.frame];
}


-(void)getUpButtonWith:(CGRect)frame{
    //添加手势开始
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    [self addGestureRecognizer:longGesture];
    self.frame = frame;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapPressed:)];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapPressed:)];
    oneTapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:oneTapGesture];
    //添加手势结束
    
    //添加删除按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button  setFrame:CGRectMake(self.frame.size.width-17, 0, 17, 17)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"删" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];
    button.tintColor = [UIColor blueColor];
    [button setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100;
    button.hidden = YES;
    [self addSubview:button];
    
}

-(void)setBtTitle:(NSString *)btTitle{
    self.titleLabel.text = btTitle;
}
-(void)setBtTextColor:(UIColor *)btTextColor{
    self.btTextColor = btTextColor;
}
-(void)setBtBgColor:(UIColor *)btBgColor{
    self.backgroundColor = btBgColor;
}

//按钮长按手势响应函数
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = self.center;
        _btCenter = self.center;
        [UIView animateWithDuration:Duration animations:^{
            
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.alpha = 0.7;
        }];
        UIButton *but = (UIButton *)[self viewWithTag:100];
        but.hidden = YES;
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        self.center = CGPointMake(self.center.x+deltaX,self.center.y+deltaY);
        NSLog(@"Moving Center = %@",NSStringFromCGPoint(self.center));
        originPoint = self.center;
        movingPoint = self.center;
        
        [UIView animateWithDuration:Duration animations:^{
            
            CGPoint temp = CGPointZero;
            UIButton *button = self;
            temp = button.center;
            button.center = originPoint;
            self.center = temp;
            originPoint = self.center;
            NSLog(@"移动中的点的坐标%@",NSStringFromCGPoint(originPoint));
            contain = YES;
            
        }];
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (self.frameArray.count>0) {
            if (YES==[self buttonCanDownByArray:self.frameArray]) {
                [UIView animateWithDuration:Duration animations:^{
                    self.transform = CGAffineTransformIdentity;
                    self.alpha = 1.0;
                    self.center = originPoint;
                }];
            }else {
                [UIView animateWithDuration:Duration animations:^{
                    self.transform = CGAffineTransformIdentity;
                    self.alpha = 1.0;
                    self.center = _btCenter;
                }];
            }
        }else{
            [UIView animateWithDuration:Duration animations:^{
                self.transform = CGAffineTransformIdentity;
                self.alpha = 1.0;
                self.center = originPoint;
            }];
        }
        
        
    }//else if 结束
}

//按钮点击响应函数
-(void)buttonTapPressed:(UITapGestureRecognizer *)tapGesture{
    if (tapGesture.numberOfTapsRequired==2) {
        for (UIView *view in tapGesture.view.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *bt=(UIButton *)view;
                bt.hidden = NO;
            }
        }
    }else if (tapGesture.numberOfTapsRequired==1) {
        for (UIView *view in tapGesture.view.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *bt=(UIButton *)view;
                bt.hidden = YES;
            }
        }
    }
}

//右上角的删除按钮的响应函数
-(void) deleteButton:(UIButton *)sender{
    [UIView animateWithDuration:Duration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
//根据数组里面的是否有YES
-(BOOL)buttonCanDownByArray:(NSMutableArray *)array{
    for (NSArray *arr in self.frameArray) {
        NSString *X = arr[0];
        NSString *Y = arr[1];
        NSString *W = arr[2];
        NSString *H = arr[3];
        if ([self thePoint:originPoint isInTheRange:CGRectMake(X.intValue, Y.intValue, W.intValue, H.intValue)]==YES) {
            return YES;
        }
    }//for 结束
    return NO;
}


//判断传入的CGPoint 是否在一个范围内
-(BOOL)thePoint:(CGPoint)point isInTheRange:(CGRect)frame{
    
    //得到范围的4个顶点
    CGPoint lTPoint = CGPointMake(frame.origin.x,frame.origin.y);//左上角顶点 P1
    CGPoint rTPoint= CGPointMake(frame.origin.x+frame.size.width,frame.origin.y);//右上角顶点 P2
    CGPoint lBPoint= CGPointMake(frame.origin.x,frame.origin.y+frame.size.height);//左下角顶点 P3
    CGPoint rBPoint= CGPointMake(frame.origin.x+frame.size.width,frame.origin.y+frame.size.height);//右下角顶点 P4
    NSLog(@"4个顶点是：(%@,%@,%@,%@)",NSStringFromCGPoint(lTPoint),NSStringFromCGPoint(rTPoint),NSStringFromCGPoint(lBPoint),NSStringFromCGPoint(rBPoint));
    //在范围内，return YES
    if (point.x>=lTPoint.x && point.y>=lTPoint.y && point.x<=rBPoint.x && point.y<=rBPoint.y) {
        return YES;
    }
        return NO;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
