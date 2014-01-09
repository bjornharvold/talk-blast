//
//  ConferenceRecordingEditorViewController.h
//  iConferenceCall
//
//  Created by crash on 6/29/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@class TalkBlastAppDelegate;

/*!
 @class ConferenceRecordingEditorViewController
 @abstract Allows the user to select a pre-recorded greeting to accompany the conference call
 */
@interface ConferenceRecordingEditorViewController : UITableViewController <AVAudioPlayerDelegate> {
	TalkBlastAppDelegate *applicationDelegate;
	UIAlertView *alertView;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) UIAlertView *alertView;

@end
