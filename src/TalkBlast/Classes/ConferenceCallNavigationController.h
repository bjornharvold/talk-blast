//
//  ConferenceCallNavigationController.h
//  iConferenceCall
//
//  Created by crash on 5/26/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallHistoryViewController;
@class ConferenceCallEditorViewController;

/*!
 @class ConferenceCallNavigationController
 @abstract Just a holder of the conference call view stack
 */
@interface ConferenceCallNavigationController : UINavigationController {
	CallHistoryViewController *callHistoryViewController;
	ConferenceCallEditorViewController *conferenceCallEditorViewController;
}

@property (nonatomic, retain) IBOutlet CallHistoryViewController *callHistoryViewController;
@property (nonatomic, retain) IBOutlet ConferenceCallEditorViewController *conferenceCallEditorViewController;

@end
