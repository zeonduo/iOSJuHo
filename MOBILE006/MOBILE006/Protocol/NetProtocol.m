//
//  NetProtocol.m
//  MOBILE006
//
//  Created by Juho Yoon on 2016. 12. 17..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import "NetProtocol.h"
#import "DBMgr.h"

@implementation NetProtocol

+ (nonnull instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)requestAPi {
    __block NSDictionary *responseAPIJsonResultDict = [[NSDictionary alloc] init];
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
                responseAPIJsonResultDict = jsonResult;
                [[DBMgr sharedInstance] parsingResponseData:jsonResult];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"API_Response" object:nil];
            }
        } else {
            [self repeatRequestAPI];
        }
    }] resume];
}

// 알림창
- (void)repeatRequestAPI {
    NSString *titleString = @"API 로드 실패";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString
                                                                             message:@"API 요청에 실패했습니다.\n다시 요청 하시려면\n'재시도'버튼을 클릭하세요."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"재시도"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         [self requestAPi];
                                                     }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                     }];
    [alertController addAction:retryAction];
    [alertController addAction:okAction];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
