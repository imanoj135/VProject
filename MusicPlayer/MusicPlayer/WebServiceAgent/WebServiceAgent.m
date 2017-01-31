//
//  WebServiceAgent.m
//  sample
//
//  Created by Manoj on 1/31/17.
//  Copyright © 2016 prabu. All rights reserved.
//

#import "WebServiceAgent.h"
#import "Constants.h"
#define URLSESSION_TIMEOUT_PERIOD 60.0
#define URLSESSION_MAX_CONNECTIONS 10

@implementation WebServiceAgent
@synthesize delegate;
@synthesize session,webServiceDownloadQueue;

//called when the url download starts
- (void)downloadStarted {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//called when the url download is completed
- (void)downloadEnded {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (id)init
{
    if (self = [super init])
    {
        self.webServiceDownloadQueue = [NSMutableDictionary new];
        NSURLSessionConfiguration *sessionconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionconfig.timeoutIntervalForRequest = URLSESSION_TIMEOUT_PERIOD;
        sessionconfig. HTTPMaximumConnectionsPerHost = URLSESSION_MAX_CONNECTIONS;
        self.session = [NSURLSession sessionWithConfiguration:sessionconfig delegate:self delegateQueue:nil];
    }

    return self;
}


- (void)getJSONResponse:(NSString *)strURL
{

    @try {
        [self downloadStarted];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:strURL]];
        [request setHTTPMethod:@"GET"];
        [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [self downloadEnded];
            if(error){
                [self.delegate handleError:error];
            }
            else{
                [self responseDataSuccessful:data];
            }
        }] resume];
    }
    @catch (NSException * e) {
        NSLog(@"Exception :%@:", [e description]);
    }
}

-(void)responseDataSuccessful:(NSData *)response{

    [self.delegate setResponseData:response];
}


@end
