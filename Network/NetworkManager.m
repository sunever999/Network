//
//  NetworkManager.m
//  songguo
//
//  Created by songguo on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"
#import "NetworkAssist.h"
#import "NetworkHttpClient.h"

#import "sys/utsname.h"

#define FORM_BOUNDARY @"JianShiSugarLadyBoUnDaRY"

@implementation NetworkManager

@synthesize httpClientDic;

#pragma mark - Interface Method

- (void)deleteHttpClientWithKey:(NSString *)key {
    [self.httpClientDic removeObjectForKey:key];
}

- (void)stopHttpRequestWithTag:(NSString *)requestTag {
    NetworkHttpClient *nhc = [self.httpClientDic objectForKey:requestTag];
    if (nhc) {
        [nhc cancelLoading];
        [self deleteHttpClientWithKey:requestTag];
    }
}

- (void)stopAllHttpClient {
    for (NSString *key in [self.httpClientDic allKeys]) {
        NetworkHttpClient *nhc = [self.httpClientDic objectForKey:key];
        [nhc cancelLoading];
    }
    
    self.httpClientDic = [NSMutableDictionary dictionary];
}

#pragma mark - Reachability

- (BOOL)isNetworkOK
{
    Reachability *r = [Reachability reachabilityWithHostName:@"m.baidu.com"];
    
    if ([r currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)isNetworkWifi
{
    Reachability *r = [Reachability reachabilityWithHostName:@"m.baidu.com"];
    
    if ([r currentReachabilityStatus] == kReachableViaWiFi) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)parseErrorMsg:(NSDictionary *)dic
{
    if (dic == nil) {
        return;
    }
    
    self.errorMsg = [dic objectForKey:@"errStr"];
}


#pragma mark - Private Method

- (void)submitAsynchRequestWithRequest:(NSMutableURLRequest *)request Tag:(RequestTag)iTag httpMethod:(NSString *)method complete:(void(^)(ResponseEntity*))requestFinished
{
    //*********终止相同交互，执行最新交互，并保存该交互至交互队列，交互结束删除 （key为该交互Tag）*********⬇
    NSString *keyForHttpClient = [NSString stringWithFormat:@"%d",iTag];
    NetworkHttpClient *httpClient = [self.httpClientDic objectForKey:keyForHttpClient];
    
    if (httpClient != nil) {
        [httpClient cancelLoading];
    }
    httpClient=[[NetworkHttpClient alloc]init];
//    [httpClient asynchRequest:request interactiveTag:iTag httpMethod:method delegate:aDelegate onSuccess:aSuccess onFail:aFail];
    [httpClient asynchRequest:request requestTag:iTag httpMethod:method complete:requestFinished];
    
    [self.httpClientDic setObject:httpClient forKey:keyForHttpClient];
    [httpClient release];
    //*********终止相同交互，执行最新交互，并保存该交互至交互队列，交互结束删除 （key为该交互Tag）*********⬆    
}

- (void)doGetRequestWithPath:(NSString *)path queryParameters:(NSMutableDictionary *)params requestTag:(RequestTag)iTag complete:(void(^)(ResponseEntity*))requestFinished
{
    NSURL *url = [NetworkAssist getURL:path queryParameters:params];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [self submitAsynchRequestWithRequest:request Tag:iTag httpMethod:HTTP_GET complete:requestFinished];
}

////////////////////////////////////////////////////////////////
#pragma mark - http interface

- (NSString *)doRequest:(RequestEntity *)request complete:(void(^)(ResponseEntity*))requestFinished
{
    NSMutableDictionary *param = [request getRequestParameters];
    if (param == nil) {
        return nil;
    }
    
    [self doGetRequestWithPath:request.requestPath queryParameters:param
                    requestTag:request.requestTag complete:requestFinished];
    
    return [NSString stringWithFormat:@"%d", request.requestTag];
}

////////////////////////////////////////////////////////////////
#pragma mark - Singleton

+ (id)sharedManager
{
    static NetworkManager *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init])) {
        //Initialize the instance here.
        //            NSLog(@"init NetworkManager.");
        self.httpClientDic = [NSMutableDictionary dictionary];
        _errorMsg = [[NSString alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [httpClientDic release];
    [_errorMsg release];
    
    [super dealloc];
}


@end
