//
//  ThirdViewController.m
//  SampleTest
//
//  Created by Apple3 on 13/02/16.
//  Copyright © 2016 Apple3. All rights reserved.
//

#import "ThirdViewController.h"
@interface ThirdViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, readwrite) BOOL pageControlUsed;
@end

NSString * const kSampleTextViewString = @"Inteliment Technologies India Pvt.\nWe are extremely active and very well known within our ecosystem. We are invited in a lot of events as speakers, we are the recipients of a lot of prestigious awards and we are featured regularly on different news and media platforms for our innovation and contributing back to the society.\nAt Inteliment, we offer positions that allow you to explore new challenges every day, across technologies and continents.\nLtd.\n Level 3, Meenasai, 4 Pushpak Park, Aundh-ITI Road, Aundh, Pune, Maharashtra 411007\nPhone: 020 6728 7200\nSite: www.inteliment.com";
@implementation ThirdViewController
@synthesize scrollView,pageControl,pageControlUsed,textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewForDisplay];
}

-(void)prepareViewForDisplay {
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont boldSystemFontOfSize:14];
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.text = kSampleTextViewString;
    NSArray *imageArray = [NSArray arrayWithObjects:@"image1.png",@"image2.png",@"image1.png", nil];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [imageArray count], self.scrollView.frame.size.height);
    float xOffset = 0;
    for (NSString *imageString in imageArray) {
    
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:imageString];
        [scrollView addSubview:imageView];
        xOffset = xOffset + imageView.frame.size.width;
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = imageArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    self.scrollView.delegate = self;
}

#pragma mark - Scroll view Delegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!pageControlUsed) {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
    
}

@end
