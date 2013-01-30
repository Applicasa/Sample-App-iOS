//
// VirtualCurrency.m
// Created by Applicasa 
// 1/30/2013
//

#import "VirtualCurrency.h"
#import <StoreKit/StoreKit.h>

#define kClassName                  @"VirtualCurrency"

#define KEY_virtualCurrencyID				@"VirtualCurrencyID"
#define KEY_virtualCurrencyTitle				@"VirtualCurrencyTitle"
#define KEY_virtualCurrencyAppleIdentifier				@"VirtualCurrencyAppleIdentifier"
#define KEY_virtualCurrencyGoogleIdentifier				@"VirtualCurrencyGoogleIdentifier"
#define KEY_virtualCurrencyDescription				@"VirtualCurrencyDescription"
#define KEY_virtualCurrencyPrice				@"VirtualCurrencyPrice"
#define KEY_virtualCurrencyCredit				@"VirtualCurrencyCredit"
#define KEY_virtualCurrencyKind				@"VirtualCurrencyKind"
#define KEY_virtualCurrencyImageA				@"VirtualCurrencyImageA"
#define KEY_virtualCurrencyImageB				@"VirtualCurrencyImageB"
#define KEY_virtualCurrencyImageC				@"VirtualCurrencyImageC"
#define KEY_virtualCurrencyIsDeal				@"VirtualCurrencyIsDeal"
#define KEY_virtualCurrencyInAppleStore				@"VirtualCurrencyInAppleStore"
#define KEY_virtualCurrencyInGoogleStore				@"VirtualCurrencyInGoogleStore"
#define KEY_virtualCurrencyLastUpdate				@"VirtualCurrencyLastUpdate"

@interface VirtualCurrency (privateMethods)


@end

@implementation VirtualCurrency

@synthesize product;
@synthesize itunesPrice;
@synthesize virtualCurrencyID;
@synthesize virtualCurrencyTitle;
@synthesize virtualCurrencyAppleIdentifier;
@synthesize virtualCurrencyGoogleIdentifier;
@synthesize virtualCurrencyDescription;
@synthesize virtualCurrencyPrice;
@synthesize virtualCurrencyCredit;
@synthesize virtualCurrencyKind;
@synthesize virtualCurrencyImageA;
@synthesize virtualCurrencyImageB;
@synthesize virtualCurrencyImageC;
@synthesize virtualCurrencyIsDeal;
@synthesize virtualCurrencyInAppleStore;
@synthesize virtualCurrencyInGoogleStore;
@synthesize virtualCurrencyLastUpdate;

enum VirtualCurrencyIndexes {
	VirtualCurrencyIDIndex = 0,
	VirtualCurrencyTitleIndex,
	VirtualCurrencyAppleIdentifierIndex,
	VirtualCurrencyGoogleIdentifierIndex,
	VirtualCurrencyDescriptionIndex,
	VirtualCurrencyPriceIndex,
	VirtualCurrencyCreditIndex,
	VirtualCurrencyKindIndex,
	VirtualCurrencyImageAIndex,
	VirtualCurrencyImageBIndex,
	VirtualCurrencyImageCIndex,
	VirtualCurrencyIsDealIndex,
	VirtualCurrencyInAppleStoreIndex,
	VirtualCurrencyInGoogleStoreIndex,
	VirtualCurrencyLastUpdateIndex,};
#define NUM_OF_VIRTUALCURRENCY_FIELDS 15




# pragma mark - Initialization

/*
*  init with defaults values
*/
- (id) init {
	if (self = [super init]) {

		self.virtualCurrencyID				= @"0";
		self.virtualCurrencyTitle				= @"";
		self.virtualCurrencyAppleIdentifier				= @"";
		self.virtualCurrencyGoogleIdentifier				= @"";
		self.virtualCurrencyDescription				= @"";
		self.virtualCurrencyPrice				= 0;
		self.virtualCurrencyCredit				= 0;
		self.virtualCurrencyKind				= 0;
		self.virtualCurrencyImageA				= [NSURL URLWithString:@""];
		self.virtualCurrencyImageB				= [NSURL URLWithString:@""];
		self.virtualCurrencyImageC				= [NSURL URLWithString:@""];
		self.virtualCurrencyIsDeal				= NO;
		self.virtualCurrencyInAppleStore				= NO;
		self.virtualCurrencyInGoogleStore				= NO;
		virtualCurrencyLastUpdate				= [[NSDate alloc] initWithTimeIntervalSince1970:0];
		self.product = nil;
		self.itunesPrice = nil;
	}
	return self;
}

