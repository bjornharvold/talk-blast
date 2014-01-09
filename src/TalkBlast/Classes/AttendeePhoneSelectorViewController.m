//
//  AttendeePhoneSelectorViewController.m
//  iConferenceCall
//
//  Created by crash on 5/30/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "AttendeePhoneSelectorViewController.h"
#import "TalkBlastAppDelegate.h"
#import "CommunicationEvent.h"
#import "Attendee.h"

@implementation AttendeePhoneSelectorViewController

@synthesize uiPicker, applicationDelegate, personId;

/*!
 @function save
 @abstract pops the view to get back to the parent view
 */
- (void) save {
	[(UINavigationController *)self.parentViewController popViewControllerAnimated:YES];
}

/*!
 @function viewDidLoad
 @abstract gets called once during init - sets app delegate and inits save button
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
 @abstract gets called every time view renderes - reloads the uipicker component with new data (same as table reload)
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// reload data in picker
	[self.uiPicker reloadAllComponents];
	NSLog(@"Loading available phone numbers for attendee with ID: %@", self.personId);
}

#pragma mark ---- UIPickerViewDataSource delegate methods ----

/*!
 @function numberOfComponentsInPickerView
 @abstract There is only one component (the cell phone number). Component = "wheel"
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

/*!
 @function numberOfRowsInComponent
 @abstract returns the number of phone numbers the selected contact has
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSMutableDictionary *attendees = self.applicationDelegate.communicationEvent.attendees;
	Attendee *attendee = (Attendee *)[attendees objectForKey:personId];
	NSMutableArray *availablePhoneNumbers = attendee.availablePhoneNumbers;
	NSInteger *count;
	
	if (nil == availablePhoneNumbers) {
		count = 0;
	} else {
		count = (NSInteger *)[availablePhoneNumbers count];
	}
	
	return (NSInteger)count; 
}

#pragma mark ---- UIPickerViewDelegate delegate methods ----

/*!
 @function titleForRow
 @abstract returns the title of each row. Returns strings such as: "Mobile : 212 555 1212"
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSMutableDictionary *attendees = self.applicationDelegate.communicationEvent.attendees;
	Attendee *attendee = (Attendee *)[attendees objectForKey:personId];
	NSMutableArray *availablePhoneNumbers = attendee.availablePhoneNumbers;
	NSMutableArray *availablePhoneLabels = attendee.availablePhoneLabels;
	
	return [NSString stringWithFormat:@"%@ : %@", [availablePhoneLabels objectAtIndex:row], [availablePhoneNumbers objectAtIndex:row]] ;
}

/*!
 @function didSelectRow
 @abstract gets called when the user settles on a row - sets the phone number and label for attendee object
 */ 
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSMutableDictionary *attendees = self.applicationDelegate.communicationEvent.attendees;
	Attendee *attendee = (Attendee *)[attendees objectForKey:personId];
	NSMutableArray *availablePhoneNumbers = attendee.availablePhoneNumbers;
	NSMutableArray *availablePhoneLabels = attendee.availablePhoneLabels;
	
	NSString *selectedPhoneNumber = [availablePhoneNumbers objectAtIndex:row];
	NSString *selectedPhoneLabel = [availablePhoneLabels objectAtIndex:row];
	attendee.phoneNumber = selectedPhoneNumber;
	attendee.phoneLabel = selectedPhoneLabel;
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

- (void)dealloc {
	[personId release];
	[self.applicationDelegate release];
	[self.uiPicker release];
    [super dealloc];
}


@end
