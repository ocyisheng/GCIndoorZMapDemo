//
//  ZoomImageView.m
//  NagrandModuleTest
//
//  Created by Choi on 16/4/1.
//  Copyright © 2016年 iOSPractice.xyd. All rights reserved.
//

#import "ZoomImageView.h"
@interface ZoomImageView()
@property (strong,nonatomic)UITapGestureRecognizer *tap;
@end
@implementation ZoomImageView
-(instancetype)init{
    if (self = [super init]) {
        [self step];
    }
    return self;
}

-(void)step{
    self.userInteractionEnabled = true;
    self.tap = [[UITapGestureRecognizer alloc]init];
    self.tap.numberOfTouchesRequired = 1;
    self.tap.numberOfTapsRequired = 1;
    self.zoomtype = ZoomTypeSub;
    [self addGestureRecognizer:self.tap];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = true;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        self.layer.contents =(__bridge id) _backgroundImage.CGImage;
    }
}
-(void)addTarget:(id)target action:(SEL)selector{
    [self.tap addTarget:target action:selector];
}

-(void)drawRect:(CGRect)rect{

    CGFloat lineLength = rect.size.width/3*2;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextMoveToPoint(ctx, (rect.size.width - lineLength)/2, CGRectGetMidY(rect));
    CGContextAddLineToPoint(ctx, rect.size.width - (rect.size.width - lineLength)/2, CGRectGetMidY(rect));
    switch (self.zoomtype) {
        case ZoomTypeSub:
        {
            break;
        }
        case ZoomTypeAdd:
        {
            CGContextMoveToPoint(ctx, CGRectGetMidX(rect), (rect.size.width - lineLength)/2);
            CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), rect.size.height - (rect.size.width - lineLength)/2);
        }
            break;
            
        default:
            break;
    }
    CGContextStrokePath(ctx);
}

@end
