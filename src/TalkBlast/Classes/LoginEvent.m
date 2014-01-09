//
//  LoginEvent.m
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "LoginEvent.h"

@implementation LoginEvent

+ (LoginEvent *) initWithCaller:(id)kaller 
							 params:(NSMutableDictionary *)paramz {
	LoginEvent *result = [LoginEvent alloc];
	result.params = paramz;
	result.caller = kaller;
	
	return result;
}

@end
