//
//  Header.h
//  1st
//
//  Created by Juho Yoon on 2016. 12. 15..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#ifndef HATA_TMS_MOBILEAPP_NetProtocolDelegate_h
#define HATA_TMS_MOBILEAPP_NetProtocolDelegate_h

#import <Foundation/Foundation.h>

@class NetProtocol;
@class NetProtocolResponse;
@class NetProtocolError;

/** NetProtocolDelegate
 
 Common protocol delegate of NetProtocol object
 */
@protocol NetProtocolDelegate <NSObject>

@required
/**
 *  Protocol did Fail with error
 *
 *  @param protocol Self
 *  @param error    Error object, An error object containing details of why the connection failed to load the request successfully.
 */
- (void)protocol:(NetProtocol *)protocol didFailWithError:(NetProtocolError *)error;
/**
 *  Protocol did Success with error
 *
 *  @param protocol Self
 *  @param error    Error object, An error object containing details of why the connection failed to load the request successfully.
 */
- (void)protocolDidSuccess:(NetProtocol *)protocol withError:(NetProtocolError *)error;
/**
 *  Protocol did Success with response
 *
 *  @param protocol Self
 *  @param response Response object
 */
- (void)protocolDidSuccess:(NetProtocol *)protocol withResponse:(NetProtocolResponse *)response;

@end

#endif
