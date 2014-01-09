//
//  ConferenceNameEditorViewController.h
//  iConferenceCall
//
//  Created by crash on 5/27/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunicationEvent;
@class TalkBlastAppDelegate;

/*!
 @class ConferenceNameEditorViewController
 @abstract View for editing the conference call name
 */
@interface ConferenceNameEditorViewController : UIViewController <UITextFieldDelegate> {
	TalkBlastAppDelegate *applicationDelegate;
	UITextField *textField;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) IBOutlet UITextField *textField;

@end
