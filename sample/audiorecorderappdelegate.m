//
//  AudioRecorderAppDelegate.m
//  AudioRecorder
//
//  Copyright TrailsintheSand.com 2008. All rights reserved.
//

#import "AudioRecorderAppDelegate.h"

@implementation AudioRecorderAppDelegate

@synthesize window;

- init {
	if (self = [super init]) {
		// Your initialization code here
	}
	return self;
}

void AudioInputCallback(
	void *inUserData, 
	AudioQueueRef inAQ, 
	AudioQueueBufferRef inBuffer, 
	const AudioTimeStamp *inStartTime, 
	UInt32 inNumberPacketDescriptions, 
	const AudioStreamPacketDescription *inPacketDescs)
{
	RecordState* recordState = (RecordState*)inUserData;
    if(!recordState->recording)
    {
        printf("Not recording, returning\n");
    }

    //if(inNumberPacketDescriptions == 0 && recordState->dataFormat.mBytesPerPacket != 0)
    //{
    //    inNumberPacketDescriptions = inBuffer->mAudioDataByteSize / recordState->dataFormat.mBytesPerPacket;
    //}

    printf("Writing buffer %d\n", recordState->currentPacket);
    OSStatus status = AudioFileWritePackets(recordState->audioFile,
            false,
            inBuffer->mAudioDataByteSize,
            inPacketDescs,
            recordState->currentPacket,
            &inNumberPacketDescriptions,
            inBuffer->mAudioData);
    if(status == 0)
    {
        recordState->currentPacket += inNumberPacketDescriptions;
    }

    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
}

void AudioOutputCallback(
        void* inUserData,
        AudioQueueRef outAQ,
        AudioQueueBufferRef outBuffer)
{
	PlayState* playState = (PlayState*)inUserData;	
    if(!playState->playing)
    {
        printf("Not playing, returning\n");
        return;
    }

	printf("Queuing buffer %d for playback\n", playState->currentPacket);
    
    AudioStreamPacketDescription* packetDescs;
    
    UInt32 bytesRead;
    UInt32 numPackets = 8000;
    OSStatus status;
    status = AudioFileReadPackets(
            playState->audioFile,
            false,
            &bytesRead,
            packetDescs,
            playState->currentPacket,
            &numPackets,
            outBuffer->mAudioData);
            
    if(numPackets)
    {
        outBuffer->mAudioDataByteSize = bytesRead;
        status = AudioQueueEnqueueBuffer(
                playState->queue,
                outBuffer,
                0,
                packetDescs);
                
        playState->currentPacket += numPackets;
    }
    else
    {
        if(playState->playing)
        {
            AudioQueueStop(playState->queue, false);
            AudioFileClose(playState->audioFile);
            playState->playing = false;
        }
        
         AudioQueueFreeBuffer(playState->queue, outBuffer);
    }
            
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format 
{
	format->mSampleRate = 8000.0;
	format->mFormatID = kAudioFormatLinearPCM;
	format->mFramesPerPacket = 1;
	format->mChannelsPerFrame = 1;
	format->mBytesPerFrame = 2;
	format->mBytesPerPacket = 2;
	format->mBitsPerChannel = 16;
	format->mReserved = 0;
	format->mFormatFlags = kLinearPCMFormatFlagIsBigEndian |
		kLinearPCMFormatFlagIsSignedInteger |
		kLinearPCMFormatFlagIsPacked;
}

- (void)recordPressed:(id)sender
{
    if(!playState.playing)
    {
        if(!recordState.recording)
        {
            printf("Starting recording\n");
            [self startRecording];
        }
        else
        {
            printf("Stopping recording\n");
            [self stopRecording];
        }
    }
    else
    {
        printf("Can't start recording, currently playing\n");
    }
}

- (void)playPressed:(id)sender
{
    if(!recordState.recording)
    {
        if(!playState.playing)
        {
            printf("Starting playback\n");
            [self startPlayback];
        }
        else
        {
            printf("Stopping playback\n");
            [self stopPlayback];
        }
    }
}

- (void)startRecording
{
    [self setupAudioFormat:&recordState.dataFormat];
    
    recordState.currentPacket = 0;
	
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
			AudioInputCallback,
			&recordState,
			CFRunLoopGetCurrent(),
			kCFRunLoopCommonModes,
			0,
			&recordState.queue);
    
    if(status == 0)
    {
        for(int i = 0; i < NUM_BUFFERS; i++)
        {
            AudioQueueAllocateBuffer(recordState.queue,
                    16000, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer(recordState.queue,
                    recordState.buffers[i], 0, NULL);
        }
        
        status = AudioFileCreateWithURL(fileURL,
                kAudioFileAIFFType,
                &recordState.dataFormat,
                kAudioFileFlags_EraseFile,
                &recordState.audioFile);
        if(status == 0)
        {
            recordState.recording = true;        
            status = AudioQueueStart(recordState.queue, NULL);
            if(status == 0)
            {
                labelStatus.text = @"Recording";
            }
        }
    }
    
    if(status != 0)
    {
        [self stopRecording];
        labelStatus.text = @"Record Failed";
    }
}

- (void)stopRecording
{
    recordState.recording = false;
    
    AudioQueueStop(recordState.queue, true);
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(recordState.queue,
            recordState.buffers[i]);
    }
    
    AudioQueueDispose(recordState.queue, true);
    AudioFileClose(recordState.audioFile);
    labelStatus.text = @"Idle";
}

