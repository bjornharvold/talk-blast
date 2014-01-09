//
//  SoundService.m
//  iConferenceCall
//
//  Created by crash on 6/13/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "SoundService.h"

@implementation SoundService
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize alertView;

// sample rates for recording - we want a highly compressed audio recording that results in a small file
// that is suitable to send with the conference call payload
float const SampleRateKey			= 22050;
float const EncoderBitRateKey		= 6400;
float const BitDepthKey				= 16;
int const NumberOfChannelsKey		= 1;

/*!
 @function clean
 @abstract Currently unused. Releases the audioRecorder object and sets it to nil
 */
- (void) clean {
	if (nil != self.audioRecorder) {
		[self.audioRecorder release];
		self.audioRecorder = nil;
	}
}

/*!
 @function isRecorderReady
 @abstract Checks to see if the audioRecorder has been initialized
 */
- (BOOL) isRecorderReady {
	return self.audioRecorder != nil;
}


- (BOOL) isPlayerReady {
	return self.audioPlayer != nil;
}

/*!
 @function currentRecorderTime
 @abstract Return the time the recorder has recorded so far
 */
- (double) currentRecorderTime {
	double result = 0;
	
	if (nil != audioRecorder) {
		result = audioRecorder.currentTime;
	}
	
	return result;
}

/*!
 @function currentPlayerTime
 @abstract Return the time the player has played so far
 */
- (double) currentPlayerTime {
	double result = 0;
	
	if (nil != audioPlayer) {
		result = audioPlayer.currentTime;
	}
	
	return result;
}

/*!
 @function updateMetersRecorder
 @abstract updates the meters on the recorder so we can get an accurate sampling of volume to visualize
 */
- (void) updateMetersRecorder {
	
	if (nil != self.audioRecorder) {
		[self.audioRecorder updateMeters];
	} else {
		NSLog(@"Cannot update meters. AudioRecorder is nil");
	}
}

/*!
 @function updateMetersPlayer
 @abstract updates the meters on the player so we can get an accurate sampling of volume to visualize
 */
- (void) updateMetersPlayer {
	if (nil != self.audioPlayer) {
		[self.audioPlayer updateMeters];
	} else {
		NSLog(@"Cannot update meters. AudioPlayer is nil");
	}
}

/*!
 @function peakPowerForChannelRecorder
 @param channelNumber channel number to query. 0 for left and 1 for right
 @abstract Queries the recorder for the peak power for the channel that is currently recording
 */
- (float)peakPowerForChannelRecorder:(NSUInteger)channelNumber {
	float result = 0;
	
	if (nil != self.audioRecorder) {
		result = [self.audioRecorder peakPowerForChannel:channelNumber];
		// NSLog(@"Peak power: %d", result);
	} else {
		NSLog(@"Cannot retrieve peak power. AudioRecorder is nil");
	}
	
	return result;
}

/*!
 @function averagePowerForChannelRecorder
 @param channelNumber channel number to query. 0 for left and 1 for right
 @abstract Queries the recorder for the average power for the channel that is currently recording
 */
- (float)averagePowerForChannelRecorder:(NSUInteger)channelNumber {
	float result = 0;
	
	if (nil != self.audioRecorder) {
		result = [self.audioRecorder averagePowerForChannel:channelNumber];
		// NSLog(@"Average power: %d", result);
	} else {
		NSLog(@"Cannot retrieve average power. AudioRecorder is nil");
	}
	
	return result;
}

/*!
 @function peakPowerForChannelPlayer
 @param channelNumber channel number to query. 0 for left and 1 for right
 @abstract Queries the player for the peak power for the channel that is currently playing
 */
- (float)peakPowerForChannelPlayer:(NSUInteger)channelNumber {
	float result = 0;
	
	if (nil != self.audioPlayer) {
		result = [self.audioPlayer peakPowerForChannel:channelNumber];
	} else {
		NSLog(@"Cannot retrieve peak power. AudioPlayer is nil");
	}
	
	return result;
}

/*!
 @function averagePowerForChannelPlayer
 @param channelNumber channel number to query. 0 for left and 1 for right
 @abstract Queries the recorder for the average power for the channel that is currently recording
 */
- (float)averagePowerForChannelPlayer:(NSUInteger)channelNumber {
	float result = 0;
	
	if (nil != self.audioPlayer) {
		result = [self.audioPlayer averagePowerForChannel:channelNumber];
	} else {
		NSLog(@"Cannot retrieve average power. AudioPlayer is nil");
	}
	
	return result;
}

/*!
 @function playWithFile
 @param filePath Absolute file path to an audio file residing in the iPhone file system
 @param delegate Delegate to handle events the player issues during playback
 @param volume Initial volume to start playing audio file with
 @abstract Plays a file from a device directory
 */
- (void) playWithUrl:(NSString *) url 
			 delegate:(id) delegate 
			   volume:(float) volume 
				error:(NSError **)error {
	NSLog(@"Attempting to play file: %@", url);
	
	// init audio player before start
	[self createAVAudioPlayerWithUrl:url 
							delegate:delegate
							  volume:volume 
							   error:error];
	
	if (nil == *error && [self isPlayerReady]) {
		[self.audioPlayer play];
	} else {
		NSLog(@"Url could not be played: %@", [*error localizedDescription]);
	}
}

