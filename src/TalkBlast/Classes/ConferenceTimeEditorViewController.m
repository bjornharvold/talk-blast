//
//  ConferenceTimeViewController.m
//  iConferenceCall
//
//  Created by crash on 5/27/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "ConferenceTimeEditorViewController.h"
#import "CommunicationEvent.h"
#import "TalkBlastAppDelegate.h"

@implementation ConferenceTimeEditorViewController
@synthesize applicationDelegate;
@synthesize datePicker;

/*!
 @function viewDidLoad
 @abstract loads once during init - sets the app delegate and inits the save button
 */
- (void)viewDidLoad {
	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
}

/*!
 @function viewWillAppear
 @abstract if the date has already been set once before, redisplay it here by passing the date to the date picker
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (nil != self.applicationDelegate.communicationEvent && nil != self.applicationDelegate.communicationEvent.scheduledDate) { 
		self.datePicker.date = self.applicationDelegate.communicationEvent.scheduledDate;
	}
}

/*
- (void)viewDidAppear:(BOOL)animated {
	//[textField becomeFirstResponder];
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

/*!
 @function save
 @abstract Here we set the final value back on our model object and pop the nav stack
 */
- (void) save {
	if(nil != self.datePicker.date) {
		NSLog(@"Setting conference call time to %@", self.datePicker.date);
		self.applicationDelegate.communicationEvent.scheduledDate = self.datePicker.date;
	}
	
	[(UINavigationController *)self.parentViewController popViewControllerAnimated:YES];
}

- (void)dealloc {
	[applicationDelegate release];
	[datePicker release];
    [super dealloc];
}

@end

