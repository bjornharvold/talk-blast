//
//  InitiateConferenceCallCommand.h
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractCommand.h"
#import "Command.h"
#import "WrapperDelegate.h"

@interface InitiateBlastCommand : AbstractCommand <Command, WrapperDelegate> {

}

@end
