//
//  WebServiceAgent.h
//  sample
//
//  Created by Manoj on 1/31/17.
//  Copyright © 2016 prabu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Protocol for the parser to communicate with its delegate.
@protocol ServiceAgentDelegate <NSObject>

@optional
-(void)handleSessionTimeOut:(NSString*)requestURL requestData:(NSData*)requestData requestDictionary:(NSDictionary*)reqDict;

@required
- (void)setResponseData:(NSData *)data;
- (void)handleError:(NSError *)error;
@end

@interface WebServiceAgent : NSObject<NSURLSessionDelegate>{
@private
    __weak id <ServiceAgentDelegate> delegate;

}


- (void)getJSONResponse:(NSString *)strURL;

@property (nonatomic, weak)__weak id <ServiceAgentDelegate> delegate;

@property (strong, nonatomic) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *webServiceDownloadQueue;
@end
