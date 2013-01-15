//
// LiDataTypes.h
// Created by Applicasa 
// 1/15/2013
//


typedef enum {
	All = 1,
	NonInventoryItems,
	InventoryItems
} VirtualGoodType;

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
	VirtualGoodCategoryLastUpdate,
	//Dynamic
	Dynamic_None,
	DynamicID,
	DynamicLastUpdate,
	DynamicText,
	DynamicNumber,
	DynamicReal,
	DynamicDate,
	DynamicBool,
	DynamicHtml,
	//Places
	Places_None,
	PlacesID,
	PlacesLastUpdate,
	PlacesLoc,
	PlacesName,
	//Tips
	Tips_None,
	TipsID,
	TipsLastUpdate,
	TipsContent,
	TipsNum,
	TipsFdfsd
}LiFields;

