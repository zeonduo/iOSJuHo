//
//  WEBPS004TableViewController.h
//  JuhoHomeWorkTest
//
//  Created by Juho Yoon on 2016. 12. 16..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEBPS004TableViewController : UITableViewController

@end

@interface WEBPS004TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dealIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionIdLabel;

@end
