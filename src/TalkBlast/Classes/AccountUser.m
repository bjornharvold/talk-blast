//
//  AccountUser.m
//  TalkBlast
//
//  Created by crash on 7/20/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "AccountUser.h"


@implementation AccountUser

@synthesize firstName;
@synthesize lastName;
@synthesize active;
@synthesize username;
@synthesize email;
@synthesize password;
@synthesize urlName;

# pragma mark NSCoder
/*!
 @function encodeWithCoder
 @abstract Persist object to disk
 */
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:firstName forKey:@"firstName"];
	[coder encodeObject:lastName forKey:@"lastName"];
	[coder encodeObject:active forKey:@"active"];
	[coder encodeObject:username forKey:@"username"];
	[coder encodeObject:email forKey:@"email"];
	[coder encodeObject:password forKey:@"password"];
	[coder encodeObject:urlName forKey:@"urlName"];
}

/*!
 @function initWithCoder
 @abstract Retrieves object from disk
 */
- (id) initWithCoder:(NSCoder *)coder {	
    firstName = [[coder decodeObjectForKey:@"firstName"] retain];
    lastName = [[coder decodeObjectForKey:@"lastName"] retain];
    active = [[coder decodeObjectForKey:@"active"] retain];
    username = [[coder decodeObjectForKey:@"username"] retain];
    email = [[coder decodeObjectForKey:@"email"] retain];
	password = [[coder decodeObjectForKey:@"password"] retain];
	urlName = [[coder decodeObjectForKey:@"urlName"] retain];
	
    return self;
}

- (void) dealloc {
	[firstName release];
	[lastName release];
	[active release];
	[username release];
	[email release];
	[password release];
	[urlName release];
	
	[super dealloc];
}
@end
