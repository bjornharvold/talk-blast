//
//  ConferenceNameEditorViewController.m
//  iConferenceCall
//
//  Created by crash on 5/27/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "ConferenceNameEditorViewController.h"
#import "CommunicationEvent.h"
#import "TalkBlastAppDelegate.h"

@implementation ConferenceNameEditorViewController
@synthesize textField;
@synthesize applicationDelegate;

/*!
 @function viewDidLoad
 @abstract loads on time at init - sets the app delegate
 */
- (void)viewDidLoad {
	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
}

/*!
 @function viewWillAppear
 @abstract If the communicationEvent is a new one, just add some placeholder text otherwise add the title of the conf call about to be modified
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.textField.text = nil;
	
	if (nil != self.applicationDelegate.communicationEvent && nil != self.applicationDelegate.communicationEvent.title) { 
		self.textField.text = self.applicationDelegate.communicationEvent.title;
	} else {
		self.textField.placeholder = NSLocalizedString(@"page.conferencecall.editor.name.placeholder", @"Name placeholder");
	}
	
}

/*!
 @function viewDidAppear
 @abstract In this view we want to have the keybaord pop up immediately when the view is rendered
 */
- (void)viewDidAppear:(BOOL)animated {
	[self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// textfield delegate methods START
/*!
 @function textFieldShouldReturn
 @abstract When the user presses enter the keybaord should return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)tf {
	[self.textField resignFirstResponder];
	return YES;
}

/*!
 @function textFieldDidEndEditing
 @abstract Here we set the final vaue back on our model object
 */
- (void)textFieldDidEndEditing:(UITextField *)tf {
	if(tf.text.length > 0) {
		NSLog(@"Setting conference call title to %@", self.textField.text);
		self.applicationDelegate.communicationEvent.title = self.textField.text;
	}
	
	[(UINavigationController *)self.parentViewController popViewControllerAnimated:YES];
}
// textfield delegate methods END


- (void)dealloc {
	[applicationDelegate release];
	[textField release];
    [super dealloc];
}


@end

