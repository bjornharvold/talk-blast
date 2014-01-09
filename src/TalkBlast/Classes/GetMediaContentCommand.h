//
//  GetMediaContentCommand.h
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
#import "WrapperDelegate.h"
#import "AbstractCommand.h"

@interface GetMediaContentCommand : AbstractCommand <Command, WrapperDelegate> {

}

@end
