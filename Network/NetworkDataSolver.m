//
//  NetworkDataSolver.m
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkDataSolver.h"
#import "JSON.h"
#import "NetworkManager.h"


@implementation NetworkDataSolver

@synthesize delegate;


- (BOOL)isResponseStringValid:(NSString *)string
{
    if ([string rangeOfString:@"errStr"].location != NSNotFound &&
        [string rangeOfString:@"err"].location != NSNotFound) {
        NSDictionary *dic = [string JSONValue];
//        NSLog(@"errStr:[%@] err:[%@]", [dic objectForKey:@"errStr"], [dic objectForKey:@"err"]);
        
        [[NetworkManager sharedManager] parseErrorMsg:dic];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 获取Token
- (void)parseToken:(NSData *)data
{
}

#pragma mark - 用户登录
- (void)parseLogin:(NSData *)data
{
}

#pragma mark - 用户注册
- (void)parseRegister:(NSData *)data
{
}

#pragma mark - 第三方信息注册苏格用户
- (void)parseTpUserRegister:(NSData *)data
{
}


#pragma mark - 第三方用户转换
- (void)parseConvertUser:(NSData *)data
{
}

#pragma mark - 获取个人信息
- (void)parseUserInfo:(NSData *)data
{
}

#pragma mark - 获取第三方信息
- (void)parseThirdInfo:(NSData *)data
{
}

#pragma mark - 刷新用户登录
- (void)parseRefreshLogin:(NSData *)data
{
}

#pragma mark - 上传用户头像
- (void)parseUploadUserAvatar:(NSData *)data
{
}


#pragma mark - 获取用户收藏搭配
- (void)parseUserFavoSuits:(NSData *)data
{
}

#pragma mark - 增加收藏搭配
- (void)parseAddFavoSuit:(NSData *)data
{
}

#pragma mark - 删除用户收藏的搭配
- (void)parseDelFavoSuit:(NSData *)data
{
}

#pragma mark - 获取用户收藏单品
- (void)parseUserFavoItems:(NSData *)data
{
}

#pragma mark - 增加单品到收藏
- (void)parseAddFavoItem:(NSData *)data
{
}

#pragma mark - 从收藏删除单品
- (void)parseDelFavoItem:(NSData *)data
{
}

#pragma mark - 获取最近一段时间的颜色查询位置颜色等数据
- (void)parseLatestQuery:(NSData *)data
{
}



#pragma mark - 获取热门城市列表
- (void)parseHotCities:(NSData *)data
{
    NSError *jsonParsingError = nil;
    NSArray *hotCities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    NSLog(@"data:[%@]", hotCities);
    
    if (hotCities) {
        if (requestComplete) {
            requestComplete(YES);
        }
    }
}



#pragma mark - 获取城市的热点颜色
- (void)parseHotColorOfCity:(NSData *)data
{
}

#pragma mark - 获取颜色列表
- (void)parseColorsList:(NSData *)data
{
}

#pragma mark - 获取应用itunes链接
- (void)parseAppLink:(NSData *)data
{
}

#pragma mark - 获取城市列表
- (void)parseCitiesList:(NSData *)data
{
}

#pragma mark - 按颜色查询(A，B，C三件单品，1，随机取，2，按用户选择类型取，3，A不变，更换B，C）
- (void)parseColorSuits:(NSData *)data
{
}

#pragma mark - 用户反馈
- (void)parseFeedback:(NSData *)data
{
}

#pragma mark - 启动服务
- (void)parseAppInit:(NSData *)data
{
}

#pragma mark - 获取推荐app
- (void)parseFriendApps:(NSData *)data
{
}

#pragma mark - 获取同类单品
- (void)parseSimilarItems:(NSData *)data
{
}

#pragma mark - 获取app store上的苏格app版本号
- (void)parseAppStoreVersion:(NSData *)data
{
}


#pragma mark - New Interface Method for dongge

- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag complete:(void(^)(BOOL))requestFinished
{
    requestComplete = requestFinished;

    switch (iTag) {
        case Request_Hot_Cities:
            [self parseHotCities:data];
            break;

        case Request_Token:
            [self parseToken:data];
            break;
        case Request_User_Login:
            [self parseLogin:data];
            break;
        case Request_User_Register:
            [self parseRegister:data];
            break;
        case Request_TpUser_Register:
            [self parseTpUserRegister:data];
            break;
        default:
            break;
    }
}

- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
    self.delegate = aDelegate;
    onSuccess = aSuccess;
    onFail = aFail;
    
    switch (iTag) {
        case Request_Token:
            [self parseToken:data];
            break;
        case Request_User_Login:
            [self parseLogin:data];
            break;
        case Request_User_Register:
            [self parseRegister:data];
            break;
        case Request_TpUser_Register:
            [self parseTpUserRegister:data];
            break;
        case Request_User_Convert:
            [self parseConvertUser:data];
            break;
        case Request_Hot_Cities:
            [self parseHotCities:data];
            break;
        case Request_Hot_Color:
            [self parseHotColorOfCity:data];
            break;
        case Request_Colors_List:
            [self parseColorsList:data];
            break;
        case Request_App_Link:
            [self parseAppLink:data];
            break;
        case Request_Cities_List:
            [self parseCitiesList:data];
            break;
        case Request_Generate_Collection:
            [self parseColorSuits:data];
            break;
        case Request_User_SuitList:
            [self parseUserFavoSuits:data];
            break;
        case Request_Add_Suit:
            [self parseAddFavoSuit:data];
            break;
        case Request_Delete_Suit:
            [self parseDelFavoSuit:data];
            break;
        case Request_User_Feedback:
            [self parseFeedback:data];
            break;
        case Request_Latest_Query:
            [self parseLatestQuery:data];
            break;
        case Request_Item_List:
            [self parseUserFavoItems:data];
            break;
        case Request_Item_Add:
            [self parseAddFavoItem:data];
            break;
        case Request_Item_Del:
            [self parseDelFavoItem:data];
            break;
        case Request_App_Init:
            [self parseAppInit:data];
            break;
        case Request_Similar_Items:
            [self parseSimilarItems:data];
            break;
        case Request_User_Info:
            [self parseUserInfo:data];
            break;
        case Request_Third_Info:
            [self parseThirdInfo:data];
            break;
        case Request_Refresh_Login:
            [self parseRefreshLogin:data];
            break;
        case Request_Friend_Apps:
            [self parseFriendApps:data];
            break;
        case Request_AppStore_Version:
            [self parseAppStoreVersion:data];
            break;
        default:
            break;
    }    
}


#pragma mark - Class lifecycle

- (void)dealloc
{
//    NSLog(@"NetworkDataSolver dealloc");    
    [super dealloc];
}

@end
