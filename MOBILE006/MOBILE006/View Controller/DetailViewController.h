//
//  DetailViewController.h
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 18..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic, nullable) NSDictionary *itemDict;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *thumbnailImageConstHeight;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *thumbnailImageConstWidth;

@property (weak, nonatomic, nullable) IBOutlet UIView *contentsView;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *contentsViewConstLeading;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *contentsViewConstTop;


@property (weak, nonatomic, nullable) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *urlLabel;

- (void)setConst;
- (void)setViewItem:(nullable NSDictionary *)itemDict;


@end