/*!
 @function stopRecord
 @abstract If the recorder is currently recording, this method will stop it
 */
- (void) stopRecord {
	if ([self isRecording]) {
		[audioRecorder stop];
	}
}

/*!
 @function stop
 @abstract If the player is currently playing, this method will stop it
 */
- (void) stop {
	if ([self isPlaying]) {
		[self.audioPlayer stop];
	} else {
		NSLog(@"Cannot stop something that is not playing");
	}
}

/*!
 @function recordWithFile
 @param filePath Location of the file we wish to record to
 @param delegate Delegate that can handle events published by the recorder
 @param duration Max duration of the recording
 @abstract Starts recording to a file on the iphone filesystem
 **/
- (void) recordWithUrl:(NSString *)url 
			  delegate:(id)delegate
			  duration:(NSNumber *)duration 
				 error:(NSError **)error {
	
	// initialize
	[self createAVAudioRecorderWithUrl:url 
							  delegate:delegate 
								 error:error];
	
	if (nil == *error && [self isRecorderReady]) {
		// we usually want to specify a duration here so we keep the file size small
		if (nil == duration) {
			[self.audioRecorder record];
		} else {
			[self.audioRecorder recordForDuration:[duration doubleValue]];
		}
	} else {
		NSLog(@"Could not record audio: %@", [*error localizedDescription]);
	}
}

/*!
 @function pauseRecording
 @abstract If the recorder is currently recording it will pause the recording 
 */
-(void) pauseRecording {
	if ([self isRecording]) {
		[self.audioRecorder pause];
	}
}

/*!
 @function resetVolume
 @abstract Can be called during playback to change the volume
 */
- (void) resetVolume:(float) value {
	if (nil != self.audioPlayer) {
		self.audioPlayer.volume = value;
	}
}

/*!
 @function isRecording
 @abstract Checks whether the recorder is currently recording
 */
- (BOOL) isRecording {
	BOOL result = NO;
	
	if ([self isRecorderReady] && self.audioRecorder.recording) {
		result = YES;
	}
	
	return result;
}

/*!
 @function isPlaying
 @abstract Checks whether the player is currently playing
 */
- (BOOL) isPlaying {
	return self.audioPlayer.playing; 
}

/*!
 @function createAVAudioRecorder
 @param filePath Location of the file we wish to record to
 @param delegate Delegate that can handle events published by the recorder
 @abstract Attempts to initialize an AVAudioRecorder with filename and delegate this should occur every time a new recording is made
 */
- (void) createAVAudioRecorderWithUrl:(NSString *) url 
							 delegate:(id) delegate 
								error:(NSError **)error {
	[self.audioRecorder release];
	//self.audioRecorder = nil;
	
	NSURL* destinationURL = [NSURL fileURLWithPath: url];
	
	NSMutableDictionary* recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];

	// encoding
	[recordSettings setObject:[NSNumber numberWithInt:kAudioFormatiLBC] 
					   forKey: AVFormatIDKey];
	
	// sample rate
	[recordSettings setObject: [NSNumber numberWithFloat:SampleRateKey]
					   forKey: AVSampleRateKey];
	
	// number of channels (1 for mono)
	[recordSettings setObject:[NSNumber numberWithInt: NumberOfChannelsKey]
					   forKey:AVNumberOfChannelsKey];
	
	// encoder bit rate
	[recordSettings setObject:[NSNumber numberWithInt:EncoderBitRateKey]
					   forKey:AVEncoderBitRateKey];
	
	// encoder bit depth
	[recordSettings setObject:[NSNumber numberWithInt:BitDepthKey]
					   forKey:AVEncoderBitDepthHintKey];

	// audio quality
	[recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityMin]
					   forKey: AVEncoderAudioQualityKey];
	
	self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:destinationURL
												settings:recordSettings 
												   error:error];	
	
	// this is needed for metering to work
	[self.audioRecorder prepareToRecord];
	
	self.audioRecorder.delegate = delegate;
	self.audioRecorder.meteringEnabled = YES;
}

/*!
 @function createAVAudioPlayer
 @param filePath Location of the file we wish to play from
 @param delegate Delegate that can handle events published by the player
 @abstract Initializes the audio player
 */
- (void) createAVAudioPlayerWithUrl:(NSString *)url 
						   delegate:(id) delegate
							 volume:(float) volume 
							  error:(NSError **)error {
	[self.audioPlayer release];
	self.audioPlayer = nil;
	
	NSURL* playbackURL = [NSURL fileURLWithPath: url];
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:playbackURL error:error];
	
	self.audioPlayer.delegate = delegate;
	self.audioPlayer.meteringEnabled = YES;
	self.audioPlayer.volume = volume;
}

- (void)dealloc {
	[self.audioPlayer release];
	[self.audioRecorder release];
	[self.alertView release];
	[super dealloc];
}

@end
