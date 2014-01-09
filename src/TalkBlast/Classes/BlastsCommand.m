//
//  LoginCommand.m
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "BlastsCommand.h"
#import "TalkBlastAppDelegate.h"
#import "TalkBlastEvent.h"
#import "Command.h"
#import "CommunicationEventParser.h"
#import "Wrapper.h"
#import "Constants.h"
#import "BlastsEvent.h"
#import "CommunicationEvent.h"
#import "Attendee.h"
#import "Account.h"
#import "AccountUser.h"

@implementation BlastsCommand

# pragma mark Command
/*!
 @function execute
 @abstract Implements the Command protocol
 @discussion This command will try to retrieve past conference calls
 */
- (void) execute:(TalkBlastEvent *)event {
	if ([event class] == [BlastsEvent class]) {
		BlastsEvent *theEvent = (BlastsEvent *) event;
		
		// save the caller for later
		caller = theEvent.caller;
		NSString *accountUrlName = applicationDelegate.account.urlName;
		
		if (nil == applicationDelegate) {
			applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
		}
		
		// create the url. grab the root url from our stash
		NSString *urlS = [NSString stringWithFormat:@"%@/accounts/%@/communicationEvents", applicationDelegate.talkBlastUrl, accountUrlName];
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
	CommunicationEventParser *parser = [CommunicationEventParser alloc];
	NSArray *communicationEvents = [parser parse:data error:&error];
	
	// if there was an error parsing and the caller responds to the following command (coding standard: success = classNameResult, failure = classNameFault)
	if (nil == error && [caller respondsToSelector:@selector(blastsResult:)]) {
		[caller blastsResult:communicationEvents];
	} else if ([caller respondsToSelector:@selector(blastsFault:)]) {
		[caller blastsFault:error];
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
	if ([caller respondsToSelector:@selector(blastsFault:)]) {
		[caller blastsFault:error];
	}
}

- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url {
    [super wrapper:wrapper didCreateResourceAtURL:url];
}

- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error {
    [super wrapper:wrapper didFailWithError:error];
	
	if ([caller respondsToSelector:@selector(blastsFault:)]) {
		[caller blastsFault:error];
	}
}

- (void)wrapper:(Wrapper *)wrapper didReceiveStatusCode:(int)statusCode {
    [super wrapper:wrapper didReceiveStatusCode:statusCode];
}

- (NSArray *) initWithTestData {
	NSMutableArray *data = [NSMutableArray array];
	
	int counter = 0;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	// loop through X amount of times to create call history
	while (counter < 3) {
		CommunicationEvent *cc = [CommunicationEvent alloc];
		// we are usig this id for all our unique identifiers
		NSString *theId = [NSString stringWithFormat:@"%d", counter];
		
		cc.title = [NSString stringWithFormat:@"Meeting: %@", theId];
		cc.scheduledDate = [NSDate date];
		cc.conferenceCallId = theId;
		
		// if no recordings have been made, this won't work
		// cc.filenameIndex = [NSNumber numberWithInt:0];
		
		// add a bunch of attendees to our make believe conference call
		NSMutableDictionary *attendees = [NSMutableDictionary dictionaryWithCapacity:1];
		
		for (int j = 0; j < 5; j++) {
			NSString *attendeeId = [NSString stringWithFormat:@"%d", (j + 50)];
			Attendee *attendee = [Attendee alloc];
			attendee.personId = attendeeId;
			attendee.phoneNumber = [NSString stringWithFormat:@"(%d17) 494-635%d", counter, j];
			attendee.phoneLabel = @"Mobile";	
			attendee.personName = [NSString stringWithFormat:@"Bjorn Harvold %d", j];
			
			NSMutableArray *availablePhoneNumbers = [NSMutableArray arrayWithCapacity:5];
			NSMutableArray *availablePhoneLabels = [NSMutableArray arrayWithCapacity:5];	
			
			for (int i = 0; i < 5; i++) {
				NSString *availableNumber = [NSString stringWithFormat:@"(%d12) 555-121%d", j, i];
				NSString *availableLabel = @"Mobile";	
				[availablePhoneNumbers addObject:availableNumber];
				[availablePhoneLabels addObject:availableLabel];
			}
			attendee.availablePhoneNumbers = availablePhoneNumbers;
			attendee.availablePhoneLabels = availablePhoneLabels;
			
			[attendees setObject:attendee forKey:attendeeId];
		}
		
		cc.attendees = attendees;
		
		// add call history to array
		[data addObject:cc];
		
		counter++;
	}
	
	// put test data in array that is accessible to the view
	return [NSArray arrayWithArray:data];
}

- (void) dealloc {
	[engine release];
	[applicationDelegate release];
	[caller release];
	[super dealloc];
}

@end
