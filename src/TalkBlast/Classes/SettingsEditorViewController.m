//
//  SettingsEditorViewController.m
//  iConferenceCall
//
//  Created by crash on 6/1/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "SettingsEditorViewController.h"
#import "TalkBlastAppDelegate.h"
#import "LoginEvent.h"
#import "CreateAccountEvent.h"
#import "UpdateAccountEvent.h"
#import "RegexKitLite.h"
#import "PreferencesService.h"
#import "Account.h"
#import "AccountUser.h"
#import "AccountPreference.h"
#import "FrontController.h"
#import "Constants.h"

@implementation SettingsEditorViewController

@synthesize companyTitle;
@synthesize emailTitle;
@synthesize passwordTitle;
@synthesize callerIdTitle;
@synthesize usernameTitle;
@synthesize company;
@synthesize email;
@synthesize username;
@synthesize password;
@synthesize callerId;
@synthesize infoText;
@synthesize applicationDelegate;
@synthesize theView;
@synthesize messageWindow;

BOOL *validated = NO;
// regex for a valid email
NSString *emailRegEx = @"^((([a-z]|[0-9]|!|#|$|%|&|'|\\*|\\+|\\-|/|=|\\?|\\^|_|`|\\{|\\||\\}|~)+(\\.([a-z]|[0-9]|!|#|$|%|&|'|\\*|\\+|\\-|/|=|\\?|\\^|_|`|\\{|\\||\\}|~)+)*)@((((([a-z]|[0-9])([a-z]|[0-9]|\\-){0,61}([a-z]|[0-9])\\.))*([a-z]|[0-9])([a-z]|[0-9]|\\-){0,61}([a-z]|[0-9])\\.(af|ax|al|dz|as|ad|ao|ai|aq|ag|ar|am|aw|au|at|az|bs|bh|bd|bb|by|be|bz|bj|bm|bt|bo|ba|bw|bv|br|io|bn|bg|bf|bi|kh|cm|ca|cv|ky|cf|td|cl|cn|cx|cc|co|km|cg|cd|ck|cr|ci|hr|cu|cy|cz|dk|dj|dm|do|ec|eg|sv|gq|er|ee|et|fk|fo|fj|fi|fr|gf|pf|tf|ga|gm|ge|de|gh|gi|gr|gl|gd|gp|gu|gt| gg|gn|gw|gy|ht|hm|va|hn|hk|hu|is|in|id|ir|iq|ie|im|il|it|jm|jp|je|jo|kz|ke|ki|kp|kr|kw|kg|la|lv|lb|ls|lr|ly|li|lt|lu|mo|mk|mg|mw|my|mv|ml|mt|mh|mq|mr|mu|yt|mx|fm|md|mc|mn|ms|ma|mz|mm|na|nr|np|nl|an|nc|nz|ni|ne|ng|nu|nf|mp|no|om|pk|pw|ps|pa|pg|py|pe|ph|pn|pl|pt|pr|qa|re|ro|ru|rw|sh|kn|lc|pm|vc|ws|sm|st|sa|sn|cs|sc|sl|sg|sk|si|sb|so|za|gs|es|lk|sd|sr|sj|sz|se|ch|sy|tw|tj|tz|th|tl|tg|tk|to|tt|tn|tr|tm|tc|tv|ug|ua|ae|gb|us|um|uy|uz|vu|ve|vn|vg|vi|wf|eh|ye|zm|zw|com|edu|gov|int|mil|net|org|biz|info|name|pro|aero|coop|museum|arpa))|(((([0-9]){1,3}\\.){3}([0-9]){1,3}))|(\\[((([0-9]){1,3}\\.){3}([0-9]){1,3})\\])))$";
NSString *callerIdRegEx = @"^\\d{10}$";

/*!
 @function viewDidLoad
 @abstract called once during load - sets app delegate and a whole bunch of i18n string values
 */
