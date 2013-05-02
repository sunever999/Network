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
//#import "NSData+AESCrypt.h"

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

- (void)submitAsynchRequestWithRequest:(NSMutableURLRequest *)request Tag:(RequestTag)iTag httpMethod:(NSString *)method delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail {
    //*********终止相同交互，执行最新交互，并保存该交互至交互队列，交互结束删除 （key为该交互Tag）*********⬇
    NSString *keyForHttpClient = [NSString stringWithFormat:@"%d",iTag];
    NetworkHttpClient *httpClient = [self.httpClientDic objectForKey:keyForHttpClient];
    
    if (httpClient != nil) {
        [httpClient cancelLoading];
    }
    httpClient=[[NetworkHttpClient alloc]init];
    [httpClient asynchRequest:request interactiveTag:iTag httpMethod:method delegate:aDelegate onSuccess:aSuccess onFail:aFail];
    
    [self.httpClientDic setObject:httpClient forKey:keyForHttpClient];
    [httpClient release];
    //*********终止相同交互，执行最新交互，并保存该交互至交互队列，交互结束删除 （key为该交互Tag）*********⬆
}

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

- (void)doAsynchRequestWithPath:(NSString *)path queryParameters:(NSMutableDictionary*)params requestTag:(RequestTag)iTag httpMethod:(NSString *)method delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail {
    
    NSURL *url = nil;
    NSMutableURLRequest *request = nil;
    // 如果HTTP请求方式是POST
    if ([method isEqualToString:HTTP_POST]) {
        
        // 是否有图片
        BOOL hasImage = NO;
        for (NSString *key in [params allKeys]) {
            if ([[params objectForKey:key] isKindOfClass:[UIImage class]]) {
                hasImage = YES;
                break;
            }
        }
        
        // 有图片
        if (hasImage) {
            
            NSData *headerBoundary = [[NSString  stringWithFormat:@"\r\n--%@\r\n",FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
            NSData *footerBoundary = [[NSString  stringWithFormat:@"\r\n--%@--\r\n",FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
            
            url = [NetworkAssist getURL:path queryParameters:nil];
            request = [NSMutableURLRequest requestWithURL:url];
            [request setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", FORM_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
            
            NSMutableData *paramsData = [NSMutableData data];
            
            for (NSString *key in [params allKeys]) {
                // 图片数据
                if ([[params objectForKey:key] isKindOfClass:[UIImage class]]) {
                    
                    UIImage *img = (UIImage *)[params objectForKey:key];
                    NSData *imageData = (img) ? UIImagePNGRepresentation(img) : nil;
                    
                    if (imageData) {
                        // 分隔
                        [paramsData  appendData: headerBoundary];
                        
                        [paramsData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"image.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        [paramsData  appendData: [@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        
                        [paramsData  appendData:imageData];
                    }   
                }
                // 文本数据
                else if ([[params objectForKey:key] isKindOfClass:[NSString class]]) {
                    
                    // 分隔
                    [paramsData  appendData: headerBoundary];
                    
                    // Key
                    [paramsData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // Value
                    [paramsData  appendData: [[NSString  stringWithFormat:@"%@",[params objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                }
            }
            
            // 结束
            [paramsData  appendData: footerBoundary];
            NSString *paramsLength = [NSString stringWithFormat:@"%d", [paramsData length]];
            
            [request setValue:paramsLength forHTTPHeaderField:@"Content-Length"];  
            [request setHTTPBody:paramsData];
            
        }
        else    // if (hasImage)
        {
            url = [NetworkAssist getURL:path queryParameters:nil];
                        
            NSMutableString *paramsStr = [NSMutableString string];
            for (NSString *key in [params allKeys]) {
                [paramsStr appendFormat:@"&%@=%@",key,[params valueForKey:key]];
            }
            [paramsStr deleteCharactersInRange:NSMakeRange(0, 1)];
            
            NSData *paramsData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *paramsLength = [NSString stringWithFormat:@"%d", [paramsData length]];
            
            request = [NSMutableURLRequest requestWithURL:url];
            
            [request setValue:paramsLength forHTTPHeaderField:@"Content-Length"];
#pragma mark TODO update value for json
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:paramsData];
        }
        
    }
    else    // if ([method isEqualToString:HTTP_POST])
    {
        url = [NetworkAssist getURL:path queryParameters:params];
        request = [NSMutableURLRequest requestWithURL:url];
    }
    
    [self submitAsynchRequestWithRequest:request Tag:iTag httpMethod:method delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}


- (void)doGetRequestWithPath:(NSString *)path queryParameters:(NSMutableDictionary*)params requestTag:(RequestTag)iTag delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
    NSURL *url = [NetworkAssist getURL:path queryParameters:params];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [self submitAsynchRequestWithRequest:request Tag:iTag httpMethod:HTTP_GET delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

- (void)doGetRequestWithPath:(NSString *)path queryParameters:(NSMutableDictionary *)params requestTag:(RequestTag)iTag complete:(void(^)(ResponseEntity*))requestFinished
{
    NSURL *url = [NetworkAssist getURL:path queryParameters:params];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [self submitAsynchRequestWithRequest:request Tag:iTag httpMethod:HTTP_GET complete:requestFinished];
}

- (void)doPostRequestWithPath:(NSString *)path queryParam:(NSMutableDictionary *)params requestTag:(RequestTag)iTag delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
    
    NSData *headerBoundary = [[NSString  stringWithFormat:@"\r\n--%@\r\n",FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *footerBoundary = [[NSString  stringWithFormat:@"\r\n--%@--\r\n",FORM_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NetworkAssist getURL:path queryParameters:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", FORM_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *paramsData = [NSMutableData data];
    
    for (NSString *key in [params allKeys]) {
        
        if ([[params objectForKey:key] isKindOfClass:[UIImage class]]) {
            UIImage *img = (UIImage *)[params objectForKey:key];
            NSData *imageData = (img) ? UIImagePNGRepresentation(img) : nil;
            
            if (imageData) {
                // 分隔
                [paramsData  appendData: headerBoundary];
                
                [paramsData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"image.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [paramsData  appendData: [@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                [paramsData  appendData:imageData];
            }
        }
        else if ([[params objectForKey:key] isKindOfClass:[NSString class]]) {
            // 分隔
            [paramsData  appendData: headerBoundary];
            
            // Key
            [paramsData  appendData: [[NSString  stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Value
            [paramsData  appendData: [[NSString  stringWithFormat:@"%@",[params objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }

    // 结束
    [paramsData  appendData: footerBoundary];
    NSString *paramsLength = [NSString stringWithFormat:@"%d", [paramsData length]];
    
    [request setValue:paramsLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:paramsData];

    [self submitAsynchRequestWithRequest:request Tag:iTag httpMethod:HTTP_POST delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

////////////////////////////////////////////////////////////////
#pragma mark - http interface


#pragma mark - 获取热点城市
- (NSString *)getHotcities:(void(^)(ResponseEntity*))requestFinished
{
//    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getHotCities", @"cmd", nil];
//
//    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Hot_Cities complete:requestFinished];
//    
//    return [NSString stringWithFormat:@"%d", Request_Hot_Cities];
    
    return nil;
}


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
