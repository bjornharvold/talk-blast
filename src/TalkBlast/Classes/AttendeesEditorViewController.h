//
//  AttendeesEditorViewController.h
//  iConferenceCall
//
//  Created by crash on 5/29/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@class TalkBlastAppDelegate;
@class AttendeePhoneSelectorViewController;

/*!
 @class AttendeesEditorViewController
 @abstract Let's the user select conf call attendees from people from his address book
 */
@interface AttendeesEditorViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate> {
	TalkBlastAppDelegate *applicationDelegate;
	AttendeePhoneSelectorViewController *attendeePhoneSelectorViewController;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) IBOutlet AttendeePhoneSelectorViewController *attendeePhoneSelectorViewController;

- (NSString *) formatPhoneLabel:(NSString *)phoneLabel;

@end
