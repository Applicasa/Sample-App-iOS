//
// LiBlocks.h
// Created by Applicasa 
// 09/12/2012
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

@class Game;

typedef void (^GetGameFinished)(NSError *error, Game *object);
typedef void (^GetGameArrayFinished)(NSError *error, NSArray *array);

@class Move;

typedef void (^GetMoveFinished)(NSError *error, Move *object);
typedef void (^GetMoveArrayFinished)(NSError *error, NSArray *array);


