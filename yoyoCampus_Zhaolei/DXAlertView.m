//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>


#define kAlertWidth 245.0f
#define kAlertHeight 145.0f

@interface DXAlertView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *midBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation DXAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
    leftButtonImage:(UIImage *)leftImage
    leftButtonTitle:(NSString *)leftTitle
    midButtonImage:(UIImage *)midImage
    midButtonTitle:(NSString *)midTitle
    rightButtonImage:(UIImage *)rightImage
    rightButtonTitle:(NSString *)rightTitle
{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, 60)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
        self.alertContentLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame;
        CGRect midBtnFrame;
        CGRect rightBtnFrame;
#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kTrippleButtonWidth 40.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 53.0f
#define kLabelHeight 10.0f

        
            leftBtnFrame = CGRectMake((kAlertWidth/2 - kTrippleButtonWidth * 1.5)/2, kAlertHeight/3, kTrippleButtonWidth, kButtonHeight);
            midBtnFrame = CGRectMake(kAlertWidth/2-kTrippleButtonWidth/2, kAlertHeight/3, kTrippleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake((kAlertWidth+kTrippleButtonWidth)/2+(kAlertWidth/2 - kTrippleButtonWidth * 1.5)/2, kAlertHeight/3, kTrippleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            self.midBtn.frame = midBtnFrame;
        
        self.leftLabel = [[UILabel alloc]init];
        self.midLabel = [[UILabel alloc]init];
        self.rightLabel = [[UILabel alloc]init];
        
        self.leftLabel.frame = CGRectMake((kAlertWidth/2 - kTrippleButtonWidth * 1.5)/2, kAlertHeight*0.75, kTrippleButtonWidth*2, kLabelHeight);
        self.midLabel.frame = CGRectMake(kAlertWidth/2-kTrippleButtonWidth/2 - 3,kAlertHeight*0.75, kTrippleButtonWidth*2, kLabelHeight);
        self.rightLabel.frame = CGRectMake((kAlertWidth+kTrippleButtonWidth)/2+(kAlertWidth/2 - kTrippleButtonWidth * 1.5)/2 - 3,kAlertHeight*0.75, kTrippleButtonWidth*2, kLabelHeight);

        
        
        
        self.leftLabel.font = [UIFont boldSystemFontOfSize:13.0];
        self.midLabel.font = [UIFont boldSystemFontOfSize:13.0];
        self.rightLabel.font = [UIFont boldSystemFontOfSize:13.0];
        self.leftLabel.textColor = [UIColor grayColor];
        self.midLabel.textColor = [UIColor grayColor];
        self.rightLabel.textColor = [UIColor grayColor];
        
        self.leftLabel.text = leftTitle;
        self.midLabel.text = midTitle;
        self.rightLabel.text = rightTitle;
        
        [self.rightBtn setBackgroundImage:rightImage forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:leftImage forState:UIControlStateNormal];
        [self.midBtn setBackgroundImage:midImage forState:UIControlStateNormal];
        [self.rightBtn setTitle:nil forState:UIControlStateNormal];
        [self.leftBtn setTitle:nil forState:UIControlStateNormal];
        [self.midBtn setTitle:nil forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.midBtn addTarget:self action:@selector(midBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = self.midBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = self.midBtn.layer.cornerRadius = 3.0;

        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.midBtn];
        [self addSubview:self.leftLabel];
        [self addSubview:self.midLabel];
        [self addSubview:self.rightLabel];
        
        self.alertTitleLabel.text = title;
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
//    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)midBtnClicked:(id)sender
{
//    _leftLeave = NO;
    [self dismissAlert];
    if (self.midBlock) {
        self.midBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
//    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

@end


