//
// LiBlockQuery.h
// Created by Applicasa 
// 12/4/2012
//


typedef enum {
	All = 1,
	Just_0_Quantity,
	Non_0_Quantity
} VirutalGoodGetTypes;

typedef enum {
	None = 0,
	//User
	User_None,
	UserID,
	UserName,
	UserFirstName,
	UserLastName,
	UserEmail,
	UserPhone,
	UserPassword,
	UserLastLogin,
	UserRegisterDate,
	UserLocation,
	UserIsRegisteredFacebook,
	UserIsRegistered,
	UserLastUpdate,
	UserFacebookID,
	UserImage,
	UserMainCurrencyBalance,
	UserSecondaryCurrencyBalance,
	UserTempDate,
	//VirtualCurrency
	VirtualCurrency_None,
	VirtualCurrencyID,
	VirtualCurrencyTitle,
	VirtualCurrencyAppleIdentifier,
	VirtualCurrencyGoogleIdentifier,
	VirtualCurrencyDescription,
	VirtualCurrencyPrice,
	VirtualCurrencyCredit,
	VirtualCurrencyKind,
	VirtualCurrencyImageA,
	VirtualCurrencyImageB,
	VirtualCurrencyImageC,
	VirtualCurrencyIsDeal,
	VirtualCurrencyInAppleStore,
	VirtualCurrencyInGoogleStore,
	VirtualCurrencyLastUpdate,
	//VirtualGood
	VirtualGood_None,
	VirtualGoodID,
	VirtualGoodTitle,
	VirtualGoodDescription,
	VirtualGoodMainCurrency,
	VirtualGoodSecondaryCurrency,
	VirtualGoodRelatedVirtualGood,
	VirtualGoodQuantity,
	VirtualGoodMaxForUser,
	VirtualGoodUserInventory,
	VirtualGoodImageA,
	VirtualGoodImageB,
	VirtualGoodImageC,
	VirtualGoodIsDeal,
	VirtualGoodConsumable,
	VirtualGoodLastUpdate,
	VirtualGoodMainCategory,
	//VirtualGoodCategory
	VirtualGoodCategory_None,
	VirtualGoodCategoryID,
	VirtualGoodCategoryName,
	VirtualGoodCategoryLastUpdate
}LiFields;


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


