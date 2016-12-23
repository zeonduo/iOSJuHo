//
//  DBMgr.h
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBMgr : NSObject
+ (nonnull instancetype) sharedInstance;
- (void)initInstance;
@property (strong, nonatomic, nullable) NSNumber *currentPageNum;
@property (strong, nonatomic, nullable) NSNumber *totalPageNum;
@property (copy, nonatomic, nullable) NSString *stateStr;
@property (strong, nonatomic, nullable) NSArray *photosArr;

#pragma mark API Data Parsing
- (void)parsingResponseData:(nullable NSDictionary *)response;

#pragma mark Get Data
- (nullable NSNumber *)getCurrentPageNum;
- (nullable NSNumber *)getTotalPageNum;
- (nullable NSString *)getStateStr;
- (nullable NSArray *)getPhotosArr;

#pragma mark Image Cash
@property (strong, nonatomic, nullable) NSMutableDictionary* imageCacheMDict;
- (void) loadImage:(nullable NSString *) urlStr callback:(nullable void (^)( UIImage * _Nonnull image))callback;
- (nullable UIImage *)saveToDisk:(nullable UIImage *)image withKey:(nullable NSString *)key;
- (nullable UIImage *)loadFromDisk:(nullable NSString *)key;
- (nullable UIImage *)saveToMemory:(nullable UIImage *)image withKey:(nullable NSString *)key;
- (nullable UIImage *)loadFromMemory:(nullable NSString *)key;
- (nullable UIImage *)makeThumbnail:(nullable UIImage *)image;
- (nullable NSString *)md5:(nullable NSString *)str;
@end
