//
//  MOBILE006Tests.m
//  MOBILE006Tests
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DBMgr.h"
#import "NetProtocol.h"
#import "ListViewController.h"
#import "DetailViewController.h"

@interface MOBILE006Tests : XCTestCase

@end

@implementation MOBILE006Tests {
    ListViewController *listVC;
    DetailViewController *detailVC;
}

- (void)setUp {
    [super setUp];
    NSString *dummyKeyStr = @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg";
    [[DBMgr sharedInstance] initInstance];
    [[DBMgr sharedInstance] loadImage:dummyKeyStr callback:nil];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    listVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    [listVC performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    detailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [detailVC performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    detailVC.itemDict = @{@"date_taken": @"2015-04-18 12:42:56",
                          @"width": @"1024",
                          @"url": @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg",
                          @"height": @"761",
                          @"title": @"Homemade Steak Pie, Seasoned Wedges, Coleslaw, Salad, Pot of Gravy"
                          };
    
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark DBMgr

- (void)testParsingResponseData {
    XCTAssertNil([[DBMgr sharedInstance] getPhotosArr]);
    XCTAssertNil([[DBMgr sharedInstance] getStateStr]);
    XCTAssertNil([[DBMgr sharedInstance] getCurrentPageNum]);
    XCTAssertNil([[DBMgr sharedInstance] getTotalPageNum]);
    
    NSDictionary *testDict = @{@"stat":@"ok",
                               @"page":@1,
                               @"total_page":@1,
                               @"photos":@[@{@"date_taken": @"2015-04-26 23:04:07",
                                             @"title": @"Some fish at steak.. #food #foodporn #yum #instafood #igerleeds #yummy #amazing #instagood #photooftheday #fish #dinner #lunch #breakfast #fresh #tasty #foodie #delish #delicious #eating #foodpic #foodpics #eat #hungry #foodgasm #hot #foods"
                                             },
                                           @{@"date_taken": @"2015-04-18 12:42:56",
                                             @"width": @"1024",
                                             @"url": @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg",
                                             @"height": @"761",
                                             @"title": @"Homemade Steak Pie, Seasoned Wedges, Coleslaw, Salad, Pot of Gravy"
                                               }
                                       ]
                               };
    [[DBMgr sharedInstance] parsingResponseData:testDict];
    XCTAssertEqualObjects([[DBMgr sharedInstance] getPhotosArr], [testDict valueForKey:@"photos"]);
    XCTAssertEqualObjects([[DBMgr sharedInstance] getStateStr], [testDict valueForKey:@"stat"]);
    XCTAssertEqualObjects([[DBMgr sharedInstance] getCurrentPageNum], [testDict valueForKey:@"page"]);
    XCTAssertEqualObjects([[DBMgr sharedInstance] getTotalPageNum], [testDict valueForKey:@"total_page"]);
}

- (void)testGetCurrentPageNum {
    XCTAssertNil([[DBMgr sharedInstance] getCurrentPageNum]);
    [self testParsingResponseData];
    XCTAssertEqualObjects([[DBMgr sharedInstance] getCurrentPageNum], @1);
}

- (void)testGetTotalPageNum {
    XCTAssertNil([[DBMgr sharedInstance] getTotalPageNum]);
    [self testParsingResponseData];
    XCTAssertEqualObjects([[DBMgr sharedInstance] getTotalPageNum], @1);
}

- (void)testGetStateStr {
    XCTAssertNil([[DBMgr sharedInstance] getStateStr]);
    [self testParsingResponseData];
    XCTAssertEqualObjects([[DBMgr sharedInstance] getStateStr], @"ok");
}

- (void)testGetPhotosArr {
    XCTAssertNil([[DBMgr sharedInstance] getPhotosArr]);
    [self testParsingResponseData];
    
    NSArray *testArr = @[@{@"date_taken": @"2015-04-26 23:04:07",
                           @"title": @"Some fish at steak.. #food #foodporn #yum #instafood #igerleeds #yummy #amazing #instagood #photooftheday #fish #dinner #lunch #breakfast #fresh #tasty #foodie #delish #delicious #eating #foodpic #foodpics #eat #hungry #foodgasm #hot #foods"
                           },
                         @{@"date_taken": @"2015-04-18 12:42:56",
                           @"width": @"1024",
                           @"url": @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg",
                           @"height": @"761",
                           @"title": @"Homemade Steak Pie, Seasoned Wedges, Coleslaw, Salad, Pot of Gravy"
                           }
                         ];
    XCTAssertEqualObjects([[DBMgr sharedInstance] getPhotosArr], testArr);
}

#pragma mark Image Cash

-(void)testLoadFromDisk {
    NSString *dummyKeyStr = @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg";
    NSString *resultKeyStr = [[DBMgr sharedInstance] md5:dummyKeyStr];
    XCTAssertEqualObjects([UIImage class], [[[DBMgr sharedInstance] loadFromDisk:resultKeyStr] class]);
}

-(void)testLoadFromMemory {
    NSString *dummyKeyStr = @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg";
    NSString *resultKeyStr = [[DBMgr sharedInstance] md5:dummyKeyStr];
    
    XCTAssertEqualObjects([UIImage class], [[[DBMgr sharedInstance] loadFromMemory:resultKeyStr] class]);
}

-(void)testMd5 {
    NSString *dummyKeyStr = @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg";
    NSString *resultKeyStr = [[DBMgr sharedInstance] md5:dummyKeyStr];
    XCTAssertEqualObjects(resultKeyStr, @"20E53514668A690C3A2BE8913EC9AD81");
}


#pragma mark ListViewController
- (void)testSetPage {
    listVC.pageControl.numberOfPages = 0;
    XCTAssertEqual(listVC.pageControl.numberOfPages, 0);
    [[DBMgr sharedInstance] setPhotosArr:@[@{@"date_taken": @"2015-04-26 23:04:07",
                                             @"title": @"Some fish at steak.. #food #foodporn #yum #instafood #igerleeds #yummy #amazing #instagood #photooftheday #fish #dinner #lunch #breakfast #fresh #tasty #foodie #delish #delicious #eating #foodpic #foodpics #eat #hungry #foodgasm #hot #foods"
                                             },
                                           @{@"date_taken": @"2015-04-18 12:42:56",
                                             @"width": @"1024",
                                             @"url": @"https://farm9.staticflickr.com/8773/16663421234_78fcc17edc_b.jpg",
                                             @"height": @"761",
                                             @"title": @"Homemade Steak Pie, Seasoned Wedges, Coleslaw, Salad, Pot of Gravy"
                                             }
                                           ]];
    [listVC setPage];
    XCTAssertEqual(listVC.pageControl.numberOfPages, 1);
}

#pragma mark Detail View Controller
- (void)testSetConst {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationPortrait] forKey:@"orientation"];
    XCTAssertNotEqual(detailVC.thumbnailImageConstWidth.constant, detailVC.view.frame.size.width - 32);
    XCTAssertNotEqual(detailVC.thumbnailImageConstHeight.constant, (detailVC.thumbnailImageConstWidth.constant * [[detailVC.itemDict valueForKey:@"height"] integerValue])/[[detailVC.itemDict valueForKey:@"width"] integerValue]);
    [detailVC setConst];
    XCTAssertEqual(detailVC.thumbnailImageConstWidth.constant, detailVC.view.frame.size.width - 32);
    XCTAssertEqual(detailVC.thumbnailImageConstHeight.constant, (detailVC.thumbnailImageConstWidth.constant * [[detailVC.itemDict valueForKey:@"height"] integerValue])/[[detailVC.itemDict valueForKey:@"width"] integerValue]);
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    
    XCTAssertEqual(detailVC.thumbnailImageConstWidth.constant, (detailVC.thumbnailImageConstHeight.constant * [[detailVC.itemDict valueForKey:@"width"] integerValue])/[[detailVC.itemDict valueForKey:@"height"] integerValue]);
}

- (void)testSetViewItem {
    detailVC.titleLabel.text = nil;
    detailVC.urlLabel.text = nil;
    detailVC.sizeLabel.text = nil;
    detailVC.dateLabel.text = nil;
    [detailVC setViewItem:detailVC.itemDict];
    
    XCTAssertEqualObjects(detailVC.titleLabel.text, [detailVC.itemDict valueForKey:@"title"]);
    XCTAssertEqualObjects(detailVC.urlLabel.text, [detailVC.itemDict valueForKey:@"url"]);
    XCTAssertEqualObjects(detailVC.dateLabel.text, [detailVC.itemDict valueForKey:@"date_taken"]);
    
    NSString *dummyDataStr = [NSString stringWithFormat:@"%@x%@",[detailVC.itemDict valueForKey:@"width"],[detailVC.itemDict valueForKey:@"height"]];
    XCTAssertEqualObjects(detailVC.sizeLabel.text, dummyDataStr);
    
}


@end
