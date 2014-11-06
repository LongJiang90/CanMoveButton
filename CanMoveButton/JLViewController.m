//
//  JLViewController.m
//  CanMoveButton
//
//  Created by love on 14-9-22.
//  Copyright (c) 2014年 JiangLong23. All rights reserved.
//

#import "JLViewController.h"
#import "JLButton.h"

@interface JLViewController ()
{
    int _buttonIndex;
}

@end

@implementation JLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _buttonIndex = 0;
    
    NSArray *array = @[@[@"20",@"20",@"60",@"60"],@[@"90",@"100",@"90",@"90"],@[@"200",@"100",@"60",@"60"]];
    //加载按钮可以放下来的范围视图
    for (NSArray *arr in array) {
        NSString *X = arr[0];
        NSString *Y = arr[1];
        NSString *W = arr[2];
        NSString *H = arr[3];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(X.intValue, Y.intValue, W.intValue, H.intValue)];
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self.view addSubview:view];
        
    }
    
    JLButton *bt = [[JLButton alloc] initWithFrame:CGRectMake(40, 40, 70, 90)];
    [bt setTitle:@"按钮" forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor redColor]];
    bt.tag = 10;
    
    
    bt.frameArray = [array mutableCopy];
    
    [self.view addSubview:bt];
    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)addButto:(id)sender {
    _buttonIndex +=1;
    JLButton *bt = [[JLButton alloc] initWithFrame:[self randomFrame]];
    [bt setTitle:[NSString stringWithFormat:@"按钮%d",_buttonIndex] forState:UIControlStateNormal];
    [bt setBackgroundColor:[self randomColor]];
    bt.tag = _buttonIndex;
    
    [self.view addSubview:bt];
    
}
//@TODO:随机变化颜色
- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
//@TODO:随机变化位置
-(CGRect) randomFrame{
    CGFloat x = arc4random() % 320;
    CGFloat y = arc4random() % 480;
    CGFloat w = 30+arc4random() % 80;
    CGFloat h = 30+arc4random() % 80;
    return CGRectMake(x, y, w, h);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
