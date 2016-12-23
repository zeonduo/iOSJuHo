//
//  DetailViewController.m
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 18..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "DetailViewController.h"
#import "DBMgr.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewItem:self.itemDict];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [self setConst];
}

// Landscape / Portrait Screen Mode에 따른 Auto Layout 변경.
- (void)setConst {
    NSString *widthStr = [self.itemDict valueForKey:@"width"];
    NSString *heightStr = [self.itemDict valueForKey:@"height"];
    NSInteger orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        // Portrait Mode
        self.thumbnailImageConstWidth.constant = self.view.frame.size.width - 32 ;
        if (widthStr && heightStr) {
            self.thumbnailImageConstHeight.constant = (self.thumbnailImageConstWidth.constant * [heightStr integerValue])/[widthStr integerValue];
        } else {
            self.thumbnailImageConstHeight.constant  = (self.thumbnailImageConstWidth.constant * 761) / 1024;
            
        }
        self.contentsViewConstTop.constant = self.thumbnailImageConstHeight.constant + 40;
        self.contentsViewConstLeading.constant = 16; //Margin
        
    } else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        // Landscape Mode
        self.thumbnailImageConstHeight.constant = self.view.frame.size.height - 40 - self.navigationController.navigationBar.frame.size.height;
        if (widthStr && heightStr) {
            self.thumbnailImageConstWidth.constant = (self.thumbnailImageConstHeight.constant * [widthStr integerValue]) / [heightStr integerValue];
        } else {
            self.thumbnailImageConstWidth.constant  = (self.thumbnailImageConstHeight.constant * 1024) / 761;
        }
        
        self.contentsViewConstLeading.constant = self.thumbnailImageConstWidth.constant + 32;
        self.contentsViewConstTop.constant = 20; //Margin
    }
}
/* Set Data */
- (void)setViewItem:(NSDictionary *)itemDict{
    NSString *dateTakenStr = [itemDict valueForKey:@"date_taken"];
    NSString *urlrlStr = [itemDict valueForKey:@"url"];
    NSString *widthStr = [itemDict valueForKey:@"width"];
    NSString *heightStr = [itemDict valueForKey:@"height"];
    NSString *titleStr = [itemDict valueForKey:@"title"];
    
    NSString *sizeStr = nil;
    //widthStr와 heightStr의 값이 있을때 동작.
    if (widthStr && heightStr) {
        sizeStr = [NSString stringWithFormat:@"%@x%@",widthStr,heightStr];
    }

    //url 값이 있을때 동작. 없으면 Default Background 가 표시됨.
    if (urlrlStr) {
        [[DBMgr sharedInstance] loadImage:urlrlStr callback:^(UIImage* imaage){
            self.thumbnailImageView.image = imaage;
        }];
    }
    self.titleLabel.text = titleStr;
    self.urlLabel.text = urlrlStr;
    self.sizeLabel.text = sizeStr;
    self.dateLabel.text = dateTakenStr;
}

@end
