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
//    NSDictionary *playerVars = @{
//                                 @"playsinline" : @1,
//                                 };
//    [self.youtubeView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
//    
////    NSLog(@"여기탐 : %@",[self.youtubeView loadWithPlaylistId:@"건담"]);
//    NSLog(@"여기탐 : %@",self.youtubeView.playlist);
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
    [self test];
//    [self sortDealAndOptionId];
//    [self exam2];
//    [self exam2];
}

- (void)test {
    // Set up your URL
    NSString *givenAPIStr = [NSString stringWithFormat:@"https://demo2587971.mockable.io/images"];
    NSURL *givenAPIUrl = [NSURL URLWithString:givenAPIStr];
    
    // Create your request
    NSURLRequest *request = [NSURLRequest requestWithURL:givenAPIUrl];
    
    // Send the request asynchronously
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        // Callback, parse the data and check for errors
        if (data && !connectionError) {
            NSError *jsonError;
            NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"Response from API: %@", jsonResult);
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
    }
    
    NSLog(@"sortDataDic :%@",sortDataDic);
}

- (void)exam2 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cate_product" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *prdArr = [dict valueForKey:@"products"];
    NSArray *smallCategorysArr = [dict valueForKey:@"smallCategorys"];
    NSArray *bigCategorysArr = [dict valueForKey:@"bigCategorys"];
    
    NSMutableArray *parsingSmallCategorysMArr = [smallCategorysArr mutableCopy];
    for (NSDictionary* prodItemDic in prdArr) {
        NSInteger price = [[prodItemDic valueForKey:@"price"] integerValue];
        NSInteger saleCnt = [[prodItemDic valueForKey:@"saleCnt"] integerValue];
        NSNumber *salesAmount = [NSNumber numberWithInteger:price*saleCnt];
        
        NSMutableDictionary *newItemDict = [prodItemDic mutableCopy];
        [newItemDict setObject:salesAmount forKey:@"sales amount"];
        
        NSInteger categoryIdInt = [[newItemDict valueForKey:@"smallCategoryId"] integerValue];
        
        if ([parsingSmallCategorysMArr[categoryIdInt] valueForKey:@"products"]) {
            NSMutableArray *valueMuArr = [parsingSmallCategorysMArr[categoryIdInt] valueForKey:@"products"];
            [valueMuArr addObject:newItemDict];
            [[parsingSmallCategorysMArr[categoryIdInt] mutableCopy] setObject:valueMuArr forKey:@"products"];
        } else {
            NSMutableArray *valueMuArr = [NSMutableArray arrayWithObjects:newItemDict, nil];
            NSMutableDictionary *mDicItem = [parsingSmallCategorysMArr[categoryIdInt] mutableCopy];
            [mDicItem setObject:valueMuArr forKey:@"products"];
            [parsingSmallCategorysMArr replaceObjectAtIndex:categoryIdInt withObject:mDicItem];
        }
    }

    
    NSMutableArray *resultSmallCategorysMArr = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *smallCategorysDict in parsingSmallCategorysMArr) {
        NSArray *prdArrr =[smallCategorysDict valueForKey:@"products"];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sales amount" ascending:NO selector:@selector(compare:)];
        prdArrr = [prdArrr sortedArrayUsingDescriptors:@[descriptor]];
        [smallCategorysDict setObject:prdArrr forKey:@"products"];
        [resultSmallCategorysMArr addObject:smallCategorysDict];
    }
    
    
    NSMutableArray *resultBigCategorysMArr = [[NSMutableArray alloc] init];
    for (NSDictionary *bigCategorysItemDict in bigCategorysArr) {
        NSArray *subCategorysArr = [bigCategorysItemDict valueForKey:@"subCategorys"];
        
        NSMutableArray *bigCategorysProdMArr = [[NSMutableArray alloc] init];
        for (NSNumber *categoryNum in subCategorysArr) {
            NSInteger categoryId = [categoryNum integerValue];
            NSArray *prodArr =  [resultSmallCategorysMArr[categoryId] valueForKey:@"products"];
            for (NSDictionary *prodDict in prodArr) {
                [bigCategorysProdMArr addObject:prodDict];
            }
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sales amount" ascending:NO selector:@selector(compare:)];
        NSArray *bigCategorysProdArr = [bigCategorysProdMArr copy];
        bigCategorysProdArr = [bigCategorysProdArr sortedArrayUsingDescriptors:@[descriptor]];
        
        NSMutableDictionary *bigCategorysItemMDict = [bigCategorysItemDict mutableCopy];
        [bigCategorysItemMDict setObject:bigCategorysProdArr forKey:@"products"];
        [resultBigCategorysMArr addObject:bigCategorysItemMDict];
    }
    
    NSLog(@"여기탐 : %@",resultBigCategorysMArr);
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