- (void)viewDidLoad {
    [super viewDidLoad];

	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	self.theView.title = NSLocalizedString(@"page.settings.setup", @"Setup");
	
	// set placeholder values
	self.companyTitle.text = NSLocalizedString(@"page.settings.company", @"Company");
	self.company.placeholder = NSLocalizedString(@"page.settings.optional", @"optional");
	
	self.usernameTitle.text = NSLocalizedString(@"page.settings.username", @"Username");
	self.username.placeholder = NSLocalizedString(@"page.settings.username", @"Username");
	
	self.emailTitle.text = NSLocalizedString(@"page.settings.email", @"E-Mail");
	self.email.placeholder = NSLocalizedString(@"page.settings.email", @"E-Mail");
	
	self.passwordTitle.text = NSLocalizedString(@"page.settings.password", @"Password");
	self.password.placeholder = NSLocalizedString(@"page.settings.password", @"Password");
	
	self.callerIdTitle.text = NSLocalizedString(@"page.settings.callerid", @"CallerID");
	self.callerId.placeholder = NSLocalizedString(@"page.settings.callerid", @"CallerID");
	
	self.infoText.text = NSLocalizedString(@"page.settings.information", @"Info");
	
	// grab value from preferences if there are any
	if (nil != self.applicationDelegate.account) {
		self.company.text = self.applicationDelegate.account.name;
		self.username.text = self.applicationDelegate.account.accountUser.username;
		self.email.text = self.applicationDelegate.account.accountUser.email;
		self.password.text = self.applicationDelegate.account.accountUser.password;
		self.callerId.text = self.applicationDelegate.account.accountPreference.originatingTelephone;
	}
}

/*!
 @function confirm
 @discussion
 * validates that all the fields have been entered correctly,
 
 * then checks with the server if the user has an account or not,
 
 * if yes, goes back to the Settings page,
 
 * if no, asks user if she wants to create an account
 
 * if yes, it creates an account and returns to Settings page
 
 * if no, returns to Settings page
 */
- (IBAction) confirm {
	BOOL validFields = [self isValid];
	if (validFields) {
		NSLog(@"User entered callerId: %@, company: %@, username: %@, password: %@, email: %@", callerId.text, company.text, username.text, password.text, email.text);
		
		// validate data with the server
		// first check if account exists
		// if not, ask user if they want to create a new account
		BOOL validAccount = YES;
		
		if (validAccount) {
			[self saveAndExit];
		} else {
			// display alert message saying the account doesn't exist
			// tell user to either create a new account with that info or retype information
			[self showAccountRegistrationAlert];
		}
	}
}

/*!
 @function saveAndExit
 @abstract Saves values to preferences file and returns to settings page
 */
- (void) saveAndExit {
	Account *account = nil;
	BOOL isUpdate = NO;
	BOOL isInsert = NO;
	
	/*
	 if there is an existing account object we can check for changes to see if an update is necessary
	 we can also reuse that object instead of allocating a new one so we check for nil and that there
	 is a populated urlName (id) on the account so we know it has been persisted
	 */
	if (nil != self.applicationDelegate.account && nil != self.applicationDelegate.account.urlName) {
		// set the account object to reference the existing account
		account = self.applicationDelegate.account;
		// ok let's compare values, if there is a change we update the user
		// and do a HTTP PUT instead of a POST
		if (account.name != company.text) {
			isUpdate = YES;
			account.name = company.text;
		}
		if (account.accountUser.username != username.text) {
			isUpdate = YES;
			account.accountUser.username = username.text;
		}
		if (account.accountUser.email != email.text) {
			isUpdate = YES;
			account.accountUser.email = email.text;
		}
		if (account.accountUser.password != password.text) {
			isUpdate = YES;
			account.accountUser.password = password.text;
		}
		if (account.accountPreference.originatingTelephone != callerId.text) {
			isUpdate = YES;
			account.accountPreference.originatingTelephone = callerId.text;
		}
	} else {
		isInsert = YES;
		// we have to allocate a new one as this is the first time the user logs in
		account = [Account init];
		
		account.name = company.text;
		account.accountUser.username = username.text;
		account.accountUser.email = email.text;
		account.accountUser.password = password.text;
		account.accountPreference.originatingTelephone = callerId.text;
	}
	
	// call the TalkBlast server to insert/update settings
	if (isUpdate) {
		// update account
		[self.applicationDelegate.frontController dispatchEvent:[UpdateAccountEvent initWithCaller:self 
																							params:[NSDictionary dictionaryWithObjectsAndKeys:account, ACCOUNT, nil]]];
	} else if (isInsert) {
		// insert account
		[self.applicationDelegate.frontController dispatchEvent:[CreateAccountEvent initWithCaller:self 
																							params:[NSDictionary dictionaryWithObjectsAndKeys:account, ACCOUNT, nil]]];
	} else {
		// log in user
		[self.applicationDelegate.frontController dispatchEvent:[LoginEvent initWithCaller:self 
																					params:[NSDictionary dictionaryWithObjectsAndKeys:username.text, USERNAME, password.text, PASSWORD, nil]]];
	}
	
	// deallocated memory
	[account release];
}

