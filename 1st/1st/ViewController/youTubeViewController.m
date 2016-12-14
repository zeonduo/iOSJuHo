//
//  youTubeViewController.m
//  1st
//
//  Created by Juho Yoon on 2016. 12. 14..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "youTubeViewController.h"

@interface youTubeViewController ()

@end

@implementation youTubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [self.youtubeView loadWithVideoId:@"M7lc1UVf-VE"];
    NSLog(@"여기탐 : %@",[self.youtubeView playlist]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
