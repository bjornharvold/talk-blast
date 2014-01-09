//
//  SoundService.h
//  iConferenceCall
//
//  Created by crash on 6/13/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

/*!
 @class SoundService
 @abstract Manages the AVAdioRecorder and AVAudioPlayer classes. Enables the application to record end playback audio files.
 */
@interface SoundService : NSObject {
	AVAudioRecorder *audioRecorder;
	AVAudioPlayer *audioPlayer;
	UIAlertView *alertView;
}

@property (retain, nonatomic) AVAudioRecorder *audioRecorder;
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) UIAlertView *alertView;

/*!
 @function playWithUrl:delegate:volume:error
 @abstract This function will play a file that is url based
 @param url Url of file
 @param delegate Delegate to handle audioPlayer events
 @param volume Initial volume to start playing the audio content
 @param error Error pointer that gets initialized if something goes wrong during player creation
 */
- (void) playWithUrl:(NSString *)url 
			delegate:(id)delegate
			  volume:(float)volume 
			   error:(NSError **)error;

/*!
 @function recordWithUrl:delegate:duration:error
 @abstract This function will record to the specified url
 @param url Url of file
 @param delegate Delegate to handle audioRecorder events
 @param volume Initial volume to start playing the audio content
 @param error Error pointer that gets initialized if something goes wrong during player creation
 */
- (void) recordWithUrl:(NSString *)url 
			  delegate:(id)delegate
			  duration:(NSNumber *)duration 
				 error:(NSError **)error;

/*!
 @function createAVAudioRecorderWithUrl:delegate:error
 @abstract Convenience method to set up the audioRecorder instance
 @param url Url of file
 @param delegate Delegate to handle audioRecorder events
 @param error Error pointer that gets initialized if something goes wrong during player creation
 */
- (void) createAVAudioRecorderWithUrl:(NSString *)url 
							 delegate:(id)delegate 
								error:(NSError **)error;

/*!
 @function createAVAudioWithUrl:delegate:error
 @abstract Convenience method to set up the audioRecorder instance
 @param url Url of file
 @param delegate Delegate to handle audioPlayer events
 @param volume Initial volume to start playing the audio content
 @param error Error pointer that gets initialized if something goes wrong during player creation
 */
- (void) createAVAudioPlayerWithUrl:(NSString *)url 
						delegate:(id)delegate
						  volume:(float)volume 
						   error:(NSError **)error;

// self explanatory convenience methods
- (void) stopRecord;
- (void) stop;
- (void) resetVolume:(float) value;
- (BOOL) isRecording;
- (BOOL) isPlaying;
- (BOOL) isRecorderReady;
- (BOOL) isPlayerReady;
- (double) currentRecorderTime;
- (double) currentPlayerTime;
- (float) peakPowerForChannelRecorder:(NSUInteger)channelNumber;
- (float) averagePowerForChannelRecorder:(NSUInteger)channelNumber;
- (float) peakPowerForChannelPlayer:(NSUInteger)channelNumber;
- (float) averagePowerForChannelPlayer:(NSUInteger)channelNumber;
- (void) clean;
- (void) updateMetersRecorder;
- (void) updateMetersPlayer;

@end
