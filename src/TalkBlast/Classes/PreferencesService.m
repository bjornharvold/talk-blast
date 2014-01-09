//
//  PreferencesService.m
//  TalkBlast
//
//  Created by crash on 7/25/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "PreferencesService.h"

// constant keys
NSString * const UsernamePrefKey    = @"username";
NSString * const EmailPrefKey    = @"email";
NSString * const PasswordPrefKey = @"password";
NSString * const CallerIdPrefKey = @"callerId";

NSString * const RecordingsPathKey = @"Recordings";
NSString * const DocumentsPathKey = @"Documents";
NSString * const TempPathKey = @"temp";
NSString * const PrefsFileNameKey = @"talkblast.plist";
NSString * const AccountObjectKey = @"account.obj";

@implementation PreferencesService

@synthesize documentsDirectory;
@synthesize recordingsDirectory;
@synthesize tempDirectory;
@synthesize fileNames;
@synthesize prefsFilePath;
@synthesize talkBlastPrefs;

//
// Here comes methods used by the settings page

/*!
 @function init
 @abstract Load preference data into memory
 @discussion 
 1. Function will look for a file on the iPhone filesystem called Documents/talkblast.plist. If the file cannot be found, it
 will go ahead and create it. It will then try to load the file and derive a dictionary from the file. If the keys/values that we want
 exist in the dictionary, we set them on our preferences dictionary. Otherwise, initialize with empty strings as values.
 
 2. It will also check to see if there is a Documents/Recordings directory and a Documents/Temp directory. If they don't exist,
 we create them. The temp directory is used for recording a file. When the user is satisfied with the recording, 
 he will move it over to the Recordings directory. 
 
 3. Loads all recordings from the Documents/Recordings directory into memory
 */
+ (PreferencesService *) init {
	PreferencesService *result = [PreferencesService alloc];
	
	result.documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:DocumentsPathKey];
	
	// take care of the preference file first
	if (result.prefsFilePath == nil) {
		result.prefsFilePath = [result.documentsDirectory stringByAppendingPathComponent:PrefsFileNameKey];
		[result.prefsFilePath retain];
	}
	if ([[NSFileManager defaultManager] fileExistsAtPath: result.prefsFilePath]) {
		result.talkBlastPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile: result.prefsFilePath];
		NSLog (@"read prefs from %@", result.prefsFilePath);
	} else {
		NSLog (@"creating empty prefs");
		result.talkBlastPrefs = [[NSMutableDictionary alloc] initWithCapacity: 4];
		[result.talkBlastPrefs setObject: @"" forKey: UsernamePrefKey];
		[result.talkBlastPrefs setObject: @"" forKey: EmailPrefKey];
		[result.talkBlastPrefs setObject: @"" forKey: PasswordPrefKey];
		[result.talkBlastPrefs setObject: @"" forKey: CallerIdPrefKey];
	}
	
	// now check to see if we have to create the recordings directory for the first time
	result.recordingsDirectory = [result.documentsDirectory stringByAppendingPathComponent:RecordingsPathKey];
	BOOL canWrite = [[NSFileManager defaultManager] isWritableFileAtPath:result.recordingsDirectory];
	BOOL exists;
	
	if (!canWrite) {
		exists = [[NSFileManager defaultManager] fileExistsAtPath:result.recordingsDirectory isDirectory:(BOOL *)YES];
		
		if (!exists) {
			// we need to create the recordings directory as this is the first time the user has started this application
             [[NSFileManager defaultManager] createDirectoryAtPath:result.recordingsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
		}
	}
	
	// do the same for temp directory
	result.tempDirectory = [result.documentsDirectory stringByAppendingPathComponent:TempPathKey];
	canWrite = [[NSFileManager defaultManager] isWritableFileAtPath:result.tempDirectory];
	
	if (!canWrite) {
		exists = [[NSFileManager defaultManager] fileExistsAtPath:result.tempDirectory isDirectory:(BOOL *)YES];
		
		if (!exists) {
			// we need to create the recordings directory as this is the first time the user has started this application
			[[NSFileManager defaultManager] createDirectoryAtPath:result.tempDirectory withIntermediateDirectories:YES attributes:nil error:nil];
		}
	}
	
	// instantiate the file names array for the recordings
	if (nil == result.fileNames) {
		result.fileNames = [[NSMutableArray alloc] init];
	}
	
	[result.fileNames removeAllObjects];
	
	NSEnumerator *fileEnum = [[NSFileManager defaultManager] enumeratorAtPath:result.recordingsDirectory];
	NSString *aFile;
	
	// add files from directory
	while ( (aFile = [fileEnum nextObject]) != nil) {
		[result.fileNames addObject: [result.recordingsDirectory stringByAppendingPathComponent:aFile]];
	}
	
	return result;
}