- (void)startPlayback
{
    playState.currentPacket = 0;
    
    [self setupAudioFormat:&playState.dataFormat];
    
    OSStatus status;
    status = AudioFileOpenURL(fileURL, fsRdPerm, kAudioFileAIFFType, &playState.audioFile);
    if(status == 0)
    {
        status = AudioQueueNewOutput(
                &playState.dataFormat,
                AudioOutputCallback,
                &playState,
                CFRunLoopGetCurrent(),
                kCFRunLoopCommonModes,
                0,
                &playState.queue);
        
        if(status == 0)
        {
            playState.playing = true;
            for(int i = 0; i < NUM_BUFFERS && playState.playing; i++)
            {
                if(playState.playing)
                {
                    AudioQueueAllocateBuffer(playState.queue, 16000, &playState.buffers[i]);
                    AudioOutputCallback(&playState, playState.queue, playState.buffers[i]);
                }
            }

            if(playState.playing)
            {
                status = AudioQueueStart(playState.queue, NULL);
                if(status == 0)
                {
                    labelStatus.text = @"Playing";
                }
            }
        }        
    }
    
    if(status != 0)
    {
        [self stopPlayback];
        labelStatus.text = @"Play failed";
    }
}

- (void)stopPlayback
{
    playState.playing = false;
    
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(playState.queue, playState.buffers[i]);
    }
        
    AudioQueueDispose(playState.queue, true);
    AudioFileClose(playState.audioFile);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // Create window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    // Create status label
    labelStatus = [[UILabel alloc] initWithFrame: CGRectMake(10, 50, 300, 30)];
    labelStatus.textAlignment = UITextAlignmentCenter;
    labelStatus.numberOfLines = 1;
    labelStatus.text = @"Idle";
    
    // Create Record button
    buttonRecord = [UIButton buttonWithType:UIButtonTypeNavigation];
    [buttonRecord setTitle:@"Record" forStates:UIControlStateNormal];
    [buttonRecord addTarget:self action:@selector(recordPressed:) 
            forControlEvents:UIControlEventTouchUpInside];
    buttonRecord.center = CGPointMake(window.center.x, 200);

    // Create Play button
    buttonPlay = [UIButton buttonWithType:UIButtonTypeNavigation];
    [buttonPlay setTitle:@"Play" forStates:UIControlStateNormal];
    [buttonPlay addTarget:self action:@selector(playPressed:) 
            forControlEvents:UIControlEventTouchUpInside];
    buttonPlay.center = CGPointMake(window.center.x, 150);

    // Get audio file page
    char path[256];
    [self getFilename:path maxLenth:sizeof path];
    fileURL = CFURLCreateFromFileSystemRepresentation(NULL, (UInt8*)path, strlen(path), false);
    
    // Init state variables
    playState.playing = false;
    recordState.recording = false;

    // Add the controls to the window
    [window addSubview:labelStatus];
    [window addSubview:buttonRecord];
    [window addSubview:buttonPlay];
    
    [window makeKeyAndVisible];
}

- (void)dealloc
{
    CFRelease(fileURL);
    [labelStatus release];
    [buttonRecord release];
    [buttonPlay release];
    [window release];
    [super dealloc];
}
    
- (BOOL)getFilename:(char*)buffer maxLenth:(int)maxBufferLength
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
            NSUserDomainMask, YES); 
    NSString* docDir = [paths objectAtIndex:0];
    NSString* file = [docDir stringByAppendingString:@"/recording.aif"];
    return [file getCString:buffer maxLength:maxBufferLength encoding:NSUTF8StringEncoding];
}

@end
