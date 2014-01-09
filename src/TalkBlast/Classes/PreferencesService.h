//
//  PreferencesService.h
//  TalkBlast
//
//  Created by crash on 7/25/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UsernamePrefKey;
extern NSString * const EmailPrefKey;
extern NSString * const PasswordPrefKey;
extern NSString * const CallerIdPrefKey;
extern NSString * const TokenKey;
extern NSString * const RecordingsPathKey;
extern NSString * const DocumentsPathKey;
extern NSString * const TempPathKey;
extern NSString * const PrefsFileNameKey;
extern NSString * const AccountObjectKey;

/*!
 @class PreferencesService
 @abstract Handles retrieving, saving and validating preferences that are stored on disk
 */
@interface PreferencesService : NSObject {
	NSString *documentsDirectory;
	NSString *recordingsDirectory;
	NSString *tempDirectory;
	NSMutableArray *fileNames;
	NSMutableDictionary *talkBlastPrefs;
	NSString *prefsFilePath;
}

@property (nonatomic, retain) NSMutableArray *fileNames;
@property (nonatomic, retain) NSString *documentsDirectory;
@property (nonatomic, retain) NSString *recordingsDirectory;
@property (nonatomic, retain) NSString *tempDirectory;
@property (nonatomic, retain) NSMutableDictionary *talkBlastPrefs;
@property (nonatomic, retain) NSString *prefsFilePath;

/*!
 @function prefValueWithKey
 @abstract retrieve a preference value by key
 */
- (NSString *) prefValueWithKey:(NSString *) key;

/*!
 @function savePreferences
 @abstract saves the dictionary of key - value pairs to disk
 */
- (void) savePreferences:(NSDictionary *) preferences;

/*!
 @function init
 @abstract loads preferences from disk to 
 */
+ (PreferencesService *) init;

/*!
 @function preferencesExists
 @abstract checks for the existence of preferences
 */
- (BOOL) preferencesExists;

/*!
 @function deleteRecordingAtIndex
 @abstract deletes a recording from the fileNames array and the filesystems based on an integer value
 */
- (void) deleteRecordingAtIndex:(NSInteger *) index;

/*! 
 @function deleteRecordingByName
 @abstract deletes a recording from the fileNames array and the filesystems based on the file name
 */
- (void) deleteRecordingByName:(NSString *) filename;

/*!
 @function userDefaultByKey 
 @abstract Grabs values from NSUserDefault  
 */
- (id) userDefaultByKey:(NSString *)key;

/*!
 @function saveObjectGraph:forKey
 @abstract Persists an object graph to disk
 */
- (void) saveObjectGraph:(id)object 
				  forKey:(NSString *)key;

- (id) retrieveObjectGraphForKey:(NSString *)key;
@end