/*!
 @function parsingComplete
 @abstract protocol function from XMLEventDelegate
 @discussion parsingComplete handles the last part of automatic login at startup. It will receive an AccountUser object from the TalkBlast server
 
 if it is valid or nil if no user could be found by that name
 */
- (id) loginResult:(id)object, ... {
	NSLog(@"Login successful in controller: %@", [self class]);
	
	return [self handleSuccessfulLoginOrAccountCreation:object];
}

/*!
 @function loginFault
 @abstract If the login attempt fails because the server is down, this method will be called
 */
- (id) loginFault:(id)error, ... {
	NSLog(@"Login failed in controller: %@", [self class]);
	// we don't need to return anything here
	return nil;
}

/*!
 @account createAccountResult
 @abstract Called on successful account creation
 */
- (id) createAccountResult:(id)object, ... {
	NSLog(@"Account creation successful in controller: %@", [self class]);
	
	return [self handleSuccessfulLoginOrAccountCreation:object];
}

/*!
 @function createAccountFault
 @abstract If the login attempt fails because the server is down, this method will be called
 */
- (id) createAccountFault:(id)error, ... {
	NSLog(@"Account creation failed in controller: %@", [self class]);
	// we don't need to return anything here
	return nil;
}

/*!
 @function updateAccountResult
 @abstract Called when account updates successfully
 */
- (id) updateAccountResult:(id)object, ... {
	NSLog(@"Account update successful in controller: %@", [self class]);
	
	return [self handleSuccessfulLoginOrAccountCreation:object];
}

/*!
 @function updateAccountFault
 @abstract If the login attempt fails because the server is down, this method will be called
 */
- (id) updateAccountFault:(id)error, ... {
	NSLog(@"Account update failed in controller: %@", [self class]);
	// we don't need to return anything here
	return nil;
}

/*!
 @function handleSuccessfulLoginOrAccountCreation
 @abstract Called by all success command methods
 */
- (id) handleSuccessfulLoginOrAccountCreation:(id) object {
	// in all other cases of failure the login object will be nil
	if (nil == object) {
		// invalid user - disable the call history tab and the recordings tab
		[self.applicationDelegate toggleTabBarItemAtIndex:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil] 
		 enabled:NO 
		 forwardToControllerWithIndex:nil];
		
		// pop up alert to say the email and password is invalid
		[self.applicationDelegate showInvalidPreferencesAlertView];
	} else {
		if ([object class] == [Account class]) {
			// do nothing - we will forward to the welcome view automatically
			// but we will set the accountUser object on the dialmService
			self.applicationDelegate.account = (Account *)object;
			
			// save preferences to disk for next time user starts application
			[self.applicationDelegate.preferencesService saveObjectGraph:self.applicationDelegate.account forKey:AccountObjectKey];
			
			// enable Past Blasts tab and recordings tab here now - user still needs minutes to make a call but now he can at least look around
			// note Past Blasts might already be enabled but for a new user it will be disabled
			[self.applicationDelegate toggleTabBarItemAtIndex:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil] 
			 enabled:YES 
			 forwardToControllerWithIndex:nil];
			
			// close modal
			[[self parentViewController] dismissModalViewControllerAnimated:YES];
		}
	}
	
	// we don't need to return anything here
	return nil;
}

/*!
 @function isValid
 @abstract Runs some regexp validations to make sure the value are ok to go to the server
 */
