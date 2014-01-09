//
//  LoginEvent.h
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkBlastEvent.h"

@interface LoginEvent : TalkBlastEvent {

}

+ (LoginEvent *) initWithCaller:(id)kaller 
						 params:(NSMutableDictionary *)paramz;

@end
