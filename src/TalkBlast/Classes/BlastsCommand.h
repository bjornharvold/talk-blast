//
//  LoginCommand.h
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
#import "WrapperDelegate.h"
#import "AbstractCommand.h"

/*!
 @class LoginCommand
 @abstract Handles the nuts and bolts of logging a user in to the TalkBlast server
 */
@interface BlastsCommand : AbstractCommand <Command, WrapperDelegate> {

}

@end
