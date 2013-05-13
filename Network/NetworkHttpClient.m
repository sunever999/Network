//
//  NetworkHttpClient.m
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkHttpClient.h"
#import "NetworkManager.h"


@implementation NetworkHttpClient 

@synthesize connection;
@synthesize buf;
@synthesize delegate;


#pragma mark - Interface Method

- (void)asynchRequest:(NSMutableURLRequest *)aRequest requestTag:(RequestTag)iTag httpMethod:(NSString *)
    aHttpMedthod complete:(void(^)(ResponseEntity*))requestFinished
{
	statusCode = 0;
	
    rTag = iTag;
    
    requestComplete = requestFinished;
	
	self.buf = [NSMutableData data];
	
    [aRequest setHTTPMethod:aHttpMedthod];
	connection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


#pragma mark - NSURLConnection Delegate Method

-(void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)aResponse;
	if (resp) {
		statusCode = resp.statusCode;
		NSLog(@"Response: %d", statusCode);

        if (statusCode != 200) {
            if (requestComplete) {
                ResponseEntity *responseEntity = [[ResponseEntity alloc] init];
                responseEntity.success = NO;
                responseEntity.responseHttpCode = statusCode;
                requestComplete(responseEntity);
                [responseEntity release];
            }
        }
    }
	[buf setLength:0];
	
}

-(void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	[buf appendData:data];
}

-(void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
	NSNumber *code = [[[NSNumber alloc] initWithInt:statusCode] autorelease];
	NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];
	
    NSLog(@"Connection failed: %@ [%d]", msg, [code integerValue]);
    if (requestComplete) {
        ResponseEntity *responseEntity = [[ResponseEntity alloc] init];
        responseEntity.success = NO;
        responseEntity.responseHttpCode = statusCode;
        responseEntity.errorMsg = msg;
        responseEntity.errorCode = code;
        requestComplete(responseEntity);
        [responseEntity release];
    }
	
	self.connection = nil;
	self.buf = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 从交互列表中删除本次交互
    [[NetworkManager sharedManager] deleteHttpClientWithKey:[NSString stringWithFormat:@"%d", rTag]];
}

- (void)cancelLoading
{
    [self.connection cancel];
    self.connection = nil;
    self.buf = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 从交互列表中删除本次交互
    [[NetworkManager sharedManager] deleteHttpClientWithKey:[NSString stringWithFormat:@"%d", rTag]];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSString *msg = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    
    NSNumber *code = [[[NSNumber alloc] initWithInt:statusCode] autorelease];
    if (statusCode == 200) {
        if (requestComplete) {
            ResponseEntity *responseEntity = [[ResponseEntity alloc] init];
            responseEntity.success = YES;
            responseEntity.responseHttpCode = statusCode;
            responseEntity.responseData = buf;
            requestComplete(responseEntity);
            [responseEntity release];
        }
    }
    else {        
        if (requestComplete) {
            ResponseEntity *responseEntity = [[ResponseEntity alloc] init];
            responseEntity.success = NO;
            responseEntity.responseHttpCode = statusCode;
            responseEntity.errorCode = code;
            responseEntity.errorMsg = msg;
            requestComplete(responseEntity);
            [responseEntity release];
        }
    }
    
	self.connection = nil;
	self.buf = nil;
    
    // 从交互列表中删除本次交互
    [[NetworkManager sharedManager] deleteHttpClientWithKey:[NSString stringWithFormat:@"%d", rTag]];
}

-(void)dealloc
{
//    NSLog(@"NetworkHttpClient dealloc");
	[connection release];
	[buf release];
    
	[super dealloc];
}

@end
