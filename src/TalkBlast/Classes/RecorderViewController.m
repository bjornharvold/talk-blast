//
//  FirstViewController.m
//  StreamingAudioExercises
//
//  Created by Chris Adamson on 2/9/09.
//  Copyright Subsequently and Furthermore, Inc. 2009. All rights reserved.
//

#import "RecorderViewController.h"
#import "PreferencesService.h"


NSString * const TempRecordingKey = @"tempRecording.caf";
double const MaxRecordingTimeInSeconds = 15.0;

@implementation RecorderViewController

@synthesize labelTitle, currentTimeLabel, levelMeter, filename, recordButton, stopButton, playButton, volumeSlider;
@synthesize applicationDelegate, alertView;

/*!
 @function cancel
 @abstract deletes the recording in temp directory and returns to list view
 */
- (IBAction) cancel {
	NSError **error;
	
	// delete tmp file if it exists
	NSString *tempFilePath = [self.applicationDelegate.preferencesService.tempDirectory stringByAppendingPathComponent:TempRecordingKey];
	//BOOL tempFileExists = [[NSFileManager defaultManager] fileExistsAtPath:tempFilePath isDirectory:(BOOL *)NO];
	
	if (tempFilePath) {
		[[NSFileManager defaultManager] removeItemAtPath:[self.applicationDelegate.preferencesService.tempDirectory stringByAppendingPathComponent:TempRecordingKey] error:error];
	}
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

/*!
 @function save
 @abstract Returns to the list after saving file. Method will throw an error if the filename has no been filled in.
 It replaces unwante characters with '_' and appends a .caf file extension to th filename before saving the file
 */
- (IBAction) save {
	// only save if we have a file name
	if ([self.filename.text length] > 0) {
		NSLog(@"Saving file");
		
		NSString *newFilename = self.filename.text;
		// run simple regex to replace all unwanted characters with underscore
		newFilename = [newFilename stringByReplacingOccurrencesOfRegex:@"&|%|\\#|\\$|!|\\*|@|\\^|\\(|\\)|-|\\+|=|\\?|/|\\\\|\\{|\\}|\\[|\\]|\\||:|;|'|\"|`|,|\\.|<|>" 
														withString:@"_"];
		
		// verify that there's a legitimate filename extension
		if ([[newFilename pathExtension] length] == 0 || [newFilename pathExtension] != @".caf") {
			newFilename = [NSString stringWithFormat: @"%@.caf", newFilename];
		}
		
		// recursive function to find unique file
		[self moveFileToRecordingsDirectory:newFilename];
		
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
	} else {
		self.alertView =
		[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"generic.error", @"Error")
								   message:NSLocalizedString(@"error.missing.filename", @"Missing filename")
								  delegate:nil
						 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
						 otherButtonTitles:nil, nil];
		[self.alertView show];
		[self.alertView release];
		
		self.recordButton.selected = NO;
	}
}

/*!
 @function moveFileToRecordingsDirectory
 @abstract Moves the named file from the temp directory and over to the recordings directory and closes the modal window
 */
- (void) moveFileToRecordingsDirectory:(NSString *) theFilename {
	NSString *appendedRecFilePath = nil;
	
	// we should check with the filename to see if it is already taken. 
	// if yes, we append a unique number
	NSString *tempFilePath = [self.applicationDelegate.preferencesService.tempDirectory stringByAppendingPathComponent:TempRecordingKey];
	NSString *recordingsFilePath = [self.applicationDelegate.preferencesService.recordingsDirectory stringByAppendingPathComponent:theFilename];
	
	// rename the file by appending a number until a unique file is found
	BOOL tempFileExists = [[NSFileManager defaultManager] fileExistsAtPath:tempFilePath isDirectory:(BOOL *)NO];
	BOOL notUnique = [[NSFileManager defaultManager] fileExistsAtPath:recordingsFilePath isDirectory:(BOOL *)NO];
	int counter = 1;
	
	while (notUnique) {
		appendedRecFilePath = [recordingsFilePath stringByAppendingFormat:@"_%d", counter];
		notUnique = [[NSFileManager defaultManager] fileExistsAtPath:appendedRecFilePath isDirectory:(BOOL *)NO];
		counter++;
	}
	
	if (nil != appendedRecFilePath) {
		recordingsFilePath = appendedRecFilePath;
	}
	
	if (tempFileExists) {
		// move and clean
		NSError **error;
		[[NSFileManager defaultManager] moveItemAtPath:tempFilePath toPath:recordingsFilePath error:error];
	} else {
		self.alertView =
		[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"generic.error", @"Error")
								   message:NSLocalizedString(@"error.missing.filename", @"Missing filename")
								  delegate:nil
						 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
						 otherButtonTitles:nil, nil];
		[self.alertView show];
		[self.alertView release];
	}
}

