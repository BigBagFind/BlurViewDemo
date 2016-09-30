//
//  TggBlurredView.m
//  BlurViewDemo
//
//  Created by 铁拳科技 on 16/9/29.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "TggBlurredView.h"



@interface TggBlurredView ()


@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;



@end



@implementation TggBlurredView


+ (instancetype)viewFromNib {
    TggBlurredView *bluerredView = [[[NSBundle mainBundle] loadNibNamed:@"TggBlurredView" owner:self options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:bluerredView];
    bluerredView.frame = [UIScreen mainScreen].bounds;
    return bluerredView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleTapAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.closeIcon.transform = CGAffineTransformRotate(self.closeIcon.transform, M_PI_4);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}






@end
