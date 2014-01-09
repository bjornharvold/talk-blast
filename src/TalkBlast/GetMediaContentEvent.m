//
//  GetMediaContentEvent.m
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "GetMediaContentEvent.h"


@implementation GetMediaContentEvent

+ (GetMediaContentEvent *) initWithCaller:(id)kaller 
								   params:(NSMutableDictionary *)paramz {

	GetMediaContentEvent *result = [GetMediaContentEvent alloc];
	result.params = paramz;
	result.caller = kaller;
	
	return result;
}

@end
