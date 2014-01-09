//
//  PastBlastsEvent.h
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkBlastEvent.h"

/*!
 @class Event for retrieving past conference calls
 */
@interface BlastsEvent : TalkBlastEvent {

}

+ (BlastsEvent *) initWithCaller:(id)kaller 
                 successSelector:(SEL *) successSelector 
                   faultSelector:(SEL *) faultFelector
						   params:(NSMutableDictionary *)paramz;

@end
