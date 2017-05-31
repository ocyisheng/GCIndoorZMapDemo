//
//  DetaiLableView.m
//  IndoorMapViewVC
//
//  Created by gao on 16/9/5.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "DetaiLableView.h"

@implementation DetaiLableView

- (void)awakeFromNib{
      [self.button addSubview:self.rightButton];
}
- (void)clickRightButton:(UIButton *)button{
    if ([self.clickDelegate respondsToSelector:@selector(clickDetailViewButton:)]) {
        [self.clickDelegate clickDetailViewButton:button];
    }
}


- (GCButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [GCButton buttonWithType:GCButtonTypeLeft frame:self.button.bounds];
        [_rightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [_rightButton setTitle:@"详情" forState:UIControlStateNormal];
        _rightButton.imageSize = CGSizeMake(24, 24);
        _rightButton.titleSize = CGSizeMake(36, 30);
        _rightButton.betweenSpace = 0.0;
//        _rightButton.titleLabel.backgroundColor = [UIColor redColor];
//        _rightButton.imageView.backgroundColor = [UIColor blueColor];
     //   _rightButton.imageView.contentMode = UIViewContentModeRight;
        [_rightButton setTitleColor:[UIColor greenColor]forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
