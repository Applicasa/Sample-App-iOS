#import <Foundation/Foundation.h>

@interface LiManager : NSObject

+ (void) initDatabase;
+ (void) conflictFoundBetween:(NSDictionary *)localItem And:(NSDictionary *)serverItem OfObject:(NSString *)className;

+ (int) getSchemeDate;
+ (NSString *) getApplicationID;
+ (BOOL) getEnablePush;
+ (BOOL) getPush_popup_on_start;
+ (BOOL) getEnable_Applicasa_Debug;
+ (float) getSDK_Version;
+ (float) getFrameWork_Version;
+ (float) getEnable_Location;
+ (BOOL) getEnable_Offline;
+ (NSString *) getApplicasaSecretKey;
+ (BOOL) getSandbox_Environment;

@end
