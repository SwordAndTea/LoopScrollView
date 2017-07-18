//
//  XWLoopScrollView.m
//  XWLoopScrollView
//
//  Created by 向尉 on 2017/7/17.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "XWLoopScrollView.h"

NSString *const UICollectionViewCellID=@"Cell";

@interface XWLoopScrollViewCell()

@property (nonatomic, retain, readonly) UIImageView *imageView;

@end

@implementation XWLoopScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

@end






@interface XWLoopScrollView()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) NSArray *images;

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation XWLoopScrollView

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:_scrollDirection];
        [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        [flowLayout setMinimumLineSpacing:0];
        [flowLayout setMinimumInteritemSpacing:0];
        _collectionView=[[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[XWLoopScrollViewCell class] forCellWithReuseIdentifier:UICollectionViewCellID];
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.contentOffset=CGPointMake(CGRectGetWidth(self.frame), 0);
    }
    return _collectionView;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl=[[UIPageControl alloc]initWithFrame:_pageControlRect];
        [_pageControl setPageIndicatorTintColor:_pageControlDefaultColor];
        [_pageControl setCurrentPageIndicatorTintColor:_pageControlSelectedColor];
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl setNumberOfPages:self.images.count];
    }
    return _pageControl;
}

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images
{
    self=[super initWithFrame:frame];
    if (self)
    {
        _images=images;
        _pageControlDefaultColor=[UIColor whiteColor];
        _pageControlSelectedColor=[UIColor orangeColor];
        _scrollInterVal=2.f;
        _pageControlRect=CGRectMake(0, CGRectGetHeight(frame)-40.f, CGRectGetWidth(frame), 40.f);
        _canAutoScoll=YES;
        _scrollDirection=UICollectionViewScrollDirectionHorizontal;
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_canAutoScoll)
    {
        [self startAutoScolling];
    }
}

-(void)startAutoScolling
{
    [self stopAutoScolling];
    _timer=[NSTimer scheduledTimerWithTimeInterval:_scrollInterVal repeats:YES block:^(NSTimer * _Nonnull timer)
    {
        //scroll to next page
        if(_images.count==0||_images.count==1)
        {
            return;
        }
        
        CGPoint offset = self.collectionView.contentOffset;
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:offset];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
}

-(void)stopAutoScolling
{
    if (_timer)
    {
        [_timer invalidate];
    }
}

#pragma mark -ScollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollRefresh];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollRefresh];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoScolling];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoScolling];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count+2;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWLoopScrollViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
    NSInteger index=[self imageIndexFromRowIndex:indexPath.row];
    [cell setImage:_images[index]];
    return cell;
}

#pragma mark - the logic of the loopScrollView

- (void)scrollRefresh
{
    NSInteger dataIndex = floor(self.collectionView.contentOffset.x/CGRectGetWidth(self.frame));//floor 向下取整
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:self.collectionView.contentOffset];
    NSInteger currentPage = [self imageIndexFromRowIndex:indexPath.row];
    
    if(dataIndex==0)//如果左滑到最后一张图片
    {
        [self.collectionView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame)*_images.count, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) animated:NO];
        _pageControl.currentPage = _images.count-1;
    }
    else if(dataIndex==_images.count+1)//如果右滑到最后一张图片
    {
        [self.collectionView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) animated:NO];
        _pageControl.currentPage = 0;
    }
    else
    {
        _pageControl.currentPage = currentPage;
    }
    
    NSLog(@"---❤%d---",(int)dataIndex);
    
    // callback
//    if([self.delegate respondsToSelector:@selector(XWLoopScrollView:currentPageIndex:image:)])
//    {
//        [self.delegate ywLoopScrollView:self currentPageIndex:currentPage image:_imagesArr[currentPage]];
//    }
}

- (NSInteger)imageIndexFromRowIndex:(NSInteger)rowIndex
{
    if(rowIndex==0)//如果是第一个cell
    {
        return self.images.count-1;//返回最后一张图片的index
    }
    else if(rowIndex==self.images.count+1)//如果是最后一个cell
    {
        return 0;//返回第一张图片deindex
    }
    else
    {
        return rowIndex-1;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
