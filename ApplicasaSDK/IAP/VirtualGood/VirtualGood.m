//
// VirtualGood.m
// Created by Applicasa 
// 11/8/2012
//

#import "VirtualGood.h"
#import "VirtualGoodCategory.h"

#define kClassName                  @"VirtualGood"

#define KEY_virtualGoodID				@"VirtualGoodID"
#define KEY_virtualGoodTitle				@"VirtualGoodTitle"
#define KEY_virtualGoodDescription				@"VirtualGoodDescription"
#define KEY_virtualGoodMainCurrency				@"VirtualGoodMainCurrency"
#define KEY_virtualGoodSecondaryCurrency				@"VirtualGoodSecondaryCurrency"
#define KEY_virtualGoodRelatedVirtualGood				@"VirtualGoodRelatedVirtualGood"
#define KEY_virtualGoodQuantity				@"VirtualGoodQuantity"
#define KEY_virtualGoodMaxForUser				@"VirtualGoodMaxForUser"
#define KEY_virtualGoodUserInventory				@"VirtualGoodUserInventory"
#define KEY_virtualGoodImageA				@"VirtualGoodImageA"
#define KEY_virtualGoodImageB				@"VirtualGoodImageB"
#define KEY_virtualGoodImageC				@"VirtualGoodImageC"
#define KEY_virtualGoodIsDeal				@"VirtualGoodIsDeal"
#define KEY_virtualGoodConsumable				@"VirtualGoodConsumable"
#define KEY_virtualGoodLastUpdate				@"VirtualGoodLastUpdate"
#define KEY_virtualGoodMainCategory				@"VirtualGoodMainCategory"

@interface VirtualGood (privateMethods)

- (void) updateField:(LiFields)field Value:(NSNumber *)value;
- (void) setField:(LiFields)field WithValue:(id)value;

@end

@implementation VirtualGood

@synthesize virtualGoodID;
@synthesize virtualGoodTitle;
@synthesize virtualGoodDescription;
@synthesize virtualGoodMainCurrency;
@synthesize virtualGoodSecondaryCurrency;
@synthesize virtualGoodRelatedVirtualGood;
@synthesize virtualGoodQuantity;
@synthesize virtualGoodMaxForUser;
@synthesize virtualGoodUserInventory;
@synthesize virtualGoodImageA;
@synthesize virtualGoodImageB;
@synthesize virtualGoodImageC;
@synthesize virtualGoodIsDeal;
@synthesize virtualGoodConsumable;
@synthesize virtualGoodLastUpdate;
@synthesize virtualGoodMainCategory;

enum VirtualGoodIndexes {
	VirtualGoodIDIndex = 0,
	VirtualGoodTitleIndex,
	VirtualGoodDescriptionIndex,
	VirtualGoodMainCurrencyIndex,
	VirtualGoodSecondaryCurrencyIndex,
	VirtualGoodRelatedVirtualGoodIndex,
	VirtualGoodQuantityIndex,
	VirtualGoodMaxForUserIndex,
	VirtualGoodUserInventoryIndex,
	VirtualGoodImageAIndex,
	VirtualGoodImageBIndex,
	VirtualGoodImageCIndex,
	VirtualGoodMainCategoryIndex,
	VirtualGoodIsDealIndex,
	VirtualGoodConsumableIndex,
	VirtualGoodLastUpdateIndex,
};
#define NUM_OF_VIRTUALGOOD_FIELDS 16

enum VirtualGoodCategoryIndexes {
	VirtualGoodCategoryIDIndex = 0,
	VirtualGoodCategoryNameIndex,
	VirtualGoodCategoryLastUpdateIndex,
};
#define NUM_OF_VIRTUALGOODCATEGORY_FIELDS 3


#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldVirtualGoodWorkOffline;

	[request setBlock:block];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.virtualGoodID]){
		request.action = Update;
		[request addValue:virtualGoodID forKey:KEY_virtualGoodID];
		if (self.increaseDictionary.count){
			[request.requestParameters setValue:self.increaseDictionary forKey:@"$inc"];
			self.increaseDictionary = nil;
		}
	} 	else {
		[self respondToLiActionCallBack:1023 ResponseMessage:@"Attempt to add VirtualGood instance" ItemID:@"0" Action:Add Block:block];
		return;
	}	
	request.delegate = self;
	[request startSync:FALSE];
}

