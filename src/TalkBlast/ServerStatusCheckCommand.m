//
//  ServerStatusCheckCommand.m
//  TalkBlast
//
//  Created by crash on 8/1/10.
//  Copyright (c) 2010 Health XCEL, Inc. All rights reserved.
//

#import "ServerStatusCheckCommand.h"
#import "TalkBlastAppDelegate.h"
#import "ServerStatusCheckEvent.h"
#import "Command.h"
#import "AccountParser.h"
#import "Wrapper.h"
#import "Constants.h"

@implementation ServerStatusCheckCommand

# pragma mark Command
/*!
 @function execute
 @abstract Implements the Command protocol
 @discussion This command will try to log in the user with her username and password
 */
- (void) execute:(TalkBlastEvent *)event {
	NSLog(@"In %@ with %@ as argument", [self class], [event class]);
	
	if ([event class] == [ServerStatusCheckEvent class]) {
        ServerStatusCheckEvent *theEvent = (ServerStatusCheckEvent *) event;
		// save the caller for later
		caller = theEvent.caller;
        successSelector = theEvent.successSelector;
        faultSelector = theEvent.faultSelector;
		
		if (nil == applicationDelegate) {
			applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
		}
		
		// create the url. grab the root url from our stash
		NSString *urlS = [NSString stringWithFormat:@"%@/status", applicationDelegate.talkBlastUrl];
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
		[engine sendRequestTo:url usingVerb:HTTP_GET withParameters:event.params withBody:nil];    
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
 The data should be a string object with the value 'true' or 'false'. If 
 parsing failed we instead get a populated error object that we send back to the caller
 */
- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data {
    NSString* serverStatus = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    BOOL result = [serverStatus isEqualToString:@"true"];
	
	// if there was an error parsing and the caller responds to the following command (coding standard: success = classNameResult, failure = classNameFault)
	if (result && [caller respondsToSelector:successSelector]) {
		[caller successSelector:result];
	} else if (!result && [caller respondsToSelector:faultSelector]) {
		[caller faultSelector:result];
	}
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) dealloc {
	[engine release];
	[applicationDelegate release];
	[caller release];
	[super dealloc];
}

@end
