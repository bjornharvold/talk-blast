//
//  AccountPreference.h
//  TalkBlast
//
//  Created by crash on 8/1/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountPreference : NSObject <NSCoding> {
	NSString *defaultTimeZone;
	NSString *originatingEmailAddress;
	NSString *originatingTelephone;
}

@property (nonatomic, retain) NSString *defaultTimeZone;
@property (nonatomic, retain) NSString *originatingEmailAddress;
@property (nonatomic, retain) NSString *originatingTelephone;

/*!
 @function initWithTimezone:email:telephone
 @abstract convenience method for populating an AccountPreference object
 */
+ (AccountPreference *) initWithTimezone:(NSString *)timezone 
								   email:(NSString *)email 
							   telephone:(NSString *)telephone;
@end
