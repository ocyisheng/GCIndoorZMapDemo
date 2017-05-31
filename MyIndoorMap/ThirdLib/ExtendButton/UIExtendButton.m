//
//  UIExtendButton.m
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/25.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "UIExtendButton.h"
#import "UIView+EasyFrameSet.h"
#import <objc/runtime.h>
#import <objc/message.h>
#define BLOCK_EXEC(block,...) if(block) {block(__VA_ARGS__);}
//#import "NagrandExtendModule.h"
@interface UIExtendButton ()

@property (assign,nonatomic)CGSize scrollviewSize;

/** 展开状态 */
@property(nonatomic,assign)BOOL isExtend;
@property (weak,nonatomic)id tempTarget;
@property (assign,nonatomic)SEL tempAction;
@property (strong,nonatomic)UIScrollView *scrollView;
@property (weak,nonatomic)Class tempClass;
@end

@implementation UIExtendButton

+(instancetype)buttonWithType:(UIButtonType)buttonType{
    UIExtendButton *btn = [super buttonWithType:buttonType];
    btn.extendStyle = ExtendTop;
    btn.defaultColor = [UIColor whiteColor];
    btn.selectedColor = [UIColor lightGrayColor];
    btn.extendDistance = 150;
    return btn;
}

#pragma mark - 懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}



#pragma mark - set方法
-(void)setSubTitleArray:(NSArray *)subTitleArray{
    _subTitleArray = subTitleArray;
    if (!subTitleArray && subTitleArray.count == 0 ) {
        return;
    }
    if (subTitleArray.count == 2) {
        NSLog(@"aaaa");
    }
    [self removeAllItemView];
    self.currentIndex = 0;
}

-(void)setIsExtend:(BOOL)isExtend{
    _isExtend = isExtend;
    if (isExtend) {
        [self animationOpen];
    }else{
        [self animationClose];
    }
    
}

-(void)setCurrentIndex:(int)currentIndex{
    _currentIndex = currentIndex;
    [self setTitle:self.subTitleArray[currentIndex] forState:UIControlStateNormal];
    for (UIView * tempView in self.scrollView.subviews) {
        NSLog(@"tempview.tag = %ld",tempView.tag);
        if (tempView.tag == currentIndex + 100) {
            tempView.backgroundColor = self.selectedColor;
                    continue;
        };

        tempView.backgroundColor = [UIColor clearColor];
    }

}



#pragma mark - runtime
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [super addTarget:target action:action forControlEvents:controlEvents];
    if (![target isKindOfClass:[self class]]) {
        self.tempTarget = target;
        self.tempAction = action;
        self.tempClass = [self.tempTarget class];
        [self changeMethod];
    }
}

-(void)changeMethod{
    Method method1 = class_getInstanceMethod(self.tempClass, self.tempAction);
    Method method2 = class_getInstanceMethod([self class], @selector(btnAction:));
    method_exchangeImplementations(method1, method2);
}

- (void)btnAction:(UIExtendButton *)sender {
    sender.isExtend = !sender.isExtend;
    if (sender.tempTarget) {
        [sender changeMethod];
        [self performSelector:sender.tempAction withObject:sender];
        [sender changeMethod];
 
            }
}

#pragma mark - itembuttonClick
-(void)subBtnAction:(UIButton *)btn{
    self.currentIndex = (int)btn.tag - 100;
    self.isExtend = false;
    BLOCK_EXEC(self.clickBlock,(int)btn.tag - 100);
}

#pragma mark - animation
-(void)animationOpen{
    if (self.subTitleArray && self.subTitleArray.count > 0) {
        CGPoint origin = CGPointMake(self.width, self.height);
        CGSize itemSize = CGSizeMake(self.width - 5, self.height - 5);
        if (itemSize.height * self.subTitleArray.count < self.extendDistance) {
            self.extendDistance = origin.y * self.subTitleArray.count;
        }
        CGSize gapSize = CGSizeMake(origin.x - itemSize.width, origin.y - itemSize.height);
        CGRect scrollviewRect;
        switch (self.extendStyle) {
            case ExtendTop:
            {
                origin = CGPointMake(0, origin.y);
//                self.scrollView.frame = CGRectMake(self.x, self.y - extendDistance, self.width, extendDistance);
                scrollviewRect = CGRectMake(self.x, self.y - self.extendDistance, self.width, self.extendDistance);
            }
                break;
            case ExtendBottom:
            {
                origin = CGPointMake(0, origin.y);
//                self.scrollView.frame = CGRectMake(self.x, self.y + self.height , self.width, extendDistance);
                scrollviewRect = CGRectMake(self.x, self.y + self.height , self.width, self.extendDistance);
            }
                break;
            case ExtendLeft:
            {
                origin = CGPointMake(origin.x, 0);
//                self.scrollView.frame = CGRectMake(self.x - extendDistance, self.y, extendDistance, self.height);
                scrollviewRect = CGRectMake(self.x - self.extendDistance, self.y, self.extendDistance, self.height);
            }
                break;
            case ExtendRight:
            {
                origin = CGPointMake(origin.x, 0);
//                self.scrollView.frame = CGRectMake(self.x + self.width, self.y, extendDistance, self.height);
                scrollviewRect =CGRectMake(self.x + self.width, self.y, self.extendDistance, self.height);
            }
                break;
                
            default:
                break;
        }

        self.scrollView.contentSize = CGSizeMake(self.width + fabs(origin.x) * (self.subTitleArray.count - 1), self.height + fabs(origin.y) * (self.subTitleArray.count - 1));
        self.scrollView.frame = CGRectMake(self.x, self.y, self.width ,self.height);
        self.scrollView.alpha = 0;
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.scrollView.frame = scrollviewRect;
                    self.scrollView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
//            self.scrollView.frame = scrollviewRect;
            for (int i =0; i <self.subTitleArray.count; i ++) {
                UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                itemBtn.frame = CGRectMake(origin.x * i + gapSize.width/2,origin.y * i + gapSize.height/2, itemSize.width , itemSize.height );
                [itemBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [itemBtn setTitle:self.subTitleArray[i] forState:UIControlStateNormal];
                itemBtn.backgroundColor = self.defaultColor;
                [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                itemBtn.layer.cornerRadius = self.layer.cornerRadius;
                itemBtn.layer.borderWidth = self.layer.borderWidth;
                itemBtn.layer.borderColor = self.layer.borderColor;
                itemBtn.tag = 100 + i;
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [self.scrollView addSubview:itemBtn];
                if (self.currentIndex == i) {
                    itemBtn.backgroundColor = self.selectedColor;
                }

            }

        NSLog(@"scrollview.count = %ld",self.scrollView.subviews.count);
    }else{
        return;
    }
}
-(void)animationClose{
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
             self.scrollView.frame = CGRectMake(self.x,self.y,self.width, self.height);
        
    } completion:^(BOOL finished) {

            [self removeAllItemView];
    }];

//    self.extendStyle = (self.extendStyle + 1) %4;
}

-(void)removeAllItemView{
    for (int i =0; i < self.subTitleArray.count; i ++ ) {
        UIView *tempView = [self.scrollView viewWithTag:100 + i];
        [tempView removeFromSuperview];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [newSuperview addSubview:self.scrollView];
    if (!self.tempTarget) {
        [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
}

-(void)dealloc{
    [self changeMethod];
}



@end
