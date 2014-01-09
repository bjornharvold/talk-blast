//
//  InitiateBlastEvent.m
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "InitiateBlastEvent.h"


@implementation InitiateBlastEvent

+ (InitiateBlastEvent *) initWithCaller:(id)kaller 
								   params:(NSMutableDictionary *)paramz {
	
	InitiateBlastEvent *result = [InitiateBlastEvent alloc];
	result.params = paramz;
	result.caller = kaller;
	
	return result;
}

@end