- (BOOL) validateSecurityForDictionary:(NSDictionary *)dictionary Header:(NSString *)header{
	return [LiKitIAP validateObjectDictionary:dictionary FromTable:kClassName Header:header];
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

	if (![self validateSecurityForDictionary:item Header:header])
		return self;
		self.virtualCurrencyID               = [item objectForKey:KeyWithHeader(KEY_virtualCurrencyID, header)];
		self.virtualCurrencyTitle               = [item objectForKey:KeyWithHeader(KEY_virtualCurrencyTitle, header)];
		self.virtualCurrencyAppleIdentifier               = [item objectForKey:KeyWithHeader(KEY_virtualCurrencyAppleIdentifier, header)];
		self.virtualCurrencyGoogleIdentifier               = [item objectForKey:KeyWithHeader(KEY_virtualCurrencyGoogleIdentifier, header)];
		self.virtualCurrencyDescription               = [item objectForKey:KeyWithHeader(KEY_virtualCurrencyDescription, header)];
		self.virtualCurrencyPrice               = [[item objectForKey:KeyWithHeader(KEY_virtualCurrencyPrice, header)] floatValue];
		self.virtualCurrencyCredit               = [[item objectForKey:KeyWithHeader(KEY_virtualCurrencyCredit, header)] integerValue];
		self.virtualCurrencyKind               = [[item objectForKey:KeyWithHeader(KEY_virtualCurrencyKind, header)] integerValue];
		self.virtualCurrencyImageA               = [NSURL URLWithString:[item objectForKey:KeyWithHeader(KEY_virtualCurrencyImageA, header)]];
		self.virtualCurrencyImageB               = [NSURL URLWithString:[item objectForKey:KeyWithHeader(KEY_virtualCurrencyImageB, header)]];
		self.virtualCurrencyImageC               = [NSURL URLWithString:[item objectForKey:KeyWithHeader(KEY_virtualCurrencyImageC, header)]];
		self.virtualCurrencyIsDeal               = [[item objectForKey:KeyWithHeader(KEY_virtualCurrencyIsDeal, header)] boolValue];
		self.virtualCurrencyInAppleStore               = [[item objectForKey:KeyWithHeader(KEY_virtualCurrencyInAppleStore, header)] boolValue];
		self.virtualCurrencyInGoogleStore               = [[item objectForKey:KeyWithHeader(KEY_virtualCurrencyInGoogleStore, header)] boolValue];
		virtualCurrencyLastUpdate               = [item objectForKey:KeyWithHeader(KEY_virtualCurrencyLastUpdate, header)];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(VirtualCurrency *)object {
	if (self = [super init]) {

		self.virtualCurrencyID               = object.virtualCurrencyID;
		self.virtualCurrencyTitle               = object.virtualCurrencyTitle;
		self.virtualCurrencyAppleIdentifier               = object.virtualCurrencyAppleIdentifier;
		self.virtualCurrencyGoogleIdentifier               = object.virtualCurrencyGoogleIdentifier;
		self.virtualCurrencyDescription               = object.virtualCurrencyDescription;
		self.virtualCurrencyPrice               = object.virtualCurrencyPrice;
		self.virtualCurrencyCredit               = object.virtualCurrencyCredit;
		self.virtualCurrencyKind               = object.virtualCurrencyKind;
		self.virtualCurrencyImageA               = object.virtualCurrencyImageA;
		self.virtualCurrencyImageB               = object.virtualCurrencyImageB;
		self.virtualCurrencyImageC               = object.virtualCurrencyImageC;
		self.virtualCurrencyIsDeal               = object.virtualCurrencyIsDeal;
		self.virtualCurrencyInAppleStore               = object.virtualCurrencyInAppleStore;
		self.virtualCurrencyInGoogleStore               = object.virtualCurrencyInGoogleStore;
		virtualCurrencyLastUpdate               = object.virtualCurrencyLastUpdate;

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:virtualCurrencyID forKey:KEY_virtualCurrencyID];
	[dictionary addValue:virtualCurrencyTitle forKey:KEY_virtualCurrencyTitle];
	[dictionary addValue:virtualCurrencyAppleIdentifier forKey:KEY_virtualCurrencyAppleIdentifier];
	[dictionary addValue:virtualCurrencyGoogleIdentifier forKey:KEY_virtualCurrencyGoogleIdentifier];
	[dictionary addValue:virtualCurrencyDescription forKey:KEY_virtualCurrencyDescription];
	[dictionary addFloatValue:virtualCurrencyPrice forKey:KEY_virtualCurrencyPrice];
	[dictionary addIntValue:virtualCurrencyCredit forKey:KEY_virtualCurrencyCredit];
	[dictionary addIntValue:virtualCurrencyKind forKey:KEY_virtualCurrencyKind];
	[dictionary addValue:virtualCurrencyImageA.absoluteString forKey:KEY_virtualCurrencyImageA];	[dictionary addValue:virtualCurrencyImageB.absoluteString forKey:KEY_virtualCurrencyImageB];	[dictionary addValue:virtualCurrencyImageC.absoluteString forKey:KEY_virtualCurrencyImageC];	[dictionary addBoolValue:virtualCurrencyIsDeal forKey:KEY_virtualCurrencyIsDeal];
	[dictionary addBoolValue:virtualCurrencyInAppleStore forKey:KEY_virtualCurrencyInAppleStore];
	[dictionary addBoolValue:virtualCurrencyInGoogleStore forKey:KEY_virtualCurrencyInGoogleStore];
	[dictionary addDateValue:virtualCurrencyLastUpdate forKey:KEY_virtualCurrencyLastUpdate];

	return dictionary;
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_virtualCurrencyID];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyTitle];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyAppleIdentifier];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyGoogleIdentifier];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyDescription];
	[fieldsDic setValue:TypeAndDefaultValue(kREAL_TYPE,@"0") forKey:KEY_virtualCurrencyPrice];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualCurrencyCredit];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualCurrencyKind];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyImageA];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyImageB];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualCurrencyImageC];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualCurrencyIsDeal];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualCurrencyInAppleStore];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualCurrencyInGoogleStore];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_virtualCurrencyLastUpdate];
	[fieldsDic setValue:kTEXT_TYPE forKey:@"Security"];
	
	return fieldsDic;
}

