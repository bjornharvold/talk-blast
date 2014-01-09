//
//  ServerStatusCheckEvent.h
//  TalkBlast
//
//  Created by crash on 8/1/10.
//  Copyright (c) 2010 Health XCEL, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkBlastEvent.h"

@interface ServerStatusCheckEvent : TalkBlastEvent {

}

+ (ServerStatusCheckEvent *) initWithCaller:(id)kaller
                            successSelector:(SEL) successSelector 
                              faultSelector:(SEL) faultSelector
						 params:(NSMutableDictionary *)paramz;

@end
