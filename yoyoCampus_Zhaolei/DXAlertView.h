//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXAlertView : UIView

- (id)initWithTitle:(NSString *)title
      leftButtonImage:(UIImage *)leftImage
      leftButtonTitle:(NSString *)leftTitle
       midButtonImage:(UIImage *)midImage
       midButtonTitle:(NSString *)midTitle
     rightButtonImage:(UIImage *)rightImage
     rightButtonTitle:(NSString *)rightTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t midBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end