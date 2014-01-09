//
//  NSString.m
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SHA1)

- (NSString *) SHA1ForString:(NSString *)string {
	unsigned char hashedChars[32];
	CC_SHA256([string UTF8String],
			  [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
			  hashedChars);
	NSData *hashedData = [NSData dataWithBytes:hashedChars length:32];
	
	return [[NSString alloc] initWithData:hashedData encoding:NSUTF8StringEncoding];
}

@end
