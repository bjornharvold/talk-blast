//
//  CreateAccountCommandEvent.m
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "CreateAccountEvent.h"

@implementation CreateAccountEvent

+ (CreateAccountEvent *) initWithCaller:(id)kaller 
						 params:(NSMutableDictionary *)paramz {
	CreateAccountEvent *result = [CreateAccountEvent alloc];
	result.params = paramz;
	result.caller = kaller;
	
	return result;
}

@end
