//
//  ServerStatusCheckEvent.m
//  TalkBlast
//
//  Created by crash on 8/1/10.
//  Copyright (c) 2010 Health XCEL, Inc. All rights reserved.
//

#import "ServerStatusCheckEvent.h"


@implementation ServerStatusCheckEvent

+ (ServerStatusCheckEvent *) initWithCaller:(id)kaller 
                            successSelector:(SEL) successSelector 
                              faultSelector:(SEL) faultSelector
                         params:(NSMutableDictionary *)paramz {
	ServerStatusCheckEvent *result = [ServerStatusCheckEvent alloc];
	result.params = paramz;
	result.caller = kaller;
    result.successSelector = successSelector;
    result.faultSelector = faultSelector;
	
	return result;
}

@end
