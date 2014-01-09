//
//  FrontController.m
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "FrontController.h"
#import "LoginCommand.h"
#import "LoginEvent.h"
#import "BlastsEvent.h"
#import "BlastsCommand.h"
#import "CreateAccountCommand.h"
#import "CreateAccountEvent.h"
#import "UpdateAccountCommand.h"
#import "UpdateAccountEvent.h"
#import "GetMediaContentEvent.h"
#import "GetMediaContentCommand.h"
#import "InitiateBlastEvent.h"
#import "InitiateBlastCommand.h"
#import "ServerStatusCheckCommand.h"
#import "ServerStatusCheckEvent.h"

@implementation FrontController
NSDictionary *commandMap;

/*!
 @function init
 @abstract instantiates the command map that contains a list of events and their corresponding commands
 */
- (void) initMap {
	commandMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                  [ServerStatusCheckCommand class], [NSString stringWithFormat:@"%@", [ServerStatusCheckEvent class]],
				  [BlastsCommand class], [NSString stringWithFormat:@"%@", [BlastsEvent class]],
				  [CreateAccountCommand class], [NSString stringWithFormat:@"%@", [CreateAccountEvent class]],
				  [GetMediaContentCommand class], [NSString stringWithFormat:@"%@", [GetMediaContentEvent class]],
				  [InitiateBlastCommand class], [NSString stringWithFormat:@"%@", [InitiateBlastEvent class]],
				  [LoginCommand class], [NSString stringWithFormat:@"%@", [LoginEvent class]],
				  [UpdateAccountCommand class], [NSString stringWithFormat:@"%@", [UpdateAccountEvent class]],
				  nil];
	
}

/*!
 @function executeEvent
 @abstract Instantiates and executes a command object from the command map
 */
- (void) dispatchEvent:(TalkBlastEvent *)event {
	NSString *clazz = [NSString stringWithFormat:@"%@", [event class]];
	
	if (nil != commandMap) {
		Class commandClass = [commandMap valueForKey:clazz];
		
		if (nil != commandClass) {
			NSLog(@"Executing event with key: %@, class: %@", clazz, commandClass);
			
			id command = [[commandClass alloc] init];
			
			if ([command respondsToSelector:@selector(execute:)]) {
				[command execute:event];
			}
		} else {
			NSLog(@"Could not retrieve command object based on class: %@.", [event class]);
		}
	}
}

- (void) dealloc {
	[commandMap release];
	[super dealloc];
}
@end
