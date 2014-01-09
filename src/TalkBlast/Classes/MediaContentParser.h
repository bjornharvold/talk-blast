//
//  MediaContentParser.h
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MediaContentItem;
@class MediaContent;
@class DDXMLElement;

@interface MediaContentParser : NSObject {
	NSDateFormatter *xmlDateFormatter;
}

- (MediaContent *) parse:(NSData *)xml 
				   error:(NSError **)error;
- (MediaContent *) parseMediaContent:(DDXMLElement *)element;
- (MediaContentItem *) parseMediaContentItem:(DDXMLElement *)element;

@end
