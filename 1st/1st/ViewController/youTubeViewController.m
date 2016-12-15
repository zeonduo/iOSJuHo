//
//  youTubeViewController.m
//  1st
//
//  Created by Juho Yoon on 2016. 12. 14..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "youTubeViewController.h"
#import "NetProtocolDelegate.h"

@interface youTubeViewController ()

@end

@implementation youTubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
//    [self.youtubeView loadWithVideoId:@"M7lc1UVf-VE"];
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    [self.youtubeView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
    
//    NSLog(@"여기탐 : %@",[self.youtubeView loadWithPlaylistId:@"건담"]);
    NSLog(@"여기탐 : %@",self.youtubeView.playlist);
//    [self playVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)playVideo {
    [self.youtubeView playVideo];
}

- (void)pauseVideo {
    
    [self.youtubeView pauseVideo];
}


- (void)vingleTest {
    NSArray *testArr = @[@1,@6,@3];
    
    NSMutableArray *testMuArr = [[NSMutableArray alloc] init];
    for (NSNumber *test in testArr) {
        [testMuArr addObject:@([test intValue] * 2)];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    if (self.youtubeView.playerState == kYTPlayerStatePlaying) {
//        [self pauseVideo];
//    } else {
//        [self playVideo];
//    }
//    [self test];
    [self sortDealAndOptionId];
}

- (void)test {
    // Set up your URL
//    NSString *youtubeApi = @"https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+statistics&id=AKiiekaEHhI&key={AIzaSyDNnduc7310cOa7wXjsNHpPy6qUM5lPd68}";
//    NSString *youtubeApi = @"https://www.googleapis.com/youtube/v3/channels?key={AIzaSyDNnduc7310cOa7wXjsNHpPy6qUM5lPd68}";
    
//    NSString *youtubeApi = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/channels?part=contentDetails&key="];
    NSString *youtubeApi = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+statistics&id=AKiiekaEHhI&key="];
    NSString *key = @"AIzaSyBiq21RglcPBDsnfQTbK-pBf1yGv9kwsp8";
    key = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//    NSURL *url = [[NSURL alloc] initWithString:youtubeApi];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",youtubeApi,key]];
    NSLog(@"여기탐1 : %@",url);
    NSLog(@"여기탐2 : %@",key);
    
    // Create your request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Send the request asynchronously
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        NSLog(@"\ndata : %@ \nresponse : %@ \nconnectionError : %@",data,response,connectionError);
        
        // Callback, parse the data and check for errors
        if (data && !connectionError) {
            NSError *jsonError;
            NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"Response from YouTube: %@", jsonResult);
            }
        }
    }] resume];
    
}
/*
110,10 101,9 101,8 103,7 105,6 105,5 101,4 103,3 103,2
*/
//딜옵션별로 정렬하기

- (void)sortDealAndOptionId {
    
    NSArray *inputData1 = @[@[@110,@10],@[@101,@9],@[@101,@8],@[@103,@7],@[@105,@6],@[@105,@5],@[@101,@4],@[@103,@3],@[@103,@2],@[@110,@1]];
    
    NSMutableDictionary *sortDataDic = [[NSMutableDictionary alloc] init];
    
    for (NSArray *arrItem in inputData1) {
        BOOL checkingKey = NO;
        for (NSUInteger i = 0; i < [sortDataDic allKeys].count; i++) {
            if ([[NSString stringWithFormat:@"%@",arrItem[0]] isEqualToString:[sortDataDic allKeys][i]]) {
                
                NSString *keyString = [NSString stringWithFormat:@"%@",arrItem[0]];
                NSArray *itemValueArr = [[sortDataDic copy] valueForKey:keyString];
                NSMutableArray *valueMuArr = [[NSMutableArray alloc] init];

                if ([itemValueArr isKindOfClass:[NSNumber class]]) {
                    valueMuArr = [NSMutableArray arrayWithObjects:itemValueArr, nil];
                } else {
                    valueMuArr = [itemValueArr mutableCopy];
                }
                
                NSNumber *itemNum = arrItem[1];
                [valueMuArr addObject:itemNum];
                NSArray *sortedArray = [[valueMuArr copy] sortedArrayUsingComparator:^(id a, id b){
                    return [a compare:b];
                }];
                
                sortDataDic[[NSString stringWithFormat:@"%@",arrItem[0]]] = sortedArray;
                
                checkingKey = YES;
            }
        }
        
        if (checkingKey == NO) {
            [sortDataDic setObject:arrItem[1] forKey:[NSString stringWithFormat:@"%@",arrItem[0]]];
        }
        NSLog(@"sortDataDic :%@",sortDataDic);
    }
    
    NSLog(@"sortDataDic :%@",sortDataDic);
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
