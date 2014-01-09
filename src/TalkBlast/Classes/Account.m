//
//  Account.m
//  TalkBlast
//
//  Created by crash on 8/1/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "Account.h"
#import "AccountUser.h"
#import "AccountPreference.h"

@implementation Account
@synthesize active, name, urlName, accountUser, accountPreference;

+ (Account *) init {
	Account *result = [Account alloc];
	AccountUser *user = [AccountUser alloc];
	AccountPreference *preference = [AccountPreference alloc];
	
	result.accountUser = user;
	result.accountPreference = preference;
	
	return result;
}

# pragma mark NSCoder
/*!
 @function encodeWithCoder
 @abstract Persist object to disk
 */
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:name forKey:@"name"];
	[coder encodeObject:urlName forKey:@"urlName"];
	[coder encodeObject:active forKey:@"active"];
	[coder encodeObject:accountUser forKey:@"accountUser"];
	[coder encodeObject:accountPreference forKey:@"accountPreference"];
}

- (id) initWithCoder:(NSCoder *)coder {	
    name = [[coder decodeObjectForKey:@"name"] retain];
    urlName = [[coder decodeObjectForKey:@"urlName"] retain];
    active = [[coder decodeObjectForKey:@"active"] retain];
    accountUser = [[coder decodeObjectForKey:@"accountUser"] retain];
    accountPreference = [[coder decodeObjectForKey:@"accountPreference"] retain];
	
    return self;
}

- (void) dealloc {
	[self.active release];
	[self.name release];
	[self.urlName release];
	[self.accountUser release];
	[self.accountPreference release];
	
	[super dealloc];
}

@end
