//
//  DBMgr.m
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "DBMgr.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DBMgr

#pragma mark DB Init
+ (nonnull instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initInstance];
    });
    
    return sharedInstance;
}

- (void)initInstance {
    if (self.currentPageNum) {
        self.currentPageNum = nil;
    }
    if (self.totalPageNum) {
        self.totalPageNum = nil;
    }
    if (self.photosArr) {
        self.photosArr = nil;
    }
    if (self.stateStr) {
        self.stateStr = nil;
    }
    
    if (self.imageCacheMDict) {
        NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
        self.imageCacheMDict = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
}

#pragma mark API Data Parsing
- (void)parsingResponseData:(nullable NSDictionary *)response {
    NSDictionary *jsonResultDict = response;
    NSNumber *currentPageNum = [[NSNumber alloc] init];
    NSNumber *totalPageNum = [[NSNumber alloc] init];
    NSString *stateStr = [[NSString alloc] init];
    NSArray *photosArr = [[NSArray alloc] init];
    
    // 에러 처리
    if ([[jsonResultDict valueForKey:@"page"] class] != [NSNumber class]) {
        currentPageNum = [NSNumber numberWithLong:[[jsonResultDict valueForKey:@"page"] integerValue]];
    } else {
        currentPageNum = [jsonResultDict valueForKey:@"page"];
    }
    
    if ([[jsonResultDict valueForKey:@"total_page"] class] != [NSNumber class]) {
        totalPageNum = [NSNumber numberWithLong:[[jsonResultDict valueForKey:@"total_page"] integerValue]];
    } else {
        totalPageNum = [jsonResultDict valueForKey:@"total_page"];
    }
    
    if ([[jsonResultDict valueForKey:@"stat"] class] != [NSString class]) {
        stateStr = [NSString stringWithFormat:@"%@",[jsonResultDict valueForKey:@"stat"]];
    } else {
        stateStr = [jsonResultDict valueForKey:@"stat"];
    }
    
    if ([[jsonResultDict valueForKey:@"photos"] class] != [NSArray class]) {
        photosArr = [[jsonResultDict valueForKey:@"photos"] copy];
    } else {
        photosArr = [jsonResultDict valueForKey:@"photos"];
    }
    
    //DBMgr Cash 저장.
    [self setCurrentPageNum:currentPageNum];
    [self setTotalPageNum:totalPageNum];
    [self setStateStr:stateStr];
    [self setPhotosArr:photosArr];
}

#pragma mark Get Data
- (nullable NSNumber *)getCurrentPageNum {
    if (self.currentPageNum) {
        return self.currentPageNum;
    } else {
        return nil;
    }
}

- (nullable NSNumber *)getTotalPageNum {
    if (self.totalPageNum) {
        return self.totalPageNum;
    } else {
        return nil;
    }
}

- (nullable NSString *)getStateStr {
    if (self.stateStr) {
        return self.stateStr;
    } else {
        return nil;
    }
}

- (nullable NSArray *)getPhotosArr {
    if (self.photosArr) {
        return self.photosArr;
    } else {
        return nil;
    }
}


#pragma mark Image Cash
- (void)loadImage:(NSString *)urlStr callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        UIImage *image = nil;
        
        if (url != nil) {
            NSString *key = [self md5:[url absoluteString]];
            
            //DBMgr Cash Image
            UIImage *cachedImage = [self loadFromMemory:key];
            
            if (cachedImage == nil) {
                //File Image
                cachedImage = [self loadFromDisk:key];
                [self saveToMemory:cachedImage withKey:key];
            }
            
            if (cachedImage != nil) {
                image = cachedImage;
            } else {
                //URL Image Call
                image = [self loadFromUrl:url];
                
                //이미지 저장
                [self saveToMemory:image withKey:key];
                [self saveToDisk:image withKey:key];
            }
        }
        
        if (image == nil) {
            image = [UIImage imageNamed:@"unnamed"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(image);
        });
    });
}

- (UIImage *)saveToDisk:(UIImage *)image withKey:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, key];
    
    UIImage *thumbnail = [self makeThumbnail:image];
    
    [UIImagePNGRepresentation(thumbnail) writeToFile:path atomically:YES];
    
    return thumbnail;
}

- (UIImage *)saveToMemory:(UIImage *)image withKey:(NSString *)key {
    if (self.imageCacheMDict == nil) {
        self.imageCacheMDict = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    
    UIImage *thumbnail = [self makeThumbnail:image];
    [self.imageCacheMDict setObject:thumbnail forKey:key];
    
    return thumbnail;
}

- (UIImage *)loadFromDisk:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, key];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return image;
}

- (UIImage *)loadFromMemory:(NSString *)key {
    if (self.imageCacheMDict == nil){
        return nil;
    }
    UIImage *cachedImage = [self.imageCacheMDict objectForKey:key];
    return cachedImage;
}

- (UIImage *)loadFromUrl:(NSURL *)url {
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    image = [self makeThumbnail:image];
    return image;
}

- (UIImage *)makeThumbnail:(UIImage *)image {
    CGSize destSize = CGSizeMake(256, 256);
    UIGraphicsBeginImageContext(destSize);
    [image drawInRect:CGRectMake(0, 0, destSize.width, destSize.height)];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbnail;
}
//MD5 Hash String
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}
@end