/*!
 @function savePreferences
 @param email User's username with TalkBlast
 @param password User's password with TalkBlast
 @param callerId User's desired caller ID
 @abstract Save preference data back into the NSDictionary object on file 
 */
-(void) savePreferences:(NSDictionary *) preferences {
	
	if (nil != preferences) {
		// save prefs to documents folder
		[preferences writeToFile: prefsFilePath atomically: YES];
	} else {
		NSLog(@"Preferences was empty. Nothing to save.");
	}
}

/*!
 @function prefValueWithKey
 @param key the desired key you wish to retrieve the value for
 @abstract Utility method for grabbing a value by key from the prefs dictionary
 */
- (NSString *) prefValueWithKey:(NSString *) key {
	NSString *result = nil;
	
	if (nil != talkBlastPrefs) {
		result = (NSString *) [talkBlastPrefs objectForKey:key];
	}
	
	return result;
}

/*!
 @function preferencesExists
 @discussion A quick check to see if our preferences have been set
 */
- (BOOL) preferencesExists {
	NSString *username = [self prefValueWithKey:UsernamePrefKey];
	NSString *email = [self prefValueWithKey:EmailPrefKey];
	NSString *password = [self prefValueWithKey:PasswordPrefKey];
	NSString *callerId = [self prefValueWithKey:CallerIdPrefKey];
	NSString *emptyString = @"";
	
	if (nil == email || emptyString == email) {
		return NO;
	} else if (nil == password || emptyString == password) {
		return NO;
	} else if (nil == username || emptyString == username) {
		return NO;
	} else if (nil == callerId || emptyString == callerId) {
		return NO;
	}
	
	NSLog(@"Preferences: %@, %@, %@, %@", username, email, password, callerId);
	
	username = nil;
	email = nil;
	password = nil;
	callerId = nil;
	emptyString = nil;
	
	return YES;
}

/*!
 @function deleteRecordingAtIndex
 @param index The array index in the fileNames array to delete from the file system and the array
 @abstract deletes a file from the file system and from the file names array
 */
- (void) deleteRecordingAtIndex:(NSInteger *) index {
	NSString *fileToDelete = [self.fileNames objectAtIndex:(NSInteger)index];
	NSLog(@"Deleting recording %@", fileToDelete);
	
	// remove from file system
	NSError **error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:fileToDelete error:error];
	
	if (nil != error) {
		NSLog(@"Not able to delete file");
	} else {
		// remove from array
		[self.fileNames removeObjectAtIndex:(NSInteger)index];
	}
}

/*!
 @function deleteRecordingByName
 @param filename The name of the file to delete in the array of filenames
 @abstract deletes a file from the file system and from the file names array
 */
- (void) deleteRecordingByName:(NSString *) filename {
	if ([self.fileNames containsObject:filename]) {
		NSInteger *index = (NSInteger *)[self.fileNames indexOfObject:filename];
		
		[self deleteRecordingAtIndex:index];
	}
}

/*!
 @function userDefaultByKey
 @abstract Retrieves user default value
 */
- (id) userDefaultByKey:(NSString *)key {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *val = [defaults objectForKey:key];
	
	return val;
}

/*!
 @function saveObjectGraph:forKey
 @abstract Persists an object graph to disk
 */
- (void) saveObjectGraph:(id)object 
				  forKey:(NSString *)key {
	NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:key];
	
	[NSKeyedArchiver archiveRootObject:object
								toFile:archivePath];
}

/*!
 @function retrieveObjectGraph:forKey
 @abstract Retrieves an object graph from disk that has been previously persisted
 */
- (id) retrieveObjectGraphForKey:(NSString *)key {
	NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:key];
	
	id result = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
	
	return result;
}

/*!
 @function dealloc
 @abstract Manual garbage collection
 */
- (void)dealloc {
	[self.talkBlastPrefs release];
	[self.prefsFilePath release];
	[self.documentsDirectory release];
	[self.recordingsDirectory release];
	[self.tempDirectory release];
	[self.fileNames release];
    [super dealloc];
}

@end
