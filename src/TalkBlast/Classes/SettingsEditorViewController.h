//
//  SettingsEditorViewController.h
//  Either enters or sets up a new account for dialm
//
//  Created by crash on 6/1/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkBlastAppDelegate;

/*!
 @class SettingsEditorViewController
 @abstract Handles editing user preferences, validating them with the server and saving them in user prefences
 */
@interface SettingsEditorViewController : UINavigationController <UITextFieldDelegate, UIAlertViewDelegate> {
	UILabel *companyTitle;
	UILabel *emailTitle;
	UILabel *passwordTitle;
	UILabel *callerIdTitle;
	UILabel *usernameTitle;
	UITextField *username;
	UITextField *company;
	UITextField *email;
	UITextField *password;
	UITextField *callerId;
	UITextView *infoText;
	UIViewController *theView;
	TalkBlastAppDelegate *applicationDelegate;
	UIAlertView *messageWindow;
}

@property (nonatomic, retain) IBOutlet UILabel *companyTitle;
@property (nonatomic, retain) IBOutlet UILabel *usernameTitle;
@property (nonatomic, retain) IBOutlet UILabel *emailTitle;
@property (nonatomic, retain) IBOutlet UILabel *passwordTitle;
@property (nonatomic, retain) IBOutlet UILabel *callerIdTitle;
@property (nonatomic, retain) IBOutlet UITextField *company;
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *callerId;
@property (nonatomic, retain) IBOutlet UITextView *infoText;
@property (nonatomic, retain) IBOutlet UIViewController *theView;
@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) UIAlertView *messageWindow;

- (void) showAlertViewWithMessage:(NSString *)message;
- (void) showAccountRegistrationAlert;
- (BOOL) isValid;
- (IBAction) cancel;
- (IBAction) confirm;
- (void) saveAndExit;

// command methods
/*!
 @function loginResult
 @abstract Called on successful login
 */
- (id) loginResult:(id)object, ...;

/*!
 @function loginFault
 @abstract Called on unsuccessful login
 */
- (id) loginFault:(id)error, ...;

/*!
 @function createAccountResult
 @abstract Called on successful account creation
 */
- (id) createAccountResult:(id)object, ...;

/*!
 @function createAccountFault
 @abstract Called on unsuccessful account creation
 */
- (id) createAccountFault:(id)error, ...;

/*!
 @function handleSuccessfulLoginOrAccountCreation
 @abstract Called by both successful login or account creation methods
 */
- (id) handleSuccessfulLoginOrAccountCreation:(id) object;

@end