+ (NSDictionary *) getForeignKeys{
	NSMutableDictionary *foreignKeysDic = [[NSMutableDictionary alloc] init];

	
	return foreignKeysDic;
}

+ (NSString *) getClassName{
	return kClassName;
}

+ (NSString *) getFieldName:(LiFields)field{
	NSString *fieldName;
	
	switch (field) {
		case VirtualCurrency_None:
			fieldName = @"pos";
			break;
	
		case VirtualCurrencyID:
			fieldName = KEY_virtualCurrencyID;
			break;

		case VirtualCurrencyTitle:
			fieldName = KEY_virtualCurrencyTitle;
			break;

		case VirtualCurrencyAppleIdentifier:
			fieldName = KEY_virtualCurrencyAppleIdentifier;
			break;

		case VirtualCurrencyGoogleIdentifier:
			fieldName = KEY_virtualCurrencyGoogleIdentifier;
			break;

		case VirtualCurrencyDescription:
			fieldName = KEY_virtualCurrencyDescription;
			break;

		case VirtualCurrencyPrice:
			fieldName = KEY_virtualCurrencyPrice;
			break;

		case VirtualCurrencyCredit:
			fieldName = KEY_virtualCurrencyCredit;
			break;

		case VirtualCurrencyKind:
			fieldName = KEY_virtualCurrencyKind;
			break;

		case VirtualCurrencyImageA:
			fieldName = KEY_virtualCurrencyImageA;
			break;

		case VirtualCurrencyImageB:
			fieldName = KEY_virtualCurrencyImageB;
			break;

		case VirtualCurrencyImageC:
			fieldName = KEY_virtualCurrencyImageC;
			break;

		case VirtualCurrencyIsDeal:
			fieldName = KEY_virtualCurrencyIsDeal;
			break;

		case VirtualCurrencyInAppleStore:
			fieldName = KEY_virtualCurrencyInAppleStore;
			break;

		case VirtualCurrencyInGoogleStore:
			fieldName = KEY_virtualCurrencyInGoogleStore;
			break;

		case VirtualCurrencyLastUpdate:
			fieldName = KEY_virtualCurrencyLastUpdate;
			break;

		default:
			NSLog(@"Wrong LiFields numerator for %@ Class",kClassName);
			fieldName = nil;
			break;
	}
	
	return fieldName;
}

+ (NSString *) getGeoFieldName:(LiFields)field{
	NSString *fieldName;
	
	switch (field) {
		case VirtualCurrency_None:
			fieldName = @"pos";
			break;
	
		default:
			NSLog(@"Wrong Geo LiFields numerator for %@ Class",kClassName);
			fieldName = nil;
			break;
	}
	
	return fieldName;
}


