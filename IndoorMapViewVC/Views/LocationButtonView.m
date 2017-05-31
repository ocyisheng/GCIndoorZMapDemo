//
//  LocationButtonView.m
//  IndoorMapViewVC
//
//  Created by gao on 16/9/2.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "LocationButtonView.h"

@interface LocationButtonView()
{
    NSUInteger count;
}
@property (nonatomic ,strong) UIActivityIndicatorView * actIndicator;

@property (nonatomic ,strong) UIButton *locationButton;

@property (nonatomic ,strong) NSArray *images;


@end

@implementation LocationButtonView
-(instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames{
    if (self = [super initWithFrame:frame]) {
        _images = imageNames;
        [self addSubview:self.locationButton];
        [self.locationButton addSubview:self.actIndicator];
        
    }
    return self;
}

- (void)startActivityAnimation{
    self.actIndicator.hidden = NO;
    [self.actIndicator startAnimating];
}
- (void)stopActivityAnimation{
    [self.actIndicator stopAnimating];
    self.actIndicator.hidden = YES;
}
- (void)backFirstImageView{
    count = 0;
    [self.locationButton setBackgroundImage:[UIImage imageNamed:self.images[0]] forState:UIControlStateNormal];
}
- (void)clickButton:(UIButton *)button{
    NSUInteger totleCount = self.images.count;
    NSUInteger index = count % (totleCount-1);
    NSUInteger imageIndex = (index+1) % totleCount;
    NSString *imageName = self.images[imageIndex];
    
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    NSUInteger currentIndex = count > 0 ? imageIndex : index;
    
    if (count > 0) {
        if (currentIndex == 1) {
            currentIndex ++;
            
        }else{
            if (currentIndex == 2) {
                currentIndex --;
            }
        }
    }

    
    NSLog(@"LocationButton:clickIndex:%ld imageIndex:%ld index:%ld",currentIndex,imageIndex,index);
    if ([self.clickDelegate respondsToSelector:@selector(clickLocationButton:index:)]) {
        [self.clickDelegate clickLocationButton:button index:currentIndex];
    }
    count ++;
    
}

#pragma mark - setter getter func -

- (UIButton *)locationButton{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.frame = self.bounds;
        [_locationButton setBackgroundImage:[UIImage imageNamed:self.images[0]] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}

- (UIActivityIndicatorView *)actIndicator{
    if (!_actIndicator) {
        _actIndicator =[[UIActivityIndicatorView alloc]initWithFrame:self.locationButton.bounds];
       _actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
       _actIndicator.backgroundColor = [UIColor grayColor];

      _actIndicator.hidden = YES;

    }
    return _actIndicator;
}
@end