- (void) updateField:(LiFields)field Value:(NSNumber *)value{
	switch (field) {
		case VirtualGoodMainCurrency:
			virtualGoodMainCurrency += [value intValue];
			break;
		case VirtualGoodSecondaryCurrency:
			virtualGoodSecondaryCurrency += [value intValue];
			break;
		case VirtualGoodQuantity:
			virtualGoodQuantity += [value intValue];
			break;
		case VirtualGoodMaxForUser:
			virtualGoodMaxForUser += [value intValue];
			break;
		case VirtualGoodUserInventory:
			virtualGoodUserInventory += [value intValue];
			break;
		default:
			break;
	}
}


- (void) setField:(LiFields)field WithValue:(id)value{
	switch (field) {
	case VirtualGoodID:
		self.virtualGoodID = value;
		break;
	case VirtualGoodTitle:
		self.virtualGoodTitle = value;
		break;
	case VirtualGoodDescription:
		self.virtualGoodDescription = value;
		break;
	case VirtualGoodMainCurrency:
		self.virtualGoodMainCurrency = [value intValue];
		break;
	case VirtualGoodSecondaryCurrency:
		self.virtualGoodSecondaryCurrency = [value intValue];
		break;
	case VirtualGoodRelatedVirtualGood:
		self.virtualGoodRelatedVirtualGood = value;
		break;
	case VirtualGoodQuantity:
		self.virtualGoodQuantity = [value intValue];
		break;
	case VirtualGoodMaxForUser:
		self.virtualGoodMaxForUser = [value intValue];
		break;
	case VirtualGoodUserInventory:
		self.virtualGoodUserInventory = [value intValue];
		break;
	case VirtualGoodImageA:
		self.virtualGoodImageA = value;
		break;
	case VirtualGoodImageB:
		self.virtualGoodImageB = value;
		break;
	case VirtualGoodImageC:
		self.virtualGoodImageC = value;
		break;
	case VirtualGoodMainCategory:
		self.virtualGoodMainCategory = value;
		break;
	case VirtualGoodIsDeal:
		self.virtualGoodIsDeal = [value boolValue];
		break;
	case VirtualGoodConsumable:
		self.virtualGoodConsumable = [value boolValue];
		break;
	default:
	break;
	}
}


# pragma mark - Memory Management

