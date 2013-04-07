//
//  NSString+URLEncoding.h
//  BlogSDK4Sina
//
//  Created by 随意 on 12-1-12.
//  Copyright (c) 2012年 随意. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Additions)

-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;
-(NSString*)encodeAsURIComponent;
@end
