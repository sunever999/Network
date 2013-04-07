//
//  NetworkManager.h
//  songguo
//
//  Created by songguo on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConstans.h"

@interface NetworkManager : NSObject {
    // 交互字典
    NSMutableDictionary *httpClientDic;
}

@property (nonatomic, retain) NSMutableDictionary *httpClientDic;
@property (nonatomic, retain) NSString *errorMsg;

+ (id) sharedManager;

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


#pragma mark - 按颜色查询(A，B，C三件单品，1，随机取，2，按用户选择类型取，3，A不变，更换B，C）
- (NSString *)getSuitByColorId:(NSString *)colorId category:(NSString *)category mainItemId:(NSString *)itemId
                          city:(NSString *)cityId editorChoice:(BOOL)isEdtorChoice unTrack:(BOOL)unTrack
                      delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;


#pragma mark - --- 杂项 ---

#pragma mark - 获取热点城市
- (NSString *)getHotcities:(void(^)(BOOL))requestFinished;

#pragma mark - 获取App Store上的版本号
- (NSString *)getAppVersionFromAppStore:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

@end
