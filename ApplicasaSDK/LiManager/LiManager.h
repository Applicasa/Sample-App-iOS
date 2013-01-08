#import <Foundation/Foundation.h>

@interface LiManager : NSObject

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/

+ (void) initDatabase;

+ (void) conflictFoundBetweenLocalItem:(NSDictionary *)localItem andServerItem:(NSDictionary *)serverItem OfClass:(NSString *)className;
+ (void) conflictFoundBetween:(NSDictionary *)localItem And:(NSDictionary *)serverItem OfObject:(NSString *)className DEPRECATED_ATTRIBUTE;

// Checking SDK Settings
+ (int) getSchemaDate;
+ (int) getSchemeDate DEPRECATED_ATTRIBUTE;

+ (float) getSDKVersion;
+ (float) getSDK_Version DEPRECATED_ATTRIBUTE;

+ (float) getFrameworkVersion;
+ (float) getFrameWork_Version DEPRECATED_ATTRIBUTE;

// Checking Application Settings
+ (NSString *) getApplicationId;

+ (NSString *) getSecretKey;
+ (NSString *) getApplicasaSecretKey DEPRECATED_ATTRIBUTE;

// Checking Behavior Settings
+ (BOOL) isPushEnabled;
+ (BOOL) getEnablePush DEPRECATED_ATTRIBUTE;

+ (BOOL) shouldConfirmPushOnStart;
+ (BOOL) getPush_popup_on_start DEPRECATED_ATTRIBUTE;

+ (BOOL) isDebugEnabled;
+ (BOOL) getEnable_Applicasa_Debug DEPRECATED_ATTRIBUTE;

+ (BOOL) isLocationEnabled;
+ (float) getEnable_Location DEPRECATED_ATTRIBUTE;

+ (BOOL) isOfflineEnabled;
+ (BOOL) getEnable_Offline DEPRECATED_ATTRIBUTE;

+ (BOOL) isSandboxEnabled;
+ (BOOL) getSandbox_Environment DEPRECATED_ATTRIBUTE;

@end
