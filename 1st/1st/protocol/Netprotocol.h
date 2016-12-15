//
//  Netprotocol.h
//  1st
//
//  Created by Juho Yoon on 2016. 12. 15..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetProtocolDelegate.h"

@interface Netprotocol : NSObject <NSURLConnectionDelegate>
@property (unsafe_unretained, nonatomic) id <NetProtocolDelegate> theDelegate;

@property (strong, nonatomic) NSMutableURLRequest   *theURLRequest;
@property (strong, nonatomic) NSURLConnection       *theConnection;
@property (strong, nonatomic) NSHTTPURLResponse     *theHttpResponse;
@property (strong, nonatomic) NSMutableData         *theResponseData;
@property (strong, nonatomic) NSDate                *requestTime;

@property (copy,   nonatomic) NSString              *theAPICode;

/**
 *  Request with URL
 *
 *  @param url      The URL request to load
 *  @param header   Header of request https
 *  @param body     Body contents of request https
 *  @param delegate Delegate of receiver
 */
- (void)requestWithURL:(NSURL *)url header:(NSDictionary *)header body:(NSDictionary *)body delegate:(id <NetProtocolDelegate>)delegate;

/**
 *  Cancels an asynchronous load of a request
 */
- (void)forcedToCancel;

/**
 *  Get current connection status
 *
 *  @return Returns YES if TODS is connected
 */
- (BOOL)isConnect;


@end
