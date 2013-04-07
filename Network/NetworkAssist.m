//
//  NetworkAssist.m
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkAssist.h"
#import "NetworkConstans.h"
#import "NSString+Additions.h"

@implementation NetworkAssist

+ (NSURL *)getURL:(NSString *)path queryParameters:(NSMutableDictionary*)params {
    
	NSString* fullPath = [NSString stringWithFormat:@"%@://%@/%@", @"http", Network_API_DOMAIN, path];
    
	NSMutableString *str=[NSMutableString stringWithCapacity:0];
	[str appendString:fullPath];
	if (params) {
		NSArray *names = [params allKeys];
		for (int i=0; i<[names count]; i++) {
			if (i==0) {
				[str appendString:@"?"];
			}else if (i>0) {
				[str appendString:@"&"];
			}
			NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", name, [[params objectForKey:name]URLEncodedString]]];
		}
	}

	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]];
    
//	NSLog(@"url:%@",finalURL);
	return finalURL;
}

@end
