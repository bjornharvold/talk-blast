//
//  PastBlastsEvent.m
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "BlastsEvent.h"

@implementation BlastsEvent

+ (BlastsEvent *) initWithCaller:(id)kaller  
                 successSelector:(SEL *) successSelector 
                   faultSelector:(SEL *) faultSelector
						  params:(NSMutableDictionary *)paramz {
	BlastsEvent *result = [BlastsEvent alloc];
	result.params = paramz;
	result.caller = kaller;
    result.successSelector = successSelector;
    result.faultSelector = faultSelector;
	
	return result;
}

@end