- (void) dealloc
{
	[virtualGoodID release];
	[virtualGoodTitle release];
	[virtualGoodDescription release];
	[virtualGoodRelatedVirtualGood release];
	[virtualGoodImageA release];
	[virtualGoodImageB release];
	[virtualGoodImageC release];
	[virtualGoodLastUpdate release];
	[virtualGoodMainCategory release];


	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
- (id) init {
	if (self = [super init]) {

		self.virtualGoodID				= @"0";		self.virtualGoodTitle				= @"";
		self.virtualGoodDescription				= @"";
		self.virtualGoodMainCurrency				= 0;
		self.virtualGoodSecondaryCurrency				= 0;
		self.virtualGoodRelatedVirtualGood				= @"";
		self.virtualGoodQuantity				= 0;
		self.virtualGoodMaxForUser				= 0;
		self.virtualGoodUserInventory				= 0;
		self.virtualGoodImageA				= [NSURL URLWithString:@""];
		self.virtualGoodImageB				= [NSURL URLWithString:@""];
		self.virtualGoodImageC				= [NSURL URLWithString:@""];
		self.virtualGoodIsDeal				= false;
		self.virtualGoodConsumable				= true;
		virtualGoodLastUpdate				= [[[[NSDate alloc] initWithTimeIntervalSince1970:0] autorelease] retain];
self.virtualGoodMainCategory    = [VirtualGoodCategory instanceWithID:@"0"];
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
		self.virtualGoodID               = [item objectForKey:KeyWithHeader(KEY_virtualGoodID, header)];
		self.virtualGoodTitle               = [item objectForKey:KeyWithHeader(KEY_virtualGoodTitle, header)];
		self.virtualGoodDescription               = [item objectForKey:KeyWithHeader(KEY_virtualGoodDescription, header)];
		self.virtualGoodMainCurrency               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodMainCurrency, header)] integerValue];
		self.virtualGoodSecondaryCurrency               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodSecondaryCurrency, header)] integerValue];
		self.virtualGoodRelatedVirtualGood               = [item objectForKey:KeyWithHeader(KEY_virtualGoodRelatedVirtualGood, header)];
		self.virtualGoodQuantity               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodQuantity, header)] integerValue];
		self.virtualGoodMaxForUser               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodMaxForUser, header)] integerValue];
		self.virtualGoodUserInventory               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodUserInventory, header)] integerValue];
		self.virtualGoodImageA               = [NSURL URLWithString:[item objectForKey:KeyWithHeader(KEY_virtualGoodImageA, header)]];
		self.virtualGoodImageB               = [NSURL URLWithString:[item objectForKey:KeyWithHeader(KEY_virtualGoodImageB, header)]];
		self.virtualGoodImageC               = [NSURL URLWithString:[item objectForKey:KeyWithHeader(KEY_virtualGoodImageC, header)]];
		self.virtualGoodIsDeal               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodIsDeal, header)] boolValue];
		self.virtualGoodConsumable               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodConsumable, header)] boolValue];
		virtualGoodLastUpdate               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodLastUpdate, header)] retain];
		virtualGoodMainCategory               = [[VirtualGoodCategory alloc] initWithDictionary:item Header:KeyWithHeader
	(@"_",KEY_virtualGoodMainCategory)];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(VirtualGood *)object {
	if (self = [super init]) {

		self.virtualGoodID               = object.virtualGoodID;
		self.virtualGoodTitle               = object.virtualGoodTitle;
		self.virtualGoodDescription               = object.virtualGoodDescription;
		self.virtualGoodMainCurrency               = object.virtualGoodMainCurrency;
		self.virtualGoodSecondaryCurrency               = object.virtualGoodSecondaryCurrency;
		self.virtualGoodRelatedVirtualGood               = object.virtualGoodRelatedVirtualGood;
		self.virtualGoodQuantity               = object.virtualGoodQuantity;
		self.virtualGoodMaxForUser               = object.virtualGoodMaxForUser;
		self.virtualGoodUserInventory               = object.virtualGoodUserInventory;
		self.virtualGoodImageA               = object.virtualGoodImageA;
		self.virtualGoodImageB               = object.virtualGoodImageB;
		self.virtualGoodImageC               = object.virtualGoodImageC;
		self.virtualGoodIsDeal               = object.virtualGoodIsDeal;
		self.virtualGoodConsumable               = object.virtualGoodConsumable;
		virtualGoodLastUpdate               = [object.virtualGoodLastUpdate retain];
		virtualGoodMainCategory               = [[VirtualGoodCategory alloc] initWithObject:object.virtualGoodMainCategory];

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:virtualGoodID forKey:KEY_virtualGoodID];
	[dictionary addValue:virtualGoodTitle forKey:KEY_virtualGoodTitle];
	[dictionary addValue:virtualGoodDescription forKey:KEY_virtualGoodDescription];
	[dictionary addIntValue:virtualGoodMainCurrency forKey:KEY_virtualGoodMainCurrency];
	[dictionary addIntValue:virtualGoodSecondaryCurrency forKey:KEY_virtualGoodSecondaryCurrency];
	[dictionary addValue:virtualGoodRelatedVirtualGood forKey:KEY_virtualGoodRelatedVirtualGood];
	[dictionary addIntValue:virtualGoodQuantity forKey:KEY_virtualGoodQuantity];
	[dictionary addIntValue:virtualGoodMaxForUser forKey:KEY_virtualGoodMaxForUser];
	[dictionary addIntValue:virtualGoodUserInventory forKey:KEY_virtualGoodUserInventory];
	[dictionary addValue:virtualGoodImageA.absoluteString forKey:KEY_virtualGoodImageA];	[dictionary addValue:virtualGoodImageB.absoluteString forKey:KEY_virtualGoodImageB];	[dictionary addValue:virtualGoodImageC.absoluteString forKey:KEY_virtualGoodImageC];	[dictionary addBoolValue:virtualGoodIsDeal forKey:KEY_virtualGoodIsDeal];
	[dictionary addBoolValue:virtualGoodConsumable forKey:KEY_virtualGoodConsumable];
	[dictionary addDateValue:virtualGoodLastUpdate forKey:KEY_virtualGoodLastUpdate];
	[dictionary addForeignKeyValue:virtualGoodMainCategory.dictionaryRepresentation forKey:KEY_virtualGoodMainCategory];

	return [dictionary autorelease];
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_virtualGoodID];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodTitle];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodDescription];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualGoodMainCurrency];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualGoodSecondaryCurrency];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodRelatedVirtualGood];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualGoodQuantity];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualGoodMaxForUser];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualGoodUserInventory];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodImageA];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodImageB];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodImageC];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"'0'") forKey:KEY_virtualGoodMainCategory];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_virtualGoodIsDeal];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"1") forKey:KEY_virtualGoodConsumable];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_virtualGoodLastUpdate];
	[fieldsDic setValue:kTEXT_TYPE forKey:@"Security"];
	
	return [fieldsDic autorelease];
}

