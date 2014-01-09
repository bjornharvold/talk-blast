//
//  JSONKit.m
//  iConferenceCall
//
//  Created by crash on 6/3/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "JSONKit.h"
#import "JSON.h"

@implementation JSONKit

/**
 * This method will take a url, grab the response and parse the JSON data and return either a NSArray or NSDictionary 
 **/
- (id) parseString:(NSString *)response {
	SBJSON *jsonParser = [SBJSON new];
	
	// Parse the JSON into an Object
	NSError *error = nil;
	id result = [jsonParser objectWithString:response error:&error];
	
	[jsonParser release];
	
	return result;
}

@end
