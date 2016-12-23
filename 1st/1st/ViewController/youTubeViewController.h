//
//  youTubeViewController.h
//  1st
//
//  Created by Juho Yoon on 2016. 12. 14..
//  Copyright © 2016년 Juho Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "NetProtocolDelegate.h"

@interface youTubeViewController : UIViewController
@property (strong, nonatomic) IBOutlet YTPlayerView *youtubeView;


//

//@property (unsafe_unretained, nonatomic) id <NetProtocolDelegate> theDelegate;
//
//@property (strong, nonatomic) NSMutableURLRequest   *theURLRequest;
//@property (strong, nonatomic) NSURLConnection       *theConnection;
//@property (strong, nonatomic) NSHTTPURLResponse     *theHttpResponse;
//@property (strong, nonatomic) NSMutableData         *theResponseData;
//@property (strong, nonatomic) NSDate                *requestTime;
//
//@property (copy,   nonatomic) NSString              *theAPICode;

//@property (strong, nonatomic) NetRequestItem        *theRequestItem;

@end
