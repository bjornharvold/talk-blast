//
//  ConferenceCallEditorNavigationController.h
//  iConferenceCall
//
//  Created by crash on 5/27/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConferenceCallEditorViewController;

/*!
 @class ConferenceCallEditorNavigationController
 @abstract Holder of conf call editor views. Doesn't do anything now.
 */
@interface ConferenceCallEditorNavigationController : UINavigationController {
	ConferenceCallEditorViewController *conferenceCallEditorViewController;
}

@property (nonatomic, retain) IBOutlet ConferenceCallEditorViewController *conferenceCallEditorViewController;

@end
