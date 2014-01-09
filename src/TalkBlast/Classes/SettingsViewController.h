//
//  SettingsViewController.h
//  iConferenceCall
//
//  Created by crash on 5/26/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TalkBlastAppDelegate;
@class SettingsEditorViewController;

/*!
 @class SettingsViewController
 @abstract Displays a table view with settings data, available minutes and the ability to purchase more minutes and change settings
 */
@interface SettingsViewController : UITableViewController {
	TalkBlastAppDelegate *applicationDelegate;
	SettingsEditorViewController *settingsEditorViewController;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) IBOutlet SettingsEditorViewController *settingsEditorViewController;

- (id) getMediaContentResult:(id)input, ...;
- (id) getMediaContentFault:(id)error, ...;

@end
