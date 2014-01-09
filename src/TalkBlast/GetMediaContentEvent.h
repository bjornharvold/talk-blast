//
//  GetMediaContentEvent.h
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkBlastEvent.h"

@interface GetMediaContentEvent : TalkBlastEvent {
	
}

+ (GetMediaContentEvent *) initWithCaller:(id)kaller  
						  params:(NSMutableDictionary *)paramz;

@end