- (void) addValuesToRequest:(LiObjRequest **)request{
	[*request addValue:virtualCurrencyTitle forKey:KEY_virtualCurrencyTitle];
	[*request addValue:virtualCurrencyAppleIdentifier forKey:KEY_virtualCurrencyAppleIdentifier];
	[*request addValue:virtualCurrencyGoogleIdentifier forKey:KEY_virtualCurrencyGoogleIdentifier];
	[*request addValue:virtualCurrencyDescription forKey:KEY_virtualCurrencyDescription];
	[*request addFloatValue:virtualCurrencyPrice forKey:KEY_virtualCurrencyPrice];
	[*request addIntValue:virtualCurrencyCredit forKey:KEY_virtualCurrencyCredit];
	[*request addIntValue:virtualCurrencyKind forKey:KEY_virtualCurrencyKind];
	[*request addValue:virtualCurrencyImageA.absoluteString forKey:KEY_virtualCurrencyImageA];
	[*request addValue:virtualCurrencyImageB.absoluteString forKey:KEY_virtualCurrencyImageB];
	[*request addValue:virtualCurrencyImageC.absoluteString forKey:KEY_virtualCurrencyImageC];
	[*request addBoolValue:virtualCurrencyIsDeal forKey:KEY_virtualCurrencyIsDeal];
	[*request addBoolValue:virtualCurrencyInAppleStore forKey:KEY_virtualCurrencyInAppleStore];
	[*request addBoolValue:virtualCurrencyInGoogleStore forKey:KEY_virtualCurrencyInGoogleStore];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.virtualCurrencyID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyIDIndex])];
			self.virtualCurrencyTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyTitleIndex])];
			self.virtualCurrencyAppleIdentifier = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyAppleIdentifierIndex])];
			self.virtualCurrencyGoogleIdentifier = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyGoogleIdentifierIndex])];
			self.virtualCurrencyDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyDescriptionIndex])];
			self.virtualCurrencyPrice = sqlite3_column_double(stmt, array[0][VirtualCurrencyPriceIndex]);
			self.virtualCurrencyCredit = sqlite3_column_int(stmt, array[0][VirtualCurrencyCreditIndex]);
			self.virtualCurrencyKind = sqlite3_column_int(stmt, array[0][VirtualCurrencyKindIndex]);
			self.virtualCurrencyImageA = [NSURL URLWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyImageAIndex])]];
			self.virtualCurrencyImageB = [NSURL URLWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyImageBIndex])]];
			self.virtualCurrencyImageC = [NSURL URLWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyImageCIndex])]];
			self.virtualCurrencyIsDeal = sqlite3_column_int(stmt, array[0][VirtualCurrencyIsDealIndex]);
			self.virtualCurrencyInAppleStore = sqlite3_column_int(stmt, array[0][VirtualCurrencyInAppleStoreIndex]);
			self.virtualCurrencyInGoogleStore = sqlite3_column_int(stmt, array[0][VirtualCurrencyInGoogleStoreIndex]);
			virtualCurrencyLastUpdate = [[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualCurrencyLastUpdateIndex])]];
		
		}
	return self;
}

+ (NSArray *) getArrayFromStatement:(sqlite3_stmt *)stmt IDsList:(NSArray *)idsList resultFromServer:(BOOL)resultFromServer{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	NSMutableArray *columnsArray = [[NSMutableArray alloc] init];
	int columns = sqlite3_column_count(stmt);
	for (int i=0; i<columns; i++) {
		char *columnName = (char *)sqlite3_column_name(stmt, i);
		[columnsArray addObject:[NSString stringWithUTF8String:columnName]];
	}
	
	int **indexes = (int **)malloc(1*sizeof(int *));
	indexes[0] = (int *)malloc(NUM_OF_VIRTUALCURRENCY_FIELDS*sizeof(int));

	indexes[0][VirtualCurrencyIDIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyID];
	indexes[0][VirtualCurrencyTitleIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyTitle];
	indexes[0][VirtualCurrencyAppleIdentifierIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyAppleIdentifier];
	indexes[0][VirtualCurrencyGoogleIdentifierIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyGoogleIdentifier];
	indexes[0][VirtualCurrencyDescriptionIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyDescription];
	indexes[0][VirtualCurrencyPriceIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyPrice];
	indexes[0][VirtualCurrencyCreditIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyCredit];
	indexes[0][VirtualCurrencyKindIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyKind];
	indexes[0][VirtualCurrencyImageAIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyImageA];
	indexes[0][VirtualCurrencyImageBIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyImageB];
	indexes[0][VirtualCurrencyImageCIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyImageC];
	indexes[0][VirtualCurrencyIsDealIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyIsDeal];
	indexes[0][VirtualCurrencyInAppleStoreIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyInAppleStore];
	indexes[0][VirtualCurrencyInGoogleStoreIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyInGoogleStore];
	indexes[0][VirtualCurrencyLastUpdateIndex] = [columnsArray indexOfObject:KEY_virtualCurrencyLastUpdate];

	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][VirtualCurrencyIDIndex])];
		if (resultFromServer && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			VirtualCurrency *item  = [[VirtualCurrency alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
			[result addObject:item];
		}
	}

	[LiObjRequest removeIDsList:blackList FromObject:kClassName];
	
	for (int i=0; i<1; i++) {
		free(indexes[i]);
	}
	free(indexes);
	
	return result;
}


