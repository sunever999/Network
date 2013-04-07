//
//  NSString+Additions.m
//  BlogSDK4Sina
//
//  Created by 随意 on 12-1-12.
//  Copyright (c) 2012年 随意. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions)

-(NSString *)URLEncodedString
{
	NSString *result=(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																		 (CFStringRef)self,
																		 NULL,
																		 CFSTR("!*'();:@&=+$,/?%#[]"),
																		 kCFStringEncodingUTF8);
	[result autorelease];
	return result;
}

-(NSString *)URLDecodedString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;	
	
}

-(NSString*)encodeAsURIComponent
{
	const char *p=[self UTF8String];
	NSMutableString *result=[NSMutableString string];
	for (; *p!=0; p++) {
		unsigned char c=*p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_')
		{
			[result appendFormat:@"%c",c];
		}else {
			[result appendFormat:@"%%%02X",c];
		}

	}
	return result;
}

@end
