//
//  NetProtocol.h
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetProtocol : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)requestAPi;

@end
