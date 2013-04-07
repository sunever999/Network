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
#import "JSON.h"

#import "sys/utsname.h"

#define FORM_BOUNDARY @"JianShiSugarLadyBoUnDaRY"

static NetworkManager *sharedInstance = nil;

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

- (void)submitAsynchRequestWithRequest:(NSMutableURLRequest *)request Tag:(RequestTag)iTag httpMethod:(NSString *)method complete:(void(^)(BOOL))requestFinished
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

- (void)doGetRequestWithPath:(NSString *)path queryParameters:(NSMutableDictionary *)params requestTag:(RequestTag)iTag complete:(void(^)(BOOL))requestFinished
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

#pragma mark - 获取Token
- (NSString *)getTokenWithEmail:(NSString *)email
                       delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"requestTokens", @"cmd",
                                  email, @"email",
                                  nil];
    
    [self doAsynchRequestWithPath:@"login" queryParameters:param requestTag:Request_Token
                       httpMethod:HTTP_GET delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Token];
}

#pragma mark - 用户注册
- (NSString *)registerWithEmail:(NSString *)email nick:(NSString *)nick salt:(NSString *)salt
                             pwSalt:(NSString *)pwSalt year:(NSString *)y
                       delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"register", @"cmd",
                                  email, @"email",
                                  nick, @"nick",
                                  salt, @"salt",
                                  pwSalt, @"pw",
                                  y, @"y",
                                  @"1", @"pdelta",
                                  nil];

    [self doGetRequestWithPath:@"register" queryParameters:param requestTag:Request_User_Register
                            delegate:dele onSuccess:onSuccess onFail:onFail];

    return [NSString stringWithFormat:@"%d", Request_User_Register];
}

#pragma mark - 第三方用户转成sugar用户
- (NSString *)convertUserFromTpByType:(NSString *)type mail:(NSString *)email nick:(NSString *)nick salt:(NSString *)salt
                               pwSalt:(NSString *)pwSalt year:(NSString *)year
                             delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"upBasicFromTpQuiz", @"cmd",
                                  type, @"type",
                                  email, @"email",
                                  nick, @"nick",
                                  salt, @"salt",
                                  pwSalt, @"newPw",
                                  year, @"y",
                                  @"1", @"pdelta",
                                  nil];
    
    [self doGetRequestWithPath:@"profile" queryParameters:param requestTag:Request_User_Convert
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_User_Convert];    
}

#pragma mark - 第三方信息注册苏格用户
- (NSString *)registerWithTpState:(NSString *)state delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                  state, @"state", nil];
    
    [self doGetRequestWithPath:@"tpa" queryParameters:param requestTag:Request_TpUser_Register
                      delegate:dele onSuccess:onSuccess onFail:onFail];    
    
    return [NSString stringWithFormat:@"%d", Request_TpUser_Register];
}

#pragma mark - 用户登录
- (NSString *)loginWithEmail:(NSString *)email password:(NSString *)pwd
                    delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 获取个人信息
- (NSString *)getUserInfo:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 获取第三方信息
- (NSString *)getThirdInfoWithType:(NSString *)type delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 上传用户头像
- (NSString *)uploadUserAvatar:(UIImage *)avatar delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 刷新用户登录
- (NSString *)refreshUserLogin:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 用户反馈
- (NSString *)feedbackWithContent:(NSString *)content delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 按颜色查询(A，B，C三件单品，1，随机取，2，按用户选择类型取，3，A不变，更换B，C）
- (NSString *)getSuitByColorId:(NSString *)colorId category:(NSString *)category mainItemId:(NSString *)itemId
                          city:(NSString *)cityId editorChoice:(BOOL)isEditorChoice unTrack:(BOOL)unTrack
                      delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 获取单个城市一周颜色

#pragma mark - 获取最近一段时间的颜色查询位置颜色等数据
- (NSString *)getLatestQueryOfSize:(NSString *)size delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"getLatestColorQueries", @"cmd",
                                  size, @"size", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Latest_Query
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Latest_Query];    
}

