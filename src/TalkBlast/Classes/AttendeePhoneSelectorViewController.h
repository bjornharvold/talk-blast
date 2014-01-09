//
//  AttendeePhoneSelectorViewController.h
//  iConferenceCall
//
//  Created by crash on 5/30/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TalkBlastAppDelegate;

/*!
 @class AttendeePhoneSelectorViewController
 @abstract Allows the user to select which phone number to use for a contact who has several numbers
 */
@interface AttendeePhoneSelectorViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	TalkBlastAppDelegate *applicationDelegate;
	UIPickerView *uiPicker;
	NSString *personId;
}

@property (nonatomic, retain) NSString *personId;
@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) IBOutlet UIPickerView *uiPicker;

@end
