//
//  CollectionViewController.m
//  SampleTest
//
//  Created by Apple3 on 13/02/16.
//  Copyright © 2016 Apple3. All rights reserved.
//

#import "CollectionViewController.h"
#import "CustomCollectionViewCell.h"
@interface CollectionViewController ()

@property (nonatomic) BOOL cellColor;

@end

NSInteger const kItemCount = 30;
NSString * const kSampleImageURLString = @"https://placeholdit.imgix.net/~text?txtsize=15&txt=image1&w=120&h=120";

@implementation CollectionViewController
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kItemCount;
}

- (CustomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"customCell";
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    [cell.activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kSampleImageURLString]];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.sampleImageView.image = image;
            [cell.activityIndicator stopAnimating];
            [cell setNeedsLayout];
        });
    });
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