#pragma mark - End of Basic SDK

+ (void) getVirtualCurrenciesWithBlock:(GetVirtualCurrencyArrayFinished)block{
    block(nil,[LiKitIAP virtualCurrencies]);
}

static LiBlockAction actionBlock = NULL;
- (void) buyVirtualCurrencyWithBlock:(LiBlockAction)block{
    actionBlock = (__bridge LiBlockAction)CFBridgingRetain(block);
    [LiKitIAP purchaseVirtualCurrency:self Delegate:self];
}

+ (void) giveAmount:(NSInteger)amount ofCurrencyKind:(LiCurrency)currencyKind withBlock:(LiBlockAction)block{
    NSError *error = nil;
    [LiKitIAP giveAmount:amount CurrencyKind:currencyKind WithError:&error];
    block(error,nil,DoIapAction);
}

+ (void) useAmount:(NSInteger)amount OfCurrencyKind:(LiCurrency)currencyKind withBlock:(LiBlockAction)block{
    NSError *error = nil;
    [LiKitIAP useAmount:amount CurrencyKind:currencyKind WithError:&error];
    block(error,nil,DoIapAction);
}

- (void) InAppPurchase_AppStorePurchase:(VirtualCurrency *)item ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
    actionBlock(error,item.virtualCurrencyID,DoIapAction);
	actionBlock = NULL;
}

#pragma mark - Get Array

+ (void) getArrayWithQuery:(LiQuery *)query WithBlock:(GetVirtualCurrencyArrayFinished)block{
	VirtualCurrency *item = [VirtualCurrency instance];

	query = [self setFieldsNameToQuery:query];
	LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:(__bridge void *)(block)];
    [request addIntValue:LOCAL forKey:@"DbGetKind"];
	[request setDelegate:item];
	[request addValue:query forKey:@"query"];
    request.shouldWorkOffline = YES;
    
    [request startSync:YES];
    
    [item requestDidFinished:request];
}

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetVirtualCurrencyArrayFinished)block{
    VirtualCurrency *item = [VirtualCurrency instance];
        
    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:(__bridge void *)(block)];
	[request addValue:rawQuery forKey:@"filters"];
	[request setShouldWorkOffline:YES];
	[request startSync:YES];
    
	[item requestDidFinished:request];
}


#pragma mark - Applicasa Delegate Methods

- (void) requestDidFinished:(LiObjRequest *)request{
    Actions action = request.action;
    NSInteger responseType = request.response.responseType;
    NSString *responseMessage = request.response.responseMessage;
    NSDictionary *responseData = request.response.responseData;
    
    switch (action) {

	case GetArray:{
		sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
        NSArray *idsList = [responseData objectForKey:@"ids"];
        [self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[VirtualCurrency getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer] Block:[request getBlock]];
		[request releaseBlock];
		}
        break;
	default:
		break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    VirtualCurrency *instace = [[VirtualCurrency alloc] init];
    instace.virtualCurrencyID = ID;
    return instace;
}

#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
 
    GetVirtualCurrencyArrayFinished _block = (__bridge GetVirtualCurrencyArrayFinished)block;
    _block(error,array);
}

#pragma mark - Deprecated Methods
/*********************************************************************************
 DEPRECATED METHODS:
 
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the next release. You should update your code immediately.
 **********************************************************************************/

+ (void) getAllVirtualCurrencyWithBlock:(GetVirtualCurrencyArrayFinished)block {
    [self getVirtualCurrenciesWithBlock:block];
}
+ (void) giveVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block {
    [self giveAmount:amount ofCurrencyKind:currencyKind withBlock:block];
}
+ (void) useVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block {
    [self useAmount:amount OfCurrencyKind:currencyKind withBlock:block];
}

@end
