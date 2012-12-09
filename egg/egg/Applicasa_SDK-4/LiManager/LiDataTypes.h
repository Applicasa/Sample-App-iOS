//
// LiDataTypes.h
// Created by Applicasa 
// 09/12/2012
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
	//Game
	Game_None,
	GameID,
	GameLastUpdate,
	GameNumOfChips,
	GameName,
	GamePlayerOne,
	GamePlayerTwo,
	//Move
	Move_None,
	MoveID,
	MoveLastUpdate,
	MoveNum,
	MoveGame
}LiFields;

