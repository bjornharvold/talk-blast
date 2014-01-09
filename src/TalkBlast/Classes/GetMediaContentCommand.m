//
//  GetMediaContentCommand.m
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "GetMediaContentCommand.h"
#import "GetMediaContentEvent.h"
#import "TalkBlastAppDelegate.h"
#import "Wrapper.h"
#import "AccountUser.h"
#import "Account.h"
#import "Constants.h"
#import "MediaContentParser.h"
#import "MediaContent.h"

@implementation GetMediaContentCommand

#pragma mark Command delegate
/*!
 @function execute
 @abstract Implements the Command protocol
 @discussion This command will try to retrieve a list of existing media content (aka recordings aka introductory greetings)
 */
- (void) execute:(TalkBlastEvent *)event {
	if ([event class] == [GetMediaContentEvent class]) {
		GetMediaContentEvent *theEvent = (GetMediaContentEvent *) event;
		
		// save the caller for later
		caller = theEvent.caller;
		NSString *accountUrlName = applicationDelegate.account.urlName;
		
		if (nil == applicationDelegate) {
			applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
		}
		
		// create the url. grab the root url from our stash
		NSString *urlS = [NSString stringWithFormat:@"%@/accounts/%@/mediaContent", applicationDelegate.talkBlastUrl, accountUrlName];
		NSURL *url = [NSURL URLWithString:urlS];
		
		// turn on activity indicator
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		// initialize the http REST engine aka wrapper
		if (engine == nil) {
			engine = [[Wrapper alloc] init];
			engine.delegate = self;
			engine.username = applicationDelegate.account.accountUser.username;
			engine.password = applicationDelegate.account.accountUser.password;
		}
		
		// send request
		[engine sendRequestTo:url usingVerb:HTTP_GET withParameters:event.params withBody:nil];    
	} else {
		NSLog(@"Could not execute %@. Invalid event: %@. Expected PastBlastsEvent", [self class], [event class]);
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
 The data should be an CommunicationEvents object in XML form so we parse the data and retrieve a CommunicationEvent object. If 
 parsing failed we instead get a populated error object that we send back to the caller
 */
- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data {
	NSError *error = nil;
	MediaContentParser *parser = [MediaContentParser alloc];
	MediaContent *mediaContent = [parser parse:data error:&error];
	
	// if there was an error parsing and the caller responds to the following command (coding standard: success = classNameResult, failure = classNameFault)
	if (nil == error && [caller respondsToSelector:@selector(getMediaContentResult:)]) {
		[caller getMediaContentResult:mediaContent];
	} else if ([caller respondsToSelector:@selector(getMediaContentFault:)]) {
		[caller getMediaContentFault:error];
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
	if ([caller respondsToSelector:@selector(getMediaContentFault:)]) {
		[caller getMediaContentFault:error];
	}
}

- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url {
    [super wrapper:wrapper didCreateResourceAtURL:url];
}

- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error {
    [super wrapper:wrapper didFailWithError:error];
	
	if ([caller respondsToSelector:@selector(getMediaContentFault:)]) {
		[caller getMediaContentFault:error];
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
