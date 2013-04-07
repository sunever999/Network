//
//  NetworkConstans.h
//  songguo
//
//  Created by songguo on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef TuoLar5_NetworkConstans_h
#define TuoLar5_NetworkConstans_h

#define Network_Path        @"appCTUAMisc"
#define None_Path           @"appColorTrendUACollocation"
#define User_Path           @"appColorTrendACollocation"
#define HTTP_GET  @"GET"
#define HTTP_POST @"POST"

//#define Develop
#ifdef Develop
    #define Network_API_DOMAIN	@"192.168.1.103/api" //
    #define ImageServer     @"http://192.168.1.102:8090"
#else
    #define Network_API_DOMAIN  @"app.sugarlady.com/api"
    #define ImageServer     @"http://images.sugarlady.com"
#endif

// 苏格app的信息地址，用于获取app store版本号
#define App_Info_Url    @"http://itunes.apple.com/lookup?id=600775907"

// 以下枚举为各个交互的Tag，用以在交互结束数据解析的区分，根据具体项目交互进行设计
typedef enum 
{
    Request_Token = 0,               // 获取Token
    Request_User_Register,           // 用户注册
    Request_TpUser_Register,         // 第三方用户注册
    Request_User_Convert,            // 第三方用户转换
    Request_User_Login,              // 用户登录
    
    Request_Hot_Cities,              // 获取热门城市
    Request_Hot_Color,               // 获取城市的热门颜色
    Request_Colors_List,             // 获取颜色列表
    Request_App_Link,                // 获取App的App Store link
    Request_Cities_List,             // 获取城市列表
    
    Request_Generate_Collection,     // 获取颜色搭配
    Request_User_SuitList,           // 获取用户收藏搭配
    Request_Add_Suit,                // 增加收藏搭配
    Request_Delete_Suit,             // 删除用户收藏搭配
    
    Request_User_Feedback,           // 用户反馈
    
    Request_Latest_Query,            // 最近的颜色查询
    
    Request_Item_List,               // 获取收藏的单品列表
    Request_Item_Add,                // 增加单品到收藏
    Request_Item_Del,                // 从收藏删除单品
    
    Request_App_Init,                // 启动服务
    
    Request_Similar_Items,           // 获取同类商品
    
    Request_User_Info,               // 获取个人信息
    Request_Third_Info,              // 获取第三方信息
    
    Request_Upload_Avatar,           // 上传用户头像
    
    Request_Refresh_Login,           // 刷新用户login
    
    Request_Friend_Apps,             // 推荐app
    Request_AppStore_Version,        // 获取app store上的app版本号
}
RequestTag;

#pragma mark - Macro For Key (解析数据封装／读取)
#define kKeyForData @"data"

#endif
