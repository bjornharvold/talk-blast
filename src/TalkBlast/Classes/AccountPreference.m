//
//  AccountPreference.m
//  TalkBlast
//
//  Created by crash on 8/1/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "AccountPreference.h"

@implementation AccountPreference
@synthesize defaultTimeZone, originatingTelephone, originatingEmailAddress;

+ (AccountPreference *) initWithTimezone:(NSString *)timezone 
								   email:(NSString *)email 
							   telephone:(NSString *)telephone {
	AccountPreference *result = [AccountPreference alloc];
	
	result.defaultTimeZone = timezone;
	result.originatingTelephone = telephone;
	result.originatingEmailAddress = email;
	
	
	return result;
}

# pragma mark NSCoder
/*!
 @function encodeWithCoder
 @abstract Persist object to disk
 */
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:defaultTimeZone forKey:@"defaultTimeZone"];
	[coder encodeObject:originatingTelephone forKey:@"originatingTelephone"];
	[coder encodeObject:originatingEmailAddress forKey:@"originatingEmailAddress"];
}

/*!
 @function initWithCoder
 @abstract Retrieves object from disk
 */
- (id) initWithCoder:(NSCoder *)coder {	
    defaultTimeZone = [[coder decodeObjectForKey:@"defaultTimeZone"] retain];
    originatingTelephone = [[coder decodeObjectForKey:@"originatingTelephone"] retain];
    originatingEmailAddress = [[coder decodeObjectForKey:@"originatingEmailAddress"] retain];
	
    return self;
}

- (void) dealloc {
	[self.defaultTimeZone release];
	[self.originatingTelephone release];
	[self.originatingEmailAddress release];
	
	[super dealloc];
}

@end
