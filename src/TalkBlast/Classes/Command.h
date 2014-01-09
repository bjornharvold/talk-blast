//
//  Command.h
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkBlastEvent.h"

/*!
 @class Command
 @abstract Command delegation
 @discussion Command pattern is a way to handle multiple actions using the same methods. The added functionality to stay as event-driven as possible
 without callers implementing to many protocols will be how callers get data back data. The way command objects handle it is to send a message back
 to the caller with the message name being the name of the command appended with either 'result' or 'fault'. E.g. loginCommandResult or loginCommandFault.
 That way the caller can support multiple commands without implementing a bunch of protocols.
 */
@protocol Command

- (void) execute:(TalkBlastEvent *)event;

@end

