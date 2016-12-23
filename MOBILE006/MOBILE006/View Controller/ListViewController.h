//
//  ListViewController.h
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBMgr.h"
#import "ListTableViewCell.h"

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) CATransition *animation;
@property (weak, nonatomic) ListTableViewCell *listTableViewCell;

- (void)setPage;
@end
