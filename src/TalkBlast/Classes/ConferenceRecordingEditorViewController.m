//
//  ConferenceRecordingEditorViewController.m
//  iConferenceCall
//
//  Created by crash on 6/29/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "ConferenceRecordingEditorViewController.h"
#import "TalkBlastAppDelegate.h"
#import "CommunicationEvent.h"
#import "PreferencesService.h"

@implementation ConferenceRecordingEditorViewController
@synthesize applicationDelegate;
@synthesize alertView;

NSIndexPath *selectedIndexPath;

/*!
 @function viewDidLoad
 @abstract gets loaded once, sets the app delegate 
 */
- (void)viewDidLoad {
    [super viewDidLoad];

	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	// we need to set the left button to pop the navigation stack
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// let's reload the data because the user might have made another recording
	[self.tableView reloadData];
}


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


#pragma mark Table view methods
/*!
 @function numberOfSectionsInTableView
 @abstract Only one section in this table view to display list of recordings
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/*!
 @function numberOfRowsInSection
 @abstract Returns the number of pre-defined recordings that can be found on the file system
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.applicationDelegate.preferencesService.fileNames count];
}

/*!
 @function cellForRowAtIndexPath
 @abstract Displays the name of every recording available on the file system
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ConfCallRecordingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [(NSString*) [self.applicationDelegate.preferencesService.fileNames objectAtIndex:indexPath.row] lastPathComponent];
	cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
	cell.imageView.image = [UIImage imageNamed:@"play.png"];
	cell.imageView.highlightedImage = [UIImage imageNamed:@"play_grey.png"];
    return cell;
}

/*!
 @function didSelectRowAtIndexPath
 @abstract When the user selects a row, the recording will automatically start to play. If the user selects
 another row while the first row is still playing, we stop the first recording that is playing and start playing the new row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog (@"select row %d", indexPath.row);
	
	// stop anything that is currently playing
	if ([self.applicationDelegate.soundService isPlaying]) {
		[self.applicationDelegate.soundService stop];
	}
	
	// if the first condition holds true it means the user clicked on the same cell again
	// in which case we want to deselect the cell again
	if (nil != selectedIndexPath && indexPath == selectedIndexPath) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		selectedIndexPath = nil;
		self.applicationDelegate.communicationEvent.filename = nil;
	} else {
		@try {
			
			// set the selected recording on the active conference call
			self.applicationDelegate.communicationEvent.filename = [self.applicationDelegate.preferencesService.fileNames objectAtIndex:indexPath.row];
			
            NSError *error = nil;
			// pass the filename over to the soundService
            [self.applicationDelegate.soundService playWithUrl:self.applicationDelegate.communicationEvent.filename
                                                      delegate:self
                                                        volume:0.75
                                                         error:&error];
		}
		@catch (NSException* exception){
			NSLog (@"exception: %@", exception);
			self.alertView =
			[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"error.playing", @"Can't play")
									   message: [exception reason]
									  delegate: nil
							 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
							 otherButtonTitles:nil, nil];
			[self.alertView show];
			[self.alertView release]; 
		}
		
		selectedIndexPath = indexPath;
	}
	
}

// START AVAudioPlayerDelegate
/*!
 @function audioPlayerDecodeErrorDidOccur
 @abstract AudioPlayerDelegate function - decoder error. Displays an alert window if the format is not supported
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	self.alertView =
	[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"error.playing", @"Can't play")
							   message: [error localizedDescription]
							  delegate: nil
					 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
					 otherButtonTitles:nil, nil];
	[self.alertView show];
	[self.alertView release];
}

/*!
 @function audioPlayerDidFinishPlaying
 @abstract AudioPlayerDelegate function - gets called when the current recording finishes playing.
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog(@"did finish playing");
}

/*!
 @function audioPlayerBeginInterruption
 @abstract AudioPlayerDelegate function - interruption was received such as an incoming phone call. Don't need to do anything.
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	NSLog(@"audio player begin interruption");
}

/*!
 @function audioPlayerEndInterruption
 @abstract AudioPlayerDelegate function - interruption was ended. Don't want to do anything here.
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	NSLog(@"audio player end interruption");
}
// END AVAudioPlayerDelegate


- (void)dealloc {
	[applicationDelegate release];
	[alertView release];
    [super dealloc];
}


@end

