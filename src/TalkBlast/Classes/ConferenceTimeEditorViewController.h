//
//  ConferenceTimeViewController.h
//  iConferenceCall
//
//  Created by crash on 5/27/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunicationEvent;
@class TalkBlastAppDelegate;

/*!
 @class ConferenceTimeEditorViewController
 @abstract This view allows the user to enter in a desired time for the conf call to occur
 */
@interface ConferenceTimeEditorViewController : UIViewController {
	TalkBlastAppDelegate *applicationDelegate;
	UIDatePicker *datePicker;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@end