- (BOOL) isValid {
	NSString *userEmail = email.text;
	// NSString *userPassword = password.text;
	NSString *userCallerId = callerId.text;
	
	// input values need to matc the regular expressions defined above
	NSString *validEmail = [userEmail stringByMatching:emailRegEx];
	NSString *validCallerId = [userCallerId stringByMatching:callerIdRegEx];
	NSString *errMsg;
	
	if (nil == validEmail) {
		errMsg = NSLocalizedString(@"error.invalid.email", @"Invalid e-mail");
		[self showAlertViewWithMessage:errMsg];
		[errMsg release];
		return NO;
	} else if (nil == validCallerId) {
		errMsg = NSLocalizedString(@"error.invalid.phone", @"Invalid phone");
		[self showAlertViewWithMessage:errMsg];
		[errMsg release];
		return NO;
	}
	
	return YES;
}

/*!
 @function showAlertViewWithMessage
 @abstract displays an alert view to the user
 */
- (void) showAlertViewWithMessage:(NSString *)message {
	NSString *title = NSLocalizedString(@"error.input", @"Input Error");
	NSString *buttonTitle = NSLocalizedString(@"error.input.ok", @"OK");
	self.messageWindow = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil];
	[self.messageWindow show];
	[self.messageWindow release];
}

/*!
 @function showAccountRegistrationAlert
 @abstract Shows an alert view with 2 buttons. One for creating an account and the other for cancel
 */
- (void) showAccountRegistrationAlert {
	NSString *title = NSLocalizedString(@"error.account.not.found", @"No Such Account");
	NSString *cancelButtonTitle = NSLocalizedString(@"button.cancel", @"Cancel");
	NSString *registerButtonTitle = NSLocalizedString(@"button.register", @"Register");
	NSString *message = NSLocalizedString(@"registration.info", @"Register info");
	self.messageWindow = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
	
	[self.messageWindow addButtonWithTitle:registerButtonTitle];
	[self.messageWindow show];
	[self.messageWindow release];
}

/*!
 @function cancel
 @abstract pops the nav controller stack and returns to the settings read-only page
 */
- (IBAction) cancel {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

// textfield delegate methods START
/*!
 @function textFieldShouldReturn
 @abstract When the user hits the return button the keyboard will go away
 */
- (BOOL)textFieldShouldReturn:(UITextField *)tf {
	[tf resignFirstResponder];
	return YES;
}

// UIAlertViewDelegate methods 
/*!
 @function clickedButtonAtIndex
 @abstract when we display the registration alert pop-up there will be a chance for the user to register.
 This method handles this ability.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"clickedButtonAtIndex %d", buttonIndex);
	// there's only one time that the index will be one and that's if a user wishes to register
	// if that is the case, we have to call the register command
	
	if (buttonIndex == 1) {
		Account *user = [Account init];
		user.accountUser.username = username.text;
		user.accountUser.password = password.text;
		user.accountUser.email = email.text;

		// register
		// note for all these remote calls we might want to display a loader icon
		// this does not take into account that the email might be taken
		//[self.applicationDelegate.frontController createAccount:user 
		//											   error:&error];
		
		// NEED TO CHECK FOR ERROR HERE
		
		[self saveAndExit];
	}
}

/*!
 @function didDismissWithButtonIndex
 @abstract unused
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"didDismissWithButtonIndex %d", buttonIndex);
}

/*!
 @function willDismissWithButtonIndex
 @abstract unused
 */
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"willDismissWithButtonIndex %d", buttonIndex);
}

/*!
 @function alertViewCancel
 @abstract unused
 */
- (void)alertViewCancel:(UIAlertView *)alertView {
	NSLog(@"alertViewCancel %@", alertView.title);
}

/*!
 @function didPresentAlertView
 @abstract unused
 */
- (void)didPresentAlertView:(UIAlertView *)alertView {
	NSLog(@"didPresentAlertView %@", alertView.title);
}

/*!
 @function willPresentAlertView
 @abstract unused
 */
- (void)willPresentAlertView:(UIAlertView *)alertView {
	NSLog(@"willPresentAlertView %@", alertView.title);
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	emailRegEx = nil;
	callerIdRegEx = nil;
	[usernameTitle release];
	[emailTitle release];
	[passwordTitle release];
	[callerIdTitle release];
	[username release];
	[email release];
	[password release];
	[callerId release];
	[theView release];
	[applicationDelegate release];
	[messageWindow release];
	[infoText release];
    [super dealloc];
}


@end

