//
//  NetworkManager.h
//  songguo
//
//  Created by songguo on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstans.h"
#import "RequestEntity.h"
#import "ResponseEntity.h"

@interface NetworkManager : NSObject {
    // 交互字典
    NSMutableDictionary *httpClientDic;
}

@property (nonatomic, retain) NSMutableDictionary *httpClientDic;
@property (nonatomic, retain) NSString *errorMsg;

+ (id)sharedManager;

- (BOOL)isNetworkOK;    // 判断网络是否通
- (BOOL)isNetworkWifi;  // 判断是否通过wifi联网

- (void)parseErrorMsg:(NSDictionary *)dic;

#pragma mark - 交互

/*-------------------------
 停止所有交互动作
 ---------------------------*/
- (void)stopAllHttpClient;

/*-------------------------
 停止指定交互
 ---------------------------*/
- (void)stopHttpRequestWithTag:(NSString *)requestTag;

/*-------------------------
 删除交互
 ---------------------------*/
- (void)deleteHttpClientWithKey:(NSString *)key;


////////////////////////////////////////////////////////////////
#pragma mark - http interface

- (NSString *)doRequest:(RequestEntity *)request complete:(void(^)(ResponseEntity*))requestFinished;


@end
