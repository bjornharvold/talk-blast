//
//  MediaContentItem.h
//  TalkBlast
//
//  Created by crash on 8/22/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MediaContentItem : NSObject {
	NSString *source;
	NSString *href;
	NSString *name;
}

@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *href;
@property (nonatomic, retain) NSString *name;

@end
