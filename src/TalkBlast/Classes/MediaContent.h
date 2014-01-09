//
//  MediaContent.h
//  TalkBlast
//
//  Created by crash on 8/12/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MediaContentItem;

@interface MediaContent : NSObject {
	NSMutableArray *items;
}

@property (nonatomic, retain) NSMutableArray *items;

- (void) addItem:(MediaContentItem *)item;

@end
