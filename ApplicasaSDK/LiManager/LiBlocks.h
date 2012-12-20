//
// LiBlocks.h
// Created by Applicasa 
// 12/20/2012
//


@class LiObjPushNotification;
typedef void (^SendPushFinished)(NSError *error, NSString *message,LiObjPushNotification *pushObject);

@class User;

typedef void (^GetUserFinished)(NSError *error, User *object);
typedef void (^GetUserArrayFinished)(NSError *error, NSArray *array);

@class VirtualCurrency;

typedef void (^GetVirtualCurrencyFinished)(NSError *error, VirtualCurrency *object);
typedef void (^GetVirtualCurrencyArrayFinished)(NSError *error, NSArray *array);

@class VirtualGood;

typedef void (^GetVirtualGoodFinished)(NSError *error, VirtualGood *object);
typedef void (^GetVirtualGoodArrayFinished)(NSError *error, NSArray *array);

@class VirtualGoodCategory;

typedef void (^GetVirtualGoodCategoryFinished)(NSError *error, VirtualGoodCategory *object);
typedef void (^GetVirtualGoodCategoryArrayFinished)(NSError *error, NSArray *array);

@class Dynamic;

typedef void (^GetDynamicFinished)(NSError *error, Dynamic *object);
typedef void (^GetDynamicArrayFinished)(NSError *error, NSArray *array);


