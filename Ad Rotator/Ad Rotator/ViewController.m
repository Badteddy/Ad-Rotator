//
//  ViewController.m
//  Ad Rotator
//
//  Created by King on 16/6/16.
//  Copyright © 2016年 King. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic ,strong) NSTimer *time;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int count = 5;
    CGSize size = self.scrollview.frame.size;
    
    for (int i = 0; i < count; i++) {
        UIImageView *imageview = [[UIImageView alloc]init];
        [self.scrollview addSubview:imageview];
        
        NSString *imageName = [NSString stringWithFormat:@"img_%02d",i + 1 ];
        imageview.image = [UIImage imageNamed:imageName];
        
        CGFloat x = i * size.width;
        imageview.frame =CGRectMake(x, 0, size.width, size.height);
        
    }
    
    // 滚动范围
    self.scrollview.contentSize = CGSizeMake(count * size.width, 0);
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.pageControl.numberOfPages = count;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate =self;
    
    //Timer
    [self addTimer];
    
    
}

// Creat timer
- (void)addTimer{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.time = timer;
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage{
    
    NSInteger page = self.pageControl.currentPage;
    if (page == self.pageControl.numberOfPages - 1) {
        page = 0;
    }else{
        
        page++;
    }
    CGFloat x = page * self.scrollview.frame.size.width;
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollview.contentOffset = CGPointMake(x, 0);
    }];
}

#pragma mark - scrolldelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int pages = (scrollView.contentOffset.x +scrollView.frame.size.width / 2) /scrollView.frame.size.width;
    self.pageControl.currentPage = pages;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.time invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self addTimer];
}

@end
