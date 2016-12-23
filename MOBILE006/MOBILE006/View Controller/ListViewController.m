//
//  ListViewController.m
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[[DBMgr sharedInstance] getStateStr] isEqualToString:@"ok"]) {
        [self setPage];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidAppear:)
                                                 name:@"API_Response"
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"API_Response" object:nil];
}

#pragma mark Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //fix 10 cell
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Cell Height는 고정.
    return 84;
}
/* Cell에 data 넣기 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemRow = indexPath.row + (self.pageControl.currentPage * 10);
    NSDictionary *photosItemDict = [[DBMgr sharedInstance] getPhotosArr][itemRow];
    
    NSString *dateTakenStr = [photosItemDict valueForKey:@"date_taken"];
    NSString *urlrlStr = [photosItemDict valueForKey:@"url"];
    NSString *widthStr = [photosItemDict valueForKey:@"width"];
    NSString *heightStr = [photosItemDict valueForKey:@"height"];
    NSString *titleStr = [photosItemDict valueForKey:@"title"];
    
    NSString *sizeStr = nil;
    //widthStr와 heightStr의 값이 있을때 동작.
    if (widthStr && heightStr) {
        sizeStr = [NSString stringWithFormat:@"%@x%@",widthStr,heightStr];
    }
    //Identifier를 사용하여 Cell 구현.
    NSString *listTableViewCellId = @"ListTableViewCell";
    ListTableViewCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:listTableViewCellId forIndexPath:indexPath];
    
    // Label 값 넣기
    cell.titleLabel.text = titleStr;
    cell.sizeLabel.text = sizeStr;
    cell.urlLabel.text = urlrlStr;
    cell.dateLabel.text = dateTakenStr;
    
    //비동기로 이미지 처리.
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.image.image = nil;
        cell.image.backgroundColor = [UIColor grayColor];
        
        //url 값이 있을때 동작.(Image)
        if (urlrlStr) {
            [[DBMgr sharedInstance] loadImage:urlrlStr callback:^(UIImage* imaage){
                cell.image.image = imaage;
                cell.imageWidthConst.constant = 64;
            }];
        } else {
            cell.image.backgroundColor = [UIColor clearColor];
            cell.image.image = nil;
            cell.imageWidthConst.constant = 0;
        }
    });
    return cell;
}
/* Table Item Select */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemRow = indexPath.row + (self.pageControl.currentPage * 10);
    NSDictionary *photosItemDict = [[DBMgr sharedInstance] getPhotosArr][itemRow];
    [self performSegueWithIdentifier:@"Move To Detail View" sender:photosItemDict];
}

#pragma mark Page Control
- (void)setPage {
    //Page Count Setting
    self.pageControl.numberOfPages = [[DBMgr sharedInstance] getPhotosArr].count / 10;
    if ([[DBMgr sharedInstance] getPhotosArr].count % 10 != 0) {
        self.pageControl.numberOfPages += 1;
    }
    
    //Swipe gesture 추가.
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    self.animation  = [CATransition animation];
    self.animation.duration       = 0.15f;
    self.animation.timingFunction = UIViewAnimationCurveEaseInOut;
    self.animation.type           = kCATransitionPush;
    
    //View Reload
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableView reloadData];
        [self.pageControl updateCurrentPageDisplay];
    });
}
/* Swipe Gesture 구현 */
- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser {
    self.animation.subtype = swipeRecogniser.direction == UISwipeGestureRecognizerDirectionLeft ? kCATransitionFromRight : kCATransitionFromLeft;
    
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft && self.pageControl.currentPage < self.pageControl.numberOfPages - 1 ) {
        
        [self.view.layer addAnimation:self.animation forKey:@"animation"];
        self.pageControl.currentPage +=1;
    } else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight && self.pageControl.currentPage > 0) {
        
        [self.view.layer addAnimation:self.animation forKey:@"animation"];
        self.pageControl.currentPage -=1;
    }
    //View Reload
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableView reloadData];
        [self.pageControl updateCurrentPageDisplay];
    });
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Move To Detail View"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.itemDict = sender;
    }
}

@end