#pragma mark - 获取用户收藏搭配
- (NSString *)getFavorateSuitsByPage:(NSString *)pageId size:(NSString *)size delegate:(id)dele
                          onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 增加收藏搭配
- (NSString *)addFavorateSuitBySuitJsonStr:(NSString *)suitJsonStr city:(NSString *)cityId
                                  delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 删除收藏的搭配
- (NSString *)delFavorateSuitByCid:(NSString *)cid delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 获取用户收藏的单品列表
- (NSString *)getFavorateItemsByPage:(NSString *)pageId size:(NSString *)size delegate:(id)dele
                           onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 增加单品到收藏
- (NSString *)addFavorateItemById:(NSString *)itemId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 从收藏删除单品
- (NSString *)delFavorateItemById:(NSString *)itemId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - 获取同类单品
- (NSString *)getSimilarItemsByItemId:(NSString *)itemId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    return nil;
}

#pragma mark - --- 杂项 ---

#pragma mark - 获取热点城市
- (NSString *)getHotCities:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getHotCities", @"cmd", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Hot_Cities
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Hot_Cities];    
}

- (NSString *)getHotcities:(void(^)(BOOL))requestFinished
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getHotCities", @"cmd", nil];

    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Hot_Cities complete:requestFinished];
    
    return [NSString stringWithFormat:@"%d", Request_Hot_Cities];
}

#pragma mark - 获取城市的热点颜色
- (NSString *)getHotColorByCity:(NSString *)cityId delegate:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getCityHotColors", @"cmd",
                                  cityId, @"city", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Hot_Color
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Hot_Color];
}

#pragma mark - 获取颜色列表
- (NSString *)getColors:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getColors", @"cmd", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Colors_List
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Colors_List];
}

#pragma mark - 获取应用itunes链接
- (NSString *)getAppLink:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getAppLink", @"cmd",
                                  @"ct", @"name", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_App_Link
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_App_Link];    
}

#pragma mark - 获取城市列表
- (NSString *)getCities:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getCities", @"cmd", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_Cities_List
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Cities_List];
}

#pragma mark - 启动服务
- (NSString *)appInit:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getDataState", @"cmd", nil];
    
    [self doGetRequestWithPath:@"appColorTrendUAMisc" queryParameters:param requestTag:Request_App_Init
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_App_Init];    
}

#pragma mark - 获取推荐App
- (NSString *)getFriendApps:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSMutableDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"getFriendApps", @"cmd", nil];
    
    [self doGetRequestWithPath:@"appUAMisc" queryParameters:param requestTag:Request_Friend_Apps
                      delegate:dele onSuccess:onSuccess onFail:onFail];
    
    return [NSString stringWithFormat:@"%d", Request_Friend_Apps];
}

#pragma mark - 获取App Store上的版本号
- (NSString *)getAppVersionFromAppStore:(id)dele onSuccess:(SEL)onSuccess onFail:(SEL)onFail
{
    NSURL *url = [NSURL URLWithString:App_Info_Url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [self submitAsynchRequestWithRequest:request Tag:Request_AppStore_Version httpMethod:HTTP_GET
                                delegate:dele onSuccess:onSuccess onFail:onFail];

    return [NSString stringWithFormat:@"%d", Request_AppStore_Version];
}


////////////////////////////////////////////////////////////////
#pragma mark - Singleton

+ (void) initialize {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
}

+ (id) sharedManager {
    //Already set by +initialize.
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone {
    //Usually already set by +initialize.
    if (sharedInstance) {
        return [sharedInstance retain];
    } else {
        return [super allocWithZone:zone];
    }
}

- (id) init {
    if (!sharedInstance) {
        if ((self = [super init])) {
            //Initialize the instance here.
//            NSLog(@"init NetworkManager.");
            self.httpClientDic = [NSMutableDictionary dictionary];
            _errorMsg = [[NSString alloc] init];
        }
        
        sharedInstance = self;
    } else if (self != sharedInstance) {
        [self release];
        self = sharedInstance;
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
