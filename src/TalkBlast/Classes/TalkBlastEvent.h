//
//  TalkBlastEvent.h
//  TalkBlast
//
//  Created by crash on 8/4/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TalkBlastAppDelegate;

@interface TalkBlastEvent : NSObject {
	id caller;
    SEL successSelector;
    SEL faultSelector;
	NSMutableDictionary *params;
	NSString *accountUrlName;
}

@property (nonatomic, retain) NSString *accountUrlName;
@property (nonatomic, retain) id caller;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic) SEL successSelector;
@property (nonatomic) SEL faultSelector;

@end