/*!
 @function viewDidLoad
 @abstract Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	// check for input h/w
	[self alertIfNoAudioInput];
	
	// setup clock
	minutesSecondsFormatter = [[SimpleMinutesSecondsFormatter alloc] init];
	
	// set some titles
	self.title = NSLocalizedString(@"page.recordings.title", @"Page Recordings Title");
	self.labelTitle.text = NSLocalizedString(@"page.recordings.label", @"Page Recordings Title");
	self.filename.placeholder = NSLocalizedString(@"file.name", @"File name");
	
	// Configure the save and upload button
	UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button.upload", @"Upload") 
																	 style:UIBarButtonItemStyleBordered 
																	target:self 
																	action:@selector(save)];
	self.navigationItem.rightBarButtonItem = uploadButton;
	[uploadButton release];
	
}

/*!
 @function viewWillAppear
 @abstract resets the button to their correct state once the view is displayed
 */
-(void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated];
	
	self.playButton.enabled = NO;
	self.stopButton.enabled = NO;
	self.recordButton.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/*!
 @function alertIfNoInput
 @abstract Queries the hardware layer to verify that there is an audio session available to record to
 */
-(BOOL) alertIfNoAudioInput {
	AVAudioSession* session = [AVAudioSession sharedInstance];
	BOOL audioHWAvailable = session.inputIsAvailable;
	if (! audioHWAvailable) {
		self.alertView =
		[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.recording", @"Can't record")
								   message:NSLocalizedString(@"error.recording.hardware", @"HW not available")
								  delegate:nil
						 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
						 otherButtonTitles:nil, nil];
		[self.alertView show];
		[self.alertView release]; 
	}
	return audioHWAvailable;
}

/*!
 @function record
 @abstract start recording to file
 @discussion record will make sure there is an audio session to record to and that something isn't already recording.
 It will set the action buttons to their correct state, create a file to record to and initialize the recorder. Lastly, it creates a timer
 to track the duration and to update the visual recorder display
 */
- (IBAction) record {
	
	@try {	
		if ([self alertIfNoAudioInput]) {
			// we already disable the record button but if the user is able to execute the function it shouldn't get past here
			if (![self.applicationDelegate.soundService isRecording]) {
				self.recordButton.enabled = NO;
				self.playButton.enabled = NO;
				self.recordButton.selected = YES;
				self.stopButton.enabled = YES;
				
				NSString *tempPath = [self.applicationDelegate.preferencesService.tempDirectory stringByAppendingPathComponent:TempRecordingKey];
				
				// using a constant here so we only have one file at the time in ths directory
				NSError *error = nil;
				[self.applicationDelegate.soundService recordWithUrl:tempPath 
															delegate:self 
															duration:[NSNumber numberWithDouble:MaxRecordingTimeInSeconds] 
															   error:&error];
				
				if (nil != error) {
					self.alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"error.playing", @"Can't play")
																message: [error localizedDescription]
															   delegate: nil
													  cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
													  otherButtonTitles:nil, nil];
					[self.alertView show];
					[self.alertView release];
				} else {
					// init the timer
					currentTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
																			  target:self 
																			selector:@selector(updateAudioRecorderDisplay)
																			userInfo:NULL 
																			 repeats:YES];
				}
			}
		}
	} @catch (NSException* exception){
		NSLog (@"exception: %@", exception);
		self.alertView =
		[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.recording", @"Can't record")
								   message:[exception reason]
								  delegate:nil
						 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
						 otherButtonTitles:nil, nil];
		[self.alertView show];
		[self.alertView release]; 
	}
}

/*!
 @function stop
 @abstract Stop action is used for both playing and recording. We query the sound service to see which of the ones we are using right now.
 @discussion If it is recording it will stop the recording. If it is playing it will stop playback. 
 It will put the action buttons in their correct state
 */
