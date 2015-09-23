//
//  AFPickerView.m
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AFPickerView.h"

@implementation AFPickerView

#pragma mark - Synthesization

@synthesize dataSource;
@synthesize delegate;
@synthesize selectedRow = currentRow;
@synthesize rowFont = _rowFont;
@synthesize rowFontSelected = _rowFontSelected;
@synthesize rowIndent = _rowIndent;
@synthesize rowColorSelected = _rowColorSelected;
@synthesize rowColorCommon = _rowColorCommon;
@synthesize rowHeight = _rowHeight;
@synthesize halfRowNum = _halfRowNum;




#pragma mark - Custom getters/setters

- (void)setSelectedRow:(int)selectedRow
{
    if (selectedRow >= rowsCount)
        return;
    
    currentRow = selectedRow;
    [contentView setContentOffset:CGPointMake(0.0, [self rowHeight] * currentRow) animated:NO];
}




- (void)setRowFont:(UIFont *)rowFont
{
    _rowFont = rowFont;
    
    for (UILabel *aLabel in visibleViews) 
    {
        aLabel.font = _rowFont;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        aLabel.font = _rowFont;
    }
}




- (void)setRowIndent:(CGFloat)rowIndent
{
    _rowIndent = rowIndent;
    
    for (UILabel *aLabel in visibleViews) 
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndent;
        frame.size.width = self.frame.size.width - _rowIndent;
        aLabel.frame = frame;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndent;
        frame.size.width = self.frame.size.width - _rowIndent;
        aLabel.frame = frame;
    }
}




#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // setup
        [self setup];
        
        // backgound
//        UIImageView *bacground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerBackground.png"]];
//        [self addSubview:bacground];
        
        // content
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.delegate = self;
        [self addSubview:contentView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [contentView addGestureRecognizer:tapRecognizer];
        
        
        // shadows
//        UIImageView *shadows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerShadows.png"]];
//        [self addSubview:shadows];
        
        // glass
//        UIImage *glassImage = [UIImage imageNamed:@"pickerGlass.png"];
//        glassImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 76.0, glassImage.size.width, glassImage.size.height)];
//        glassImageView.image = glassImage;
//        [self addSubview:glassImageView];
    }
    return self;
}




- (void)setup
{
    _rowFont = [UIFont boldSystemFontOfSize:16.0];
    _rowFontSelected = [UIFont boldSystemFontOfSize:18.0];
    _rowIndent = 0;
    _rowHeight = 0;
    _rowColorCommon = [UIColor lightGrayColor];
    _rowColorSelected = [UIColor greenColor];
    _halfRowNum = 2;
    
    currentRow = 0;
    rowsCount = 0;
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
}




#pragma mark - Buisness

- (void)reloadData
{
    // empry views
    currentRow = 0;
    rowsCount = 0;
    
    for (UIView *aView in visibleViews) 
        [aView removeFromSuperview];
    
    for (UIView *aView in recycledViews)
        [aView removeFromSuperview];
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    rowsCount = [dataSource numberOfRowsInPickerView:self];
    [contentView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    contentView.contentSize = CGSizeMake(contentView.frame.size.width, [self rowHeight] * rowsCount + [self halfRowNum] * 2 * [self rowHeight]);
    [self tileViews];
}




- (void)determineCurrentRow
{
    CGFloat delta = contentView.contentOffset.y;
    int position = round(delta / [self rowHeight]);
    currentRow = position;
    [contentView setContentOffset:CGPointMake(0.0, [self rowHeight] * position) animated:YES];
    [self changeViewAtIndex:currentRow];
    [delegate pickerView:self didSelectRow:currentRow];
}




- (void)didTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / [self rowHeight]) - [self halfRowNum];
    [self makeSteps:steps];
}




