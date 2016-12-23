//
//  WEBPS004TableViewController.m
//  JuhoHomeWorkTest
//
//  Created by Juho Yoon on 2016. 12. 16..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "WEBPS004TableViewController.h"

@interface WEBPS004TableViewController ()

@property (strong, nonatomic) NSArray *inputDataArr;
@property (strong, nonatomic) NSDictionary *outputDataDict;

@property (nonatomic) NSInteger inputTabelCount;
@property (nonatomic) NSInteger outputTabelCount;

@end

@implementation WEBPS004TableViewController
static NSInteger const inputSection = 0;
static NSInteger const outputSection = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setInputData];
    self.outputDataDict = [self sortDealAndOptionId:self.inputDataArr];
    self.outputTabelCount = self.outputDataDict.count + 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setInputData {
    self.inputDataArr = @[@[@110,@10],@[@101,@9],@[@101,@8],@[@103,@7],@[@105,@6],@[@105,@5],@[@101,@4],@[@103,@3],@[@103,@2],@[@110,@1]];
    self.inputTabelCount = self.inputDataArr.count + 1;
}


- (NSDictionary *)sortDealAndOptionId:(id)inputData {

    NSArray *inputDataArr = [inputData copy];
    NSMutableDictionary *sortDataDic = [[NSMutableDictionary alloc] init];
    
    for (NSArray *arrItem in inputDataArr) {
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
    
    NSLog(@"LOG_sortDataDic :%@",sortDataDic);
    
    return [sortDataDic copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleText = [[NSString alloc] init];
    switch (section) {
        case 0:
            titleText = @"input)";
            break;
        case 1:
            titleText = @"output)";
            break;
            
        default:
            break;
    }
    
    return titleText;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == inputSection) {
        return self.inputTabelCount;
    } else if (section == outputSection) {
        return self.outputTabelCount;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEBPS004TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEBPS004TableViewCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.dealIdLabel.text = @"딜아이디";
        cell.optionIdLabel.text = @"옵션아이디";
    } else {
        if (indexPath.section == inputSection) {
            NSArray* cellItem =  self.inputDataArr[indexPath.row-1];
            cell.dealIdLabel.text = [NSString stringWithFormat:@"%@",cellItem[0]];
            cell.optionIdLabel.text = [NSString stringWithFormat:@"%@",cellItem[1]];
            
        } else if (indexPath.section == outputSection) {
            NSArray *keyArr = [[self.outputDataDict allKeys] sortedArrayUsingComparator:^(id a, id b){
                return [a compare:b];
            }];
            
            NSArray *valueArr = [self.outputDataDict valueForKey:[NSString stringWithFormat:@"%@",keyArr[indexPath.row-1]]];
            NSString *valueStr = [valueArr componentsJoinedByString:@","];
            
            
            cell.dealIdLabel.text = [NSString stringWithFormat:@"%@",keyArr[indexPath.row-1]];
            cell.optionIdLabel.text = valueStr;
            
        }
    }
    return cell;
}
@end



@interface WEBPS004TableViewCell()

@end

@implementation WEBPS004TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
@end