+ (NSDictionary *) getForeignKeys{
	NSMutableDictionary *foreignKeysDic = [[NSMutableDictionary alloc] init];

	[foreignKeysDic setValue:[VirtualGoodCategory getClassName] forKey:KEY_virtualGoodMainCategory];
	
	return [foreignKeysDic autorelease];
}

+ (NSString *) getClassName{
	return kClassName;
}

+ (NSString *) getFieldName:(LiFields)field{
	NSString *fieldName;
	
	switch (field) {
		case VirtualGood_None:
			fieldName = @"pos";
			break;
	
		case VirtualGoodID:
			fieldName = KEY_virtualGoodID;
			break;

		case VirtualGoodTitle:
			fieldName = KEY_virtualGoodTitle;
			break;

		case VirtualGoodDescription:
			fieldName = KEY_virtualGoodDescription;
			break;

		case VirtualGoodMainCurrency:
			fieldName = KEY_virtualGoodMainCurrency;
			break;

		case VirtualGoodSecondaryCurrency:
			fieldName = KEY_virtualGoodSecondaryCurrency;
			break;

		case VirtualGoodRelatedVirtualGood:
			fieldName = KEY_virtualGoodRelatedVirtualGood;
			break;

		case VirtualGoodQuantity:
			fieldName = KEY_virtualGoodQuantity;
			break;

		case VirtualGoodMaxForUser:
			fieldName = KEY_virtualGoodMaxForUser;
			break;

		case VirtualGoodUserInventory:
			fieldName = KEY_virtualGoodUserInventory;
			break;

		case VirtualGoodImageA:
			fieldName = KEY_virtualGoodImageA;
			break;

		case VirtualGoodImageB:
			fieldName = KEY_virtualGoodImageB;
			break;

		case VirtualGoodImageC:
			fieldName = KEY_virtualGoodImageC;
			break;

		case VirtualGoodIsDeal:
			fieldName = KEY_virtualGoodIsDeal;
			break;

		case VirtualGoodConsumable:
			fieldName = KEY_virtualGoodConsumable;
			break;

		case VirtualGoodLastUpdate:
			fieldName = KEY_virtualGoodLastUpdate;
			break;

		case VirtualGoodMainCategory:
			fieldName = KEY_virtualGoodMainCategory;
			break;

		default:
			NSLog(@"Wrong LiField numerator for %@ Class",kClassName);
			fieldName = @"";
			break;
	}
	
	return fieldName;
}


