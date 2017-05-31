//
//  FeatureView.m
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FeatureView.h"
#import "DefinitionHeader.h"
@interface FeatureView()
{
    BOOL _fistTap;//调用次数限制
}

@end
@implementation FeatureView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:H_ZoomScaleChangedNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePriority:) name:H_ZoomScaleChangedNotification object:nil];
    }
    return self;
}

- (void)updateSubViews{
#warning 这里依旧有问题，需要改善。。。
#warning 这里要看当前放大倍数
    if (self.priority >= 2) {
        self.showView.hidden = NO;
    }else{
        self.showView.hidden = YES;
    }
}
- (void)changePriority:(NSNotification *)notify{
    NSDictionary *useinfo = notify.userInfo;
    
    if (self.priority < [useinfo[H_ZoomScale]integerValue]) {
        self.showView.hidden = YES;
    }else{
        self.showView.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // [self.nextResponder touchesBegan:touches withEvent:event];
    //只有当是在FeatureView 的范围内是才传递参数
    NSLog(@"点击了FeatureView id：%ld",self.ID);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    if ([self.hitDelegate respondsToSelector:@selector(hitTestFeatureView:)] && [self.featurelayer isAreaSelected:point] && _canBeTouched) {
        [self.hitDelegate hitTestFeatureView:self];
    }
}

#pragma mark - getter func -

- (FeatureFlagView *)showView{
    if (!_showView) {
        _showView = [[FeatureFlagView alloc]init];
        _showView.center = self.center;
    }
    return _showView;
}


#pragma mark - setter func -

- (void)setShowName:(NSString *)showName{
    _showName = showName;
    
    self.showView.name = showName;
}

- (void)setShowImageName:(NSString *)showImageName{
    _showImageName = showImageName;
    
    self.showView.imageName = showImageName;
}
- (void)setFeaturelayer:(FeatureLayer *)featurelayer{
    _featurelayer = featurelayer;
    _featurelayer.frame = self.bounds;
    [self.layer addSublayer:_featurelayer];
#warning 这个标记是为。。。。。。。。。。。。。。。。！！！！！！！！！有用！！！！！！！！！！！！！
    _canBeTouched = YES;
}



@end
