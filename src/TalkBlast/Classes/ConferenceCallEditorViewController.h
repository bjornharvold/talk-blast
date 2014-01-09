//
//  NewConferenceCallViewController.h
//  iConferenceCall
//
//  Created by crash on 5/26/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommunicationEvent;
@class ConferenceNameEditorViewController;
@class ConferenceTimeEditorViewController;
@class ConferenceRecordingEditorViewController;
@class TalkBlastAppDelegate;
@class AttendeesEditorViewController;

/*!
 @class ConferenceCallEditorViewController
 @abstract This is where our core of services come together.
 @discussion With this view, the user is presented with a way to create a new conf call or see an old conf call.
 The user can set a name of the conf call (optional), a time for the conf call to occur (optional - defaults to NOW), 
 he can select the attendees and an optional greeting to accompany the conf call that the user has created in the recordings section. 
 One IMPORTANT thing to note here. In InterfaceBuilder, this class is being used twice. One for creating a new conf call and the other 
 when the user selects an existing phone call. If you make any changes to this class, make sure both view work correctly afterwards
 */
@interface ConferenceCallEditorViewController : UITableViewController {
	TalkBlastAppDelegate *applicationDelegate;
	ConferenceNameEditorViewController *conferenceNameEditorViewController;
	ConferenceTimeEditorViewController *conferenceTimeEditorViewController;
	AttendeesEditorViewController *attendeesEditorViewController;
	ConferenceRecordingEditorViewController *conferenceRecordingEditorViewController;
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) IBOutlet ConferenceNameEditorViewController *conferenceNameEditorViewController;
@property (nonatomic, retain) IBOutlet ConferenceTimeEditorViewController *conferenceTimeEditorViewController;
@property (nonatomic, retain) IBOutlet AttendeesEditorViewController *attendeesEditorViewController;
@property (nonatomic, retain) IBOutlet ConferenceRecordingEditorViewController *conferenceRecordingEditorViewController;

- (IBAction) cancel;
- (IBAction) startConference;

@end
