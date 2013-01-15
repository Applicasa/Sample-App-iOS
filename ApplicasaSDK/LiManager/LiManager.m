
//
//  LiManager.m
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "LiManager.h"
#import "LiConfig.h"
#import <LiCore/LiCore.h>
#import <LiCore/LiKitPromotions.h>


#import "User.h"
#import "VirtualCurrency.h"
#import "VirtualGoodCategory.h"
#import "Dynamic.h"
#import "Places.h"
#import "Tips.h"
#import "VirtualGood.h"
#import <LiCore/LiKitIAP.h>



#define kNotificationString @"ConflictFound"


@implementation LiManager

+ (void) setObjectDictionary{
	NSMutableArray *array = [[NSMutableArray alloc] init];
        
	
	[array addObject:[NSDictionary dictionaryWithObject:[User getFields] forKey:[User getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[VirtualCurrency getFields] forKey:[VirtualCurrency getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[VirtualGoodCategory getFields] forKey:[VirtualGoodCategory getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[Dynamic getFields] forKey:[Dynamic getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[Places getFields] forKey:[Places getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[Tips getFields] forKey:[Tips getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[VirtualGood getFields] forKey:[VirtualGood getClassName]]];

	[array addObject:[LiKitPromotions getAnalyticsFieldsDictionary]];
	[array addObject:[LiKitPromotions getProfileSettingsFieldsDictionary]];
	[array addObject:[LiKitPromotions getPromotionsFieldsDictionary]];
	[array addObject:[LiKitIAP getIAPActionFieldsDictionary]];


    
	[LiCore initObjectsDictionary:array];
}


+ (void) setForeignKeysDictionary{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

	[dic setValuesForKeysWithDictionary:[LiKitIAP getIAPFKsDictionary]];
		
	
	[dic setObject:[User getForeignKeys] forKey:[User getClassName]];
	[dic setObject:[VirtualCurrency getForeignKeys] forKey:[VirtualCurrency getClassName]];
	[dic setObject:[VirtualGoodCategory getForeignKeys] forKey:[VirtualGoodCategory getClassName]];
	[dic setObject:[Dynamic getForeignKeys] forKey:[Dynamic getClassName]];
	[dic setObject:[Places getForeignKeys] forKey:[Places getClassName]];
	[dic setObject:[Tips getForeignKeys] forKey:[Tips getClassName]];
	[dic setObject:[VirtualGood getForeignKeys] forKey:[VirtualGood getClassName]];


		
	[LiCore initForeignKeysWithDictionary:dic];
}

+ (void) initDatabase{
    [self setObjectDictionary];
    [self setForeignKeysDictionary];
}

+ (void) conflictFoundBetweenLocalItem:(NSDictionary *)localItem andServerItem:(NSDictionary *)serverItem OfClass:(NSString *)className{
	NSString *notificationName = [NSString stringWithFormat:@"%@%@",className,kNotificationString];
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:[NSArray arrayWithObjects:localItem,serverItem, nil] userInfo:nil];
}

+ (int) getSchemaDate{
	return SCHEMA_DATE;
}

+ (NSString *) getApplicationId{
	return APPLICATION_ID;
}

+ (BOOL) isPushEnabled{
	return ENABLE_PUSH;
}

+ (BOOL) shouldConfirmPushOnStart{
	return SHOULD_CONFIRM_PUSH_ON_START;
}

+ (BOOL) isDebugEnabled{
	return ENABLE_DEBUG;
}

+ (float) getSDKVersion{
	return SDK_VERSION;
}

+ (float) getFrameworkVersion{
	return FRAMEWORK_VERSION;
}

+ (BOOL) isLocationEnabled{
	return ENABLE_LOCATION;
}

+ (BOOL) isOfflineEnabled{
	return ENABLE_OFFLINE;
}

+ (NSString *) getSecretKey{
	return SECRET_KEY;
}

+ (BOOL) isSandboxEnabled{
	return ENABLE_SANDBOX;
}

#pragma mark - Deprecated Methods
/*********************************************************************************
 DEPRECATED METHODS:
 
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the next release. You should update your code immediately.
 **********************************************************************************/

+ (NSString *) getApplicasaSecretKey {
    return [self getSecretKey];
}

+ (BOOL) getEnable_Applicasa_Debug {
    return [self isDebugEnabled];
}

+ (int) getSchemeDate {
    return [self getSchemaDate];
}

+ (float) getSDK_Version {
    return [self getSDKVersion];
}

+ (float) getFrameWork_Version {
    return [self getFrameworkVersion];
}

+ (float) getEnable_Location {
    return [self isLocationEnabled];
}

+ (BOOL) getEnable_Offline {
    return [self isOfflineEnabled];
}

+ (BOOL) getPush_popup_on_start {
    return [self shouldConfirmPushOnStart];
}

+ (BOOL) getEnablePush {
    return [self isPushEnabled];
}

+ (BOOL)getSandbox_Environment {
    return [self isSandboxEnabled];
}

+(void)conflictFoundBetween:(NSDictionary *)localItem And:(NSDictionary *)serverItem OfObject:(NSString *)className {
    [self conflictFoundBetweenLocalItem:localItem andServerItem:serverItem OfClass:className];
}

@end
