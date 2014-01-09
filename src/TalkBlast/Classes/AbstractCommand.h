//
//  AbstractCommand.h
//  TalkBlast
//
//  Created by crash on 8/8/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WrapperDelegate.h"

@class Wrapper;
@class TalkBlastAppDelegate;

@interface AbstractCommand : NSObject <WrapperDelegate> {
	id caller;
    SEL successSelector;
    SEL faultSelector;
	TalkBlastAppDelegate *applicationDelegate;
	Wrapper *engine;
}

@end