- (IBAction) stop {
	if ([self.applicationDelegate.soundService isRecording]) {
		[self.applicationDelegate.soundService stopRecord];
	} else if ([self.applicationDelegate.soundService isPlaying]){
		[self.applicationDelegate.soundService stop];
	}
	
	// handle buttons
	self.stopButton.enabled = NO;
	self.playButton.enabled = YES;
	self.recordButton.enabled = YES;
	self.recordButton.selected = NO;
	self.playButton.selected = NO;	
}

/*!
 @function play
 @abstract Plays back the temp recording
 @discussion Function passes the temp file to the soundService to play. It also creates a timer so the user will see visual queues
 while playback is happening. Finally, it makes sure the action buttons are in their correct state.
 */
- (IBAction) play {
	
	// start playing recording in temp directory
	NSError *error = nil;
	[self.applicationDelegate.soundService playWithUrl:[self.applicationDelegate.preferencesService.tempDirectory stringByAppendingPathComponent:TempRecordingKey] 
											   delegate:self 
												volume:volumeSlider.value 
												 error:&error];

	if (nil != error) {
		self.alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"error.playing", @"Can't play")
													message: [error localizedDescription]
												   delegate: nil
										  cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
										  otherButtonTitles:nil, nil];
		[self.alertView show];
		[self.alertView release];
	} else {
		// init the timer
		currentTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
																  target:self 
																selector:@selector(updateAudioPlayerDisplay)
																userInfo:NULL 
																 repeats:YES];
		
		// handle buttons
		self.recordButton.enabled = NO;
		self.stopButton.enabled = YES;
		self.playButton.enabled = NO;
		self.playButton.selected = YES;
	}
}

/*!
 @function handleVolumeSliderValueChanged
 @abstract updates the volume for playback of recording file
 */
- (IBAction) handleVolumeSliderValueChanged {
	[self.applicationDelegate.soundService resetVolume:self.volumeSlider.value];
}

/*!
 @function updateAudioRecorderDisplay
 @abstract This method updates the visual display during recording
 @discussion Updates the timer and the LevelMeter the user can see as he is recording. 
 */
- (void) updateAudioRecorderDisplay {
	if (![self.applicationDelegate.soundService isRecording]) {
		self.currentTimeLabel.text = @"--:--";
		NSLog(@"Invalidating recording timer");
        [currentTimeUpdateTimer invalidate];
	} else {
		double currentTime = [self.applicationDelegate.soundService currentRecorderTime];
		self.currentTimeLabel.text = [minutesSecondsFormatter stringForObjectValue: [NSNumber numberWithDouble: currentTime]];
		
		[self.applicationDelegate.soundService updateMetersRecorder];
		float power = [self.applicationDelegate.soundService averagePowerForChannelRecorder:0];
		float peak = [self.applicationDelegate.soundService peakPowerForChannelRecorder:0];
		
		if (peak > 0 || power > 0) {
            int powerInt = power;
            int peakInt = peak;
			NSLog(@"Power: %d, Peak: %d", powerInt, peakInt);
		}
		[self.levelMeter setPower: power
						peak: peak];
	}
}

/*!
 @function updateAudioPlayerDisplay
 @abstract This method updates the visual display during playback
 */
- (void) updateAudioPlayerDisplay {
	if (![self.applicationDelegate.soundService isPlaying]) {
		self.currentTimeLabel.text = @"--:--";
		NSLog(@"Invalidating playing timer");
		[currentTimeUpdateTimer invalidate];
	} else {
		double currentTime = [self.applicationDelegate.soundService currentPlayerTime];
		self.currentTimeLabel.text = [minutesSecondsFormatter stringForObjectValue: [NSNumber numberWithDouble: currentTime]];
		
		[self.applicationDelegate.soundService updateMetersPlayer];
		float power = [self.applicationDelegate.soundService averagePowerForChannelPlayer:0];
		float peak = [self.applicationDelegate.soundService peakPowerForChannelPlayer:0];
		
		if (peak > 0 || power > 0) {
			int powerInt = power;
            int peakInt = peak;
			NSLog(@"Power: %d, Peak: %d", powerInt, peakInt);
		}
		[self.levelMeter setPower: power
						peak: peak];
	}
}

// UITextFieldDelegate methods
/*!
 @function textFieldShouldReturn
 @abstract When user presses enter the keyboard should go away
 */
