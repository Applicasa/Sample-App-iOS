
//
//  LiManager.m
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "LiManager.h"
#import "LiConfig.h"
#import <LiCore/LiCore.h>
#import <LiKitPromotions/LiKitPromotions.h>


#import "User.h"
#import "VirtualCurrency.h"
#import "VirtualGoodCategory.h"
#import "VirtualGood.h"
#import <LiKitIAP/LiKitIAP.h>



#define kNotificationString @"ConflictFound"


@implementation LiManager

+ (void) setObjectDictionary{
	NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
	[array addObject:[NSDictionary dictionaryWithObject:[User getFields] forKey:[User getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[VirtualCurrency getFields] forKey:[VirtualCurrency getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[VirtualGoodCategory getFields] forKey:[VirtualGoodCategory getClassName]]];
	[array addObject:[NSDictionary dictionaryWithObject:[VirtualGood getFields] forKey:[VirtualGood getClassName]]];

	[array addObject:[LiKitPromotions getProfileSettingsFieldsDictionary]];
	[array addObject:[LiKitPromotions getPromotionsFieldsDictionary]];
	[array addObject:[LiKitIAP getIAPActionFieldsDictionary]];


	
        
    
	[LiCore initObjectsDictionary:array];
	[array release];
}


+ (void) setForeignKeysDictionary{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

	[dic setValuesForKeysWithDictionary:[LiKitIAP getIAPFKsDictionary]];
	
	
	[dic setObject:[User getForeignKeys] forKey:[User getClassName]];
	[dic setObject:[VirtualCurrency getForeignKeys] forKey:[VirtualCurrency getClassName]];
	[dic setObject:[VirtualGoodCategory getForeignKeys] forKey:[VirtualGoodCategory getClassName]];
	[dic setObject:[VirtualGood getForeignKeys] forKey:[VirtualGood getClassName]];


		
	[LiCore initForeignKeysWithDictionary:dic];
	
	[dic release];
}

+ (void) initDatabase{
    [self setObjectDictionary];
    [self setForeignKeysDictionary];
}

+ (void) conflictFoundBetween:(NSDictionary *)localItem And:(NSDictionary *)serverItem OfObject:(NSString *)className{
	NSString *notificationName = [NSString stringWithFormat:@"%@%@",className,kNotificationString];
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:[NSArray arrayWithObjects:localItem,serverItem, nil] userInfo:nil];
}

+ (int) getSchemeDate{
	return kSchemeDate;
}

+ (NSString *) getApplicationID{
	return kApplication_ID;
}

+ (BOOL) getEnablePush{
	return kEnable_Push;
}

+ (BOOL) getPush_popup_on_start{
	return kPush_popup_on_start;
}

+ (BOOL) getEnable_Applicasa_Debug{
	return kEnable_Applicasa_Debug;
}

+ (float) getSDK_Version{
	return kSDK_Version;
}

+ (float) getFrameWork_Version{
	return kFrameWork_Version;
}

+ (float) getEnable_Location{
	return kEnable_Location;
}

+ (BOOL) getEnable_Offline{
	return kEnable_Offline;
}

+ (NSString *) getApplicasaSecretKey{
	return kApplicasaSecretKey;
}

+ (BOOL) getSandbox_Environment{
	return kSandbox_Environment;
}

@end
