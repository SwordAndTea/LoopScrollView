//
//  XWLoopScrollView.h
//  XWLoopScrollView
//
//  Created by 向尉 on 2017/7/17.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWLoopScrollView;

@protocol XWLoopScrollViewDelegate<NSObject>

@optional
-(void)XWLoopScrollView:(XWLoopScrollView *)XWLoopScrollView currentPageAtIndex:(NSInteger)index imgae:(id)image;

-(void)XWLoopScrollView:(XWLoopScrollView *)XWLoopScrollView didSelectedPageAtIndex:(NSInteger)index image:(id)image;

@end

@interface XWLoopScrollView : UIView

@property (nonatomic, retain) UIColor *pageControlDefaultColor;                 //default is white color.

@property (nonatomic, retain) UIColor *pageControlSelectedColor;                //default is orange color.

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;  //default is horizontal

@property (nonatomic, assign) NSTimeInterval scrollInterVal;                    //defaults is 2 seconds.

@property (nonatomic, assign) CGRect pageControlRect;

@property (nonatomic, assign) BOOL canAutoScoll;                                //default is YES.

@property (nonatomic, weak) id<XWLoopScrollViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *> *)images;

@end


/*XWLoopScrollViewCell */
@interface XWLoopScrollViewCell:UICollectionViewCell


@end
