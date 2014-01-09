//
//  FrontController.h
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TalkBlastEvent;

extern NSString * const LOGIN;

/*!
 @class FrontController
 @abstract Command class manager
 @discussion This class replicates the Cairngorm framework's FrontController functionality of managing events and
 their corresponding actions.
 */
@interface FrontController : NSObject {
	
}

- (void) initMap;
- (void) dispatchEvent:(TalkBlastEvent *)event; 

@end