- (void) addValuesToRequest:(LiObjRequest **)request{
	[*request addValue:virtualGoodTitle forKey:KEY_virtualGoodTitle];
	[*request addValue:virtualGoodDescription forKey:KEY_virtualGoodDescription];
	[*request addIntValue:virtualGoodMainCurrency forKey:KEY_virtualGoodMainCurrency];
	[*request addIntValue:virtualGoodSecondaryCurrency forKey:KEY_virtualGoodSecondaryCurrency];
	[*request addValue:virtualGoodRelatedVirtualGood forKey:KEY_virtualGoodRelatedVirtualGood];
	[*request addIntValue:virtualGoodQuantity forKey:KEY_virtualGoodQuantity];
	[*request addIntValue:virtualGoodMaxForUser forKey:KEY_virtualGoodMaxForUser];
	[*request addIntValue:virtualGoodUserInventory forKey:KEY_virtualGoodUserInventory];
	[*request addValue:virtualGoodImageA.absoluteString forKey:KEY_virtualGoodImageA];
	[*request addValue:virtualGoodImageB.absoluteString forKey:KEY_virtualGoodImageB];
	[*request addValue:virtualGoodImageC.absoluteString forKey:KEY_virtualGoodImageC];
	[*request addBoolValue:virtualGoodIsDeal forKey:KEY_virtualGoodIsDeal];
	[*request addBoolValue:virtualGoodConsumable forKey:KEY_virtualGoodConsumable];
	[*request addValue:virtualGoodMainCategory.virtualGoodCategoryID forKey:KEY_virtualGoodMainCategory];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.virtualGoodID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodIDIndex])];
			self.virtualGoodTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodTitleIndex])];
			self.virtualGoodDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodDescriptionIndex])];
			self.virtualGoodMainCurrency = sqlite3_column_int(stmt, array[0][VirtualGoodMainCurrencyIndex]);
			self.virtualGoodSecondaryCurrency = sqlite3_column_int(stmt, array[0][VirtualGoodSecondaryCurrencyIndex]);
			self.virtualGoodRelatedVirtualGood = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodRelatedVirtualGoodIndex])];
			self.virtualGoodQuantity = sqlite3_column_int(stmt, array[0][VirtualGoodQuantityIndex]);
			self.virtualGoodMaxForUser = sqlite3_column_int(stmt, array[0][VirtualGoodMaxForUserIndex]);
			self.virtualGoodUserInventory = sqlite3_column_int(stmt, array[0][VirtualGoodUserInventoryIndex]);
			self.virtualGoodImageA = [NSURL URLWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodImageAIndex])]];
			self.virtualGoodImageB = [NSURL URLWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodImageBIndex])]];
			self.virtualGoodImageC = [NSURL URLWithString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodImageCIndex])]];

	if (isFK){
		self.virtualGoodMainCategory = [VirtualGoodCategory instanceWithID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodMainCategoryIndex])]];
	} else {
		int **virtualGoodMainCategoryArray = (int **)malloc(sizeof(int *));
		virtualGoodMainCategoryArray[0] = array[1];
		self.virtualGoodMainCategory = [[[VirtualGoodCategory alloc] initWithStatement:stmt Array:virtualGoodMainCategoryArray IsFK:TRUE] autorelease];
		free(virtualGoodMainCategoryArray);
	}

;
			self.virtualGoodIsDeal = sqlite3_column_int(stmt, array[0][VirtualGoodIsDealIndex]);
			self.virtualGoodConsumable = sqlite3_column_int(stmt, array[0][VirtualGoodConsumableIndex]);
			virtualGoodLastUpdate = [[[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodLastUpdateIndex])]] retain];
		
		}
	return self;
}

