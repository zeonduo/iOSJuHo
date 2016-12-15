//
//  Netprotocol.m
//  1st
//
//  Created by Juho Yoon on 2016. 12. 15..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "Netprotocol.h"

@implementation Netprotocol


-(void)requestWithURL:(NSURL *)url header:(NSDictionary *)header body:(NSDictionary *)body delegate:(id<NetProtocolDelegate>)delegate {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    
    // clear data
//    self.recvData = [NSMutableData data];
    
    // connect server
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn start];
}

- (void)forcedToCancel
{
    if (nil != self.theConnection) {
        [self.theConnection cancel];
    }
    
//    [self clearProtocolMembers];
}

- (BOOL)isConnect
{
    if (nil != self.theResponseData
        || nil != self.theHttpResponse
        || nil != self.theConnection
        || nil != self.theURLRequest
        || nil != self.theDelegate
        )
    {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}
@end