- (void)makeSteps:(int)steps
{
    if (steps == 0 || steps > [self halfRowNum] || steps < -[self halfRowNum])
        return;
    
    [contentView setContentOffset:CGPointMake(0.0, [self rowHeight] * currentRow) animated:NO];
    
    int newRow = currentRow + steps;
    if (newRow < 0 || newRow >= rowsCount)
    {
        if (steps < -1)
            [self makeSteps:steps + 1];
        else if (steps > 1)
            [self makeSteps:steps - 1];
//        if (steps == -2)
//            [self makeSteps:-1];
//        else if (steps == 2)
//            [self makeSteps:1];
        
        return;
    }
    
    currentRow = currentRow + steps;
    [contentView setContentOffset:CGPointMake(0.0, [self rowHeight] * currentRow) animated:YES];
    [self changeViewAtIndex:currentRow];
    [delegate pickerView:self didSelectRow:currentRow];
}




#pragma mark - recycle queue

- (UIView *)dequeueRecycledView
{
	UIView *aView = [recycledViews anyObject];
	
    if (aView) 
        [recycledViews removeObject:aView];
    return aView;
}



- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL foundPage = NO;
    for (UIView *aView in visibleViews) 
	{
        int viewIndex = aView.frame.origin.y / [self rowHeight] - [self halfRowNum];
        if (viewIndex == index) 
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}




- (void)tileViews
{
    // Calculate which pages are visible
    CGRect visibleBounds = contentView.bounds;
    int firstNeededViewIndex = floorf(CGRectGetMinY(visibleBounds) / [self rowHeight]) - [self halfRowNum];
    int lastNeededViewIndex  = floorf((CGRectGetMaxY(visibleBounds) / [self rowHeight])) - [self halfRowNum];
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, rowsCount - 1);
	
    // Recycle no-longer-visible pages 
	for (UIView *aView in visibleViews) 
    {
        int viewIndex = aView.frame.origin.y / [self rowHeight] - [self halfRowNum];
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex) 
        {
            [recycledViews addObject:aView];
            [aView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // add missing pages
	for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++) 
	{
        if (![self isDisplayingViewForIndex:index])
		{
            UILabel *label = (UILabel *)[self dequeueRecycledView];
            
			if (label == nil)
            {
				label = [[UILabel alloc] initWithFrame:CGRectMake(_rowIndent, 0, self.frame.size.width - _rowIndent, [self rowHeight])];
                label.backgroundColor = [UIColor clearColor];
                label.font = self.rowFont;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [self rowColorCommon];
            }
            
            [self configureView:label atIndex:index];
            [contentView addSubview:label];
            [visibleViews addObject:label];
        }
    }
}

- (void)changeViewAtIndex:(NSUInteger)index{
    for (UIView *aView in visibleViews)
    {
        int viewIndex = aView.frame.origin.y / [self rowHeight] - [self halfRowNum];
        if([self isDisplayingViewForIndex:viewIndex]){
            if(viewIndex == self.selectedRow){
                aView.removeFromSuperview;
                UILabel * tmp = (UILabel *)aView;
                tmp.font = [self rowFontSelected];
                tmp.textColor = [self rowColorSelected];
                [contentView addSubview:tmp];
            }else{
                aView.removeFromSuperview;
                UILabel * tmp = (UILabel *)aView;
                tmp.font = [self rowFont];
                tmp.textColor = [self rowColorCommon];
                [contentView addSubview:tmp];
            }
        }
    }
}




- (void)configureView:(UIView *)view atIndex:(NSUInteger)index
{
    UILabel *label = (UILabel *)view;
    label.text = [dataSource pickerView:self titleForRow:index];
    label.backgroundColor = [UIColor clearColor];
    label.font = self.rowFont;
    label.frame = view.frame;
    CGRect frame = label.frame;
    frame.origin.y = [self rowHeight] * index + [self rowHeight] * [self halfRowNum];
    label.frame = frame;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tileViews];
}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self determineCurrentRow];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self determineCurrentRow];
}

@end