- (BOOL)textFieldShouldReturn:(UITextField *)tf {
	[self.filename resignFirstResponder];
	return YES;
}

/*!
 @function textFieldDidEndEditing
 @abstract No need to to anything with this method yet
 */
- (void)textFieldDidEndEditing:(UITextField *)tf {
	NSLog(@"textFieldDidEndEditing");
}

#pragma mark AVAudioRecorderDelegate methods
/*!
 @function audioRecorderDidFinishRecording
 @abstract Gets called when recording finishes. Resets the action buttons and level meter
 */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
						   successfully:(BOOL)flag {
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	self.recordButton.enabled = YES;
	self.recordButton.selected = NO;
	self.stopButton.enabled = NO;
	self.playButton.enabled = YES;
	
	[self.levelMeter setPower:0 peak:0];

	// have to figure out whether to call this here or not
	//[self.applicationDelegate.soundService clean];
}

/*!
 @function audioRecorderEncodeErrorDidOccur
 @abstract encoder error occurred when trying to record. resets actions buttons and level meter
 */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
								   error:(NSError *)error {
	self.recordButton.enabled = YES;
	self.recordButton.selected = NO;
	
	[self.levelMeter setPower:0 peak:0];
	
	self.alertView =
	[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"error.recording", @"Can't record")
							   message: [error localizedDescription]
							  delegate: nil
					 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
					 otherButtonTitles:nil, nil];
	[self.alertView show];
	[self.alertView release];
	
	// have to figure out whether to call this here or not
	//[self.applicationDelegate.soundService clean];
}

/*!
 @function audioRecorderBeginInterruption
 @abstract AudioRecorderDelegate function - interruption was received such as an incoming phone call. Reset buttons and level meter.
 */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
	NSLog (@"begin interruption!");
	self.recordButton.enabled = YES;
	self.recordButton.selected = NO;
	
	[self.levelMeter setPower:0 peak:0];
}

/*!
 @function audioPlayerEndInterruption
 @abstract AudioRecorderDelegate function - interruption was ended. Reset buttons and level meter.
 */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
	NSLog (@"end interruption!");
	self.recordButton.enabled = YES;
	self.recordButton.selected = NO;
	
	[self.levelMeter setPower:0 peak:0];
}

// START AVAudioPlayerDelegate
/*!
 @function audioPlayerDecodeErrorDidOccur
 @abstract AudioPlayerDelegate function - decoder error. Displays an alert window if the format is not supported. Resets action buttons and level meter
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	self.recordButton.enabled = YES;
	self.recordButton.selected = NO;
	self.playButton.enabled = YES;
	self.playButton.selected = NO;
	self.stopButton.selected = NO;
	self.stopButton.enabled = NO;
	
	[self.levelMeter setPower:0 peak:0];
	
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
 @abstract AudioPlayerDelegate function - gets called when the current recording finishes playing. Resets action buttons and level meter
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog (@"did finish playing");
	self.playButton.enabled = YES;
	self.playButton.selected = NO;
	self.recordButton.enabled = YES;
	self.stopButton.enabled = NO;
	
	[self.levelMeter setPower:0 peak:0];
}

/*!
 @function audioPlayerBeginInterruption
 @abstract AudioPlayerDelegate function - interruption was received such as an incoming phone call. Resets action buttons and level meter
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	self.playButton.enabled = YES;
	self.playButton.selected = NO;
	self.recordButton.enabled = YES;
	self.stopButton.enabled = NO;
	
	[self.levelMeter setPower:0 peak:0];
}

/*!
 @function audioPlayerEndInterruption
 @abstract AudioPlayerDelegate function - interruption was ended. Resets action buttons and level meter
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	self.playButton.enabled = YES;
	self.playButton.selected = NO;
	self.recordButton.enabled = YES;
	self.stopButton.enabled = NO;
	
	[self.levelMeter setPower:0 peak:0];
}
// END AVAudioPlayerDelegate

- (void)dealloc {
	[minutesSecondsFormatter release];
	[currentTimeUpdateTimer release];
	[self.applicationDelegate release];
	[self.alertView release];
	[self.labelTitle release];
	[self.filename release];
	[self.recordButton release];
	[self.playButton release];
	[self.stopButton release];
	[self.currentTimeLabel release];
	[self.volumeSlider release];
	[self.levelMeter release];
    [super dealloc];
}

@end
