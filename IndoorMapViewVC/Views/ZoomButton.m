//
//  ZoomButton.m
//  IndoorMapViewVC
//
//  Created by gao on 16/9/5.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "ZoomButton.h"

static CGFloat const lineHeight_static = 2.0;
@interface ZoomButton ()

@property (nonatomic ,strong) UIButton *addButton;

@property (nonatomic ,strong) UIButton *subButton;

@property (nonatomic ,strong) UIView *lineView;

@end


@implementation ZoomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addButton];
        [self addSubview:self.lineView];
        [self addSubview:self.subButton];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button{
    NSUInteger index = 0;
    if (button == self.addButton) {
        index = 0;
    }else{
        index = 1;
    }
    
    if ([self.clickDelegate respondsToSelector:@selector(zoomButtonClick:index:)]) {
        NSLog(@"ZoomButton:clickindex;%ld",index);
        [self.clickDelegate zoomButtonClick:button index:index];
    }
}


- (UIButton *)addButton{
    if (!_addButton) {
        
        CGFloat add_X = 0.0;
        CGFloat add_Y = 0.0;
        CGFloat add_W = CGRectGetWidth(self.bounds);
        CGFloat add_H = (CGRectGetHeight(self.bounds)- lineHeight_static) * 0.5;

        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(add_X, add_Y, add_W, add_H);
        [_addButton setTitle:@"加" forState:UIControlStateNormal];
         [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
         [_addButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

        [_addButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}


- (UIView *)lineView{
    if (!_lineView) {
        
        CGFloat line_X = 3.0;
        CGFloat line_Y = CGRectGetMaxY(self.addButton.frame);
        CGFloat line_W = CGRectGetWidth(self.bounds) - 2 * line_X;
        CGFloat line_H = lineHeight_static;
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(line_X, line_Y, line_W, line_H)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UIButton *)subButton{
    if (!_subButton) {
        
        CGFloat sub_X = CGRectGetMinX(self.addButton.frame);
        CGFloat sub_Y = CGRectGetMaxY(self.lineView.frame);
        CGFloat sub_W = CGRectGetWidth(self.addButton.frame);
        CGFloat sub_H = CGRectGetHeight(self.addButton.frame);;

        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _subButton.frame = CGRectMake(sub_X, sub_Y, sub_W, sub_H);
        [_subButton setTitle:@"减" forState:UIControlStateNormal];
        [_subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_subButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
          [_subButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [_subButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

@end
