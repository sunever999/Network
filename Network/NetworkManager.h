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

#pragma mark - 获取Token
- (NSString *)getTokenWithEmail:(NSString *)email
                     delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 用户注册
- (NSString *)registerWithEmail:(NSString *)email nick:(NSString *)nick salt:(NSString *)salt
                         pwSalt:(NSString *)pwSalt year:(NSString *)y
                       delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 第三方用户转成sugar用户
- (NSString *)convertUserFromTpByType:(NSString *)type mail:(NSString *)email nick:(NSString *)nick salt:(NSString *)salt
                               pwSalt:(NSString *)pwSalt year:(NSString *)year
                             delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 第三方信息注册苏格用户
- (NSString *)registerWithTpState:(NSString *)state delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 用户登录
- (NSString *)loginWithEmail:(NSString *)email password:(NSString *)pwd
                    delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取个人信息
- (NSString *)getUserInfo:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取第三方信息
- (NSString *)getThirdInfoWithType:(NSString *)type delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 上传用户头像
- (NSString *)uploadUserAvatar:(UIImage *)avatar delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 刷新用户登录
- (NSString *)refreshUserLogin:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 用户反馈
- (NSString *)feedbackWithContent:(NSString *)content delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 按颜色查询(A，B，C三件单品，1，随机取，2，按用户选择类型取，3，A不变，更换B，C）
- (NSString *)getSuitByColorId:(NSString *)colorId category:(NSString *)category mainItemId:(NSString *)itemId
                          city:(NSString *)cityId editorChoice:(BOOL)isEdtorChoice unTrack:(BOOL)unTrack
                      delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取单个城市一周颜色

#pragma mark - 获取最近一段时间的颜色查询位置颜色等数据
- (NSString *)getLatestQueryOfSize:(NSString *)size delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取用户收藏搭配
- (NSString *)getFavorateSuitsByPage:(NSString *)pageId size:(NSString *)size delegate:(id)dele
                          onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 增加收藏搭配
- (NSString *)addFavorateSuitBySuitJsonStr:(NSString *)suitJsonStr city:(NSString *)cityId
                                  delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 删除收藏的搭配
- (NSString *)delFavorateSuitByCid:(NSString *)cid delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取用户收藏的单品列表
- (NSString *)getFavorateItemsByPage:(NSString *)pageId size:(NSString *)size delegate:(id)dele
                           onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 增加单品到收藏
- (NSString *)addFavorateItemById:(NSString *)itemId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 从收藏删除单品
- (NSString *)delFavorateItemById:(NSString *)itemId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取同类单品
- (NSString *)getSimilarItemsByItemId:(NSString *)itemId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;


#pragma mark - --- 杂项 ---

#pragma mark - 获取热点城市
- (NSString *)getHotCities:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

- (NSString *)getHotcities:(void(^)(BOOL))requestFinished;

#pragma mark - 获取城市的热点颜色
- (NSString *)getHotColorByCity:(NSString *)cityId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取颜色列表
- (NSString *)getColors:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取应用itunes链接
- (NSString *)getAppLink:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取城市列表
- (NSString *)getCities:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 启动服务
- (NSString *)appInit:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取推荐App
- (NSString *)getFriendApps:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

#pragma mark - 获取App Store上的版本号
- (NSString *)getAppVersionFromAppStore:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail;

@end
