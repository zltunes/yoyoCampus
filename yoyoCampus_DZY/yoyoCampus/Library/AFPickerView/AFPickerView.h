//
//  AFPickerView.h
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol AFPickerViewDataSource;
@protocol AFPickerViewDelegate;

@interface AFPickerView : UIView <UIScrollViewDelegate>
{
    __unsafe_unretained id <AFPickerViewDataSource> dataSource;
    __unsafe_unretained id <AFPickerViewDelegate> delegate;
    UIScrollView *contentView;
    UIImageView *glassImageView;
    
    int currentRow;
    int rowsCount; 
    
    CGPoint previousOffset;
    BOOL isScrollingUp;
    
    // recycling
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
    
    UIFont *_rowFont;
    CGFloat _rowIndent;
}

@property (nonatomic, unsafe_unretained) id <AFPickerViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id <AFPickerViewDelegate> delegate;
///作者自带,当前所选择的行
@property (nonatomic, unsafe_unretained) int selectedRow;
///作者自带,未被选择行的字体
@property (nonatomic, strong) UIFont *rowFont;
///我添加的,被选择的行的字体
@property (nonatomic, strong) UIFont *rowFontSelected;
///作者自带,行缩进大小
@property (nonatomic, unsafe_unretained) CGFloat rowIndent;
///我添加的,被选择的行的字体颜色
@property (nonatomic, strong) UIColor *rowColorSelected;
///我添加的,未被选择行的字体颜色
@property (nonatomic, strong) UIColor *rowColorCommon;
///我添加的,行高
@property (nonatomic, unsafe_unretained) CGFloat rowHeight;
///我添加的,被选择行居中时,上下方各有多少行可见
@property (nonatomic, unsafe_unretained) int halfRowNum;


- (void)setup;
- (void)reloadData;
- (void)determineCurrentRow;
- (void)didTap:(id)sender;
- (void)makeSteps:(int)steps;

// recycle queue
- (UIView *)dequeueRecycledView;
- (BOOL)isDisplayingViewForIndex:(NSUInteger)index;
- (void)tileViews;
- (void)configureView:(UIView *)view atIndex:(NSUInteger)index;

@end



@protocol AFPickerViewDataSource <NSObject>

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView;
- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row;
//- (UILabel *)pickerView: (AFPickerView *)pickerView titleLabelForRow:(NSInteger)row;

@end



@protocol AFPickerViewDelegate <NSObject>

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row;

@end