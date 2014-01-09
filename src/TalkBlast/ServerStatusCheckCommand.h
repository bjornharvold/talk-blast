//
//  ServerStatusCheckCommand.h
//  TalkBlast
//
//  Created by crash on 8/1/10.
//  Copyright (c) 2010 Health XCEL, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
#import "WrapperDelegate.h"
#import "AbstractCommand.h"

@interface ServerStatusCheckCommand : AbstractCommand <Command, WrapperDelegate> {

}

@end