+ (NSArray *) getArrayFromStatement:(sqlite3_stmt *)stmt IDsList:(NSArray *)idsList{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	NSMutableArray *columnsArray = [[NSMutableArray alloc] init];
	int columns = sqlite3_column_count(stmt);
	for (int i=0; i<columns; i++) {
		char *columnName = (char *)sqlite3_column_name(stmt, i);
		[columnsArray addObject:[NSString stringWithUTF8String:columnName]];
	}
	
	int **indexes = (int **)malloc(2*sizeof(int *));
	indexes[0] = (int *)malloc(NUM_OF_VIRTUALGOOD_FIELDS*sizeof(int));
	indexes[1] = (int *)malloc(NUM_OF_VIRTUALGOODCATEGORY_FIELDS*sizeof(int));

	indexes[0][VirtualGoodIDIndex] = [columnsArray indexOfObject:KEY_virtualGoodID];
	indexes[0][VirtualGoodTitleIndex] = [columnsArray indexOfObject:KEY_virtualGoodTitle];
	indexes[0][VirtualGoodDescriptionIndex] = [columnsArray indexOfObject:KEY_virtualGoodDescription];
	indexes[0][VirtualGoodMainCurrencyIndex] = [columnsArray indexOfObject:KEY_virtualGoodMainCurrency];
	indexes[0][VirtualGoodSecondaryCurrencyIndex] = [columnsArray indexOfObject:KEY_virtualGoodSecondaryCurrency];
	indexes[0][VirtualGoodRelatedVirtualGoodIndex] = [columnsArray indexOfObject:KEY_virtualGoodRelatedVirtualGood];
	indexes[0][VirtualGoodQuantityIndex] = [columnsArray indexOfObject:KEY_virtualGoodQuantity];
	indexes[0][VirtualGoodMaxForUserIndex] = [columnsArray indexOfObject:KEY_virtualGoodMaxForUser];
	indexes[0][VirtualGoodUserInventoryIndex] = [columnsArray indexOfObject:KEY_virtualGoodUserInventory];
	indexes[0][VirtualGoodImageAIndex] = [columnsArray indexOfObject:KEY_virtualGoodImageA];
	indexes[0][VirtualGoodImageBIndex] = [columnsArray indexOfObject:KEY_virtualGoodImageB];
	indexes[0][VirtualGoodImageCIndex] = [columnsArray indexOfObject:KEY_virtualGoodImageC];
	indexes[0][VirtualGoodMainCategoryIndex] = [columnsArray indexOfObject:KEY_virtualGoodMainCategory];
	indexes[0][VirtualGoodIsDealIndex] = [columnsArray indexOfObject:KEY_virtualGoodIsDeal];
	indexes[0][VirtualGoodConsumableIndex] = [columnsArray indexOfObject:KEY_virtualGoodConsumable];
	indexes[0][VirtualGoodLastUpdateIndex] = [columnsArray indexOfObject:KEY_virtualGoodLastUpdate];

	indexes[1][VirtualGoodCategoryIDIndex] = [columnsArray indexOfObject:KeyWithHeader(@"VirtualGoodCategoryID",@"_VirtualGoodMainCategory")];
	indexes[1][VirtualGoodCategoryNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"VirtualGoodCategoryName",@"_VirtualGoodMainCategory")];
	indexes[1][VirtualGoodCategoryLastUpdateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"VirtualGoodCategoryLastUpdate",@"_VirtualGoodMainCategory")];

	[columnsArray release];
	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][VirtualGoodIDIndex])];
		if (idsList.count && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			VirtualGood *item  = [[VirtualGood alloc] initWithStatement:stmt Array:(int **)indexes IsFK:FALSE];
			[result addObject:item];
			[item release];
		}
	}

	[LiObjRequest removeIDsList:blackList FromObject:kClassName];
	[blackList release];
	
	for (int i=0; i<2; i++) {
		free(indexes[i]);
	}
	free(indexes);
	
	return [result autorelease];
}


#pragma mark - End of Basic SDK

#pragma mark - Get Array

+ (void) getArrayWithQuery:(LiQuery *)query WithBlock:(GetVirtualGoodArrayFinished)block{
    VirtualGood *item = [VirtualGood instance];
     
    query = [self setFieldsNameToQuery:query];
    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:block];
    [request addIntValue:LOCAL forKey:@"DbGetKind"];
    [request setDelegate:item];
    [request addValue:query forKey:@"query"];
    request.shouldWorkOffline = TRUE;
    
    [request startSync:TRUE];
    
    [item requestDidFinished:request];
}

+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetVirtualGoodArrayFinished)block{
    VirtualGood *item = [VirtualGood instance];
    
    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:block];
    [request addValue:rawQuery forKey:@"filters"];
    [request setShouldWorkOffline:TRUE];
    [request startSync:TRUE];
    
    [item requestDidFinished:request];
}  	

+ (void) getAllVirtualGoodByType:(VirutalGoodGetTypes)type WithBlock:(GetVirtualGoodArrayFinished)block{
    [self getAllVirtualGoodByType:type ByCategory:nil WithBlock:block];
}

