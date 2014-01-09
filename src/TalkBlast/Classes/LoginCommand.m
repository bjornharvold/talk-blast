//
//  LoginCommand.m
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "LoginCommand.h"
#import "TalkBlastAppDelegate.h"
#import "LoginEvent.h"
#import "Command.h"
#import "AccountParser.h"
#import "Wrapper.h"
#import "Constants.h"

@implementation LoginCommand

# pragma mark Command
/*!
 @function execute
 @abstract Implements the Command protocol
 @discussion This command will try to log in the user with her username and password
 */
- (void) execute:(TalkBlastEvent *)event {
	NSLog(@"In %@ with %@ as argument", [self class], [event class]);
	
	if ([event class] == [LoginEvent class]) {
		// save the caller for later
		caller = event.caller;
		
		if (nil == applicationDelegate) {
			applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
		}
		
		// create the url. grab the root url from our stash
		NSString *urlS = [NSString stringWithFormat:@"%@/login", applicationDelegate.talkBlastUrl];
		NSURL *url = [NSURL URLWithString:urlS];
		
		// turn on activity indicator
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		// initialize the http REST engine aka wrapper
		if (engine == nil)
		{
			engine = [[Wrapper alloc] init];
			engine.delegate = self;
		}
		
		// send request
		[engine sendRequestTo:url usingVerb:HTTP_POST withParameters:event.params withBody:nil];    
	} else {
		NSLog(@"Could not execute %@. Invalid event: %@. Expected LoginEvent", [self class], [event class]);
	}

	// don't need the event any longer
	[event release];
}

#pragma mark -
#pragma mark WrapperDelegate methods

/*!
 @function didRetrieveData
 @abstract Is called if call was successful
 @discussion If the call was successful, we will receive the contents of the response as an NSData object.
 The data should be an Account object in XML form so we parse the data and retrieve an account object. If 
 parsing failed we instead get a populated error object that we send back to the caller
 */
- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data {
	NSError *error = nil;
	AccountParser *parser = [AccountParser alloc];
	Account *account = [parser parse:data error:&error];
	
	// if there was an error parsing and the caller responds to the following command (coding standard: success = classNameResult, failure = classNameFault)
	if (nil == error && [caller respondsToSelector:@selector(loginResult:)]) {
		[caller loginResult:account];
	} else if ([caller respondsToSelector:@selector(loginFault:)]) {
		[caller loginFault:error];
	}
	
	[parser release];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)wrapperHasBadCredentials:(Wrapper *)wrapper {
	// parent class can handle default behavior
    [super wrapperHasBadCredentials:wrapper];
	
	// create new error message to let caller know why his call failed
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:NSLocalizedString(@"error.authentication", @"Authentication error") forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:UNAUTHORIZED userInfo:errorDetail];
	
	// let caller know about the error only if he has a method called loginCommandFault
	if ([caller respondsToSelector:@selector(loginFault:)]) {
		[caller loginFault:error];
	}
}

- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url {
    [super wrapper:wrapper didCreateResourceAtURL:url];
}

- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error {
    [super wrapper:wrapper didFailWithError:error];
	
	if ([caller respondsToSelector:@selector(loginFault:)]) {
		[caller loginFault:error];
	}
}

- (void)wrapper:(Wrapper *)wrapper didReceiveStatusCode:(int)statusCode {
    [super wrapper:wrapper didReceiveStatusCode:statusCode];
}

- (void) dealloc {
	[engine release];
	[applicationDelegate release];
	[caller release];
	[super dealloc];
}

@end
