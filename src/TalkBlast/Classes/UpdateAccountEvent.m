//
//  CreateAccountCommandEvent.m
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "UpdateAccountEvent.h"

@implementation UpdateAccountEvent

+ (UpdateAccountEvent *) initWithCaller:(id)kaller 
						 params:(NSMutableDictionary *)paramz {
	UpdateAccountEvent *result = [UpdateAccountEvent alloc];
	result.params = paramz;
	result.caller = kaller;
	
	return result;
}

@end