+ (void) getAllVirtualGoodByType:(VirutalGoodGetTypes)type ByCategory:(VirtualGoodCategory *)category WithBlock:(GetVirtualGoodArrayFinished)block{
    NSString *predicateString = @"";
    NSArray *result = [LiKitIAP virtualGoods];
    if (category)
        predicateString = [predicateString stringByAppendingFormat:@"%@ = %@",KEY_virtualGoodMainCategory,category.virtualGoodCategoryID];
    
    NSString *andString = @"";
    if (predicateString.length)
        andString =  @" AND ";
    
    
    switch (type) {
        case Just_0_Quantity:
            predicateString = [predicateString stringByAppendingFormat:@"%@ %@ = 0",andString,@"virtualGoodUserInventory"];
            break;
        case Non_0_Quantity:
            predicateString = [predicateString stringByAppendingFormat:@"%@ %@ > 0",andString,@"virtualGoodUserInventory"];
            break;
        default:
            break;
    }
    if (predicateString.length)
        result = [result filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]];
    
    block(nil,result);
}

- (void) buyVirtualGoodWithQuantity:(NSInteger)quantity CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block{
    NSError *error = nil;
    [LiKitIAP purchaseVirtualGood:self Quantity:quantity CurrencyKind:currencyKind WithError:&error];
    block(error,virtualGoodID,DoIapAction);
}

- (void) giveVirtualGoodWithQuantity:(NSInteger)quantity WithBlock:(LiBlockAction)block{
    NSError *error = nil;
    [LiKitIAP giveVirtualGood:self Quantity:quantity WithError:&error];
    block(error,virtualGoodID,DoIapAction);
    
}

- (void) useWithQuantity:(NSInteger)quantity WithBlock:(LiBlockAction)block{
    NSError *error = nil;
    [LiKitIAP useVirtualGood:self Quantity:quantity WithError:&error];
    block(error,virtualGoodID,DoIapAction);
}


/*
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
*/
#pragma mark - Applicasa Delegate Methods

- (void) requestDidFinished:(LiObjRequest *)request{
    Actions action = request.action;
    NSInteger responseType = request.response.responseType;
    NSString *responseMessage = request.response.responseMessage;
    NSDictionary *responseData = request.response.responseData;
    
    switch (action) {
        case UploadFile:{
            LiFields fileField = [[request.requestParameters objectForKey:@"fileField"] intValue];
			[self setField:fileField WithValue:[responseData objectForKey:kResult]];			
        }
        case Add:
        case Update:
        case Delete:{
            NSString *itemID = [responseData objectForKey:KEY_virtualGoodID];
            if (itemID)
                self.virtualGoodID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self. virtualGoodID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{
            
   			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
            [self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[VirtualGood getArrayFromStatement:stmt IDsList:idsList] Block:[request getBlock]];
			[request releaseBlock];

        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    VirtualGood *instace = [[VirtualGood alloc] init];
    instace.virtualGoodID = ID;
    return [instace autorelease];
}

#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetVirtualGoodArrayFinished _block = (GetVirtualGoodArrayFinished)block;
    _block(error,array);
}

+ (LiFilters *) replaceFilterField:(LiFilters *)filter{
    if ([filter isKindOfClass:[LiComplexFilters class]]){
        LiComplexFilters *complexFilter = (LiComplexFilters *)filter;
        complexFilter.operandA = [self replaceFilterField:complexFilter.operandA];
        complexFilter.operandB = [self replaceFilterField:complexFilter.operandB];
        return complexFilter;
    } else{
        if (filter.field){
            LiFields field = [filter.field intValue];
            filter.field = [VirtualGood getFieldName:field];
        }
        return filter;
    }    
}

+ (NSMutableArray *) replaceOrderArrayField:(NSMutableArray *)orderArray{
    for (int i=0; i<orderArray.count; i++) {
        LiObjOrder *order = [orderArray objectAtIndex:i];
        order.sortField = [VirtualGood getFieldName:[order.sortField intValue]];
        [orderArray replaceObjectAtIndex:i withObject:order];
    }
    return orderArray;
}

+ (LiQuery *) setFieldsNameToQuery:(LiQuery *)query{
    query.filters = [self replaceFilterField:query.filters];
    query.orderArray = [self replaceOrderArrayField:query.orderArray];
	query.geoFilter = [self replaceFilterField:query.geoFilter];
    return query;
}

@end
