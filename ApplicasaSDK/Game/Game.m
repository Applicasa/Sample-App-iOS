//
// Game.m
// Created by Applicasa 
// 09/12/2012
//

#import "Game.h"
#import "User.h"
#import "User.h"

#define kClassName                  @"Game"

#define KEY_gameID				@"GameID"
#define KEY_gameLastUpdate				@"GameLastUpdate"
#define KEY_gameNumOfChips				@"GameNumOfChips"
#define KEY_gameName				@"GameName"
#define KEY_gamePlayerOne				@"GamePlayerOne"
#define KEY_gamePlayerTwo				@"GamePlayerTwo"

@interface Game (privateMethods)

- (void) updateField:(LiFields)field withValue:(NSNumber *)value;
- (void) updateField:(LiFields)field Value:(NSNumber *)value DEPRECATED_ATTRIBUTE;
- (void) setField:(LiFields)field toValue:(id)value;
- (void) setField:(LiFields)field WithValue:(id)value DEPRECATED_ATTRIBUTE;

@end

@implementation Game

@synthesize gameID;
@synthesize gameLastUpdate;
@synthesize gameNumOfChips;
@synthesize gameName;
@synthesize gamePlayerOne;
@synthesize gamePlayerTwo;

enum GameIndexes {
	GameIDIndex = 0,
	GameLastUpdateIndex,
	GameNumOfChipsIndex,
	GamePlayerOneIndex,
	GamePlayerTwoIndex,
	GameNameIndex,};
#define NUM_OF_GAME_FIELDS 6

enum UserIndexes {
	UserIDIndex = 0,
	UserNameIndex,
	UserFirstNameIndex,
	UserLastNameIndex,
	UserEmailIndex,
	UserPhoneIndex,
	UserPasswordIndex,
	UserLastLoginIndex,
	UserRegisterDateIndex,
	UserLocationLatIndex,
	UserLocationLongIndex,
	UserIsRegisteredFacebookIndex,
	UserIsRegisteredIndex,
	UserLastUpdateIndex,
	UserFacebookIDIndex,
	UserImageIndex,
	UserMainCurrencyBalanceIndex,
	UserSecondaryCurrencyBalanceIndex,
	UserTempDateIndex,};
#define NUM_OF_USER_FIELDS 19


#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldGameWorkOffline;

	[request setBlock:block];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.gameID]){
		request.action = Update;
		[request addValue:gameID forKey:KEY_gameID];
		if (self.increaseDictionary.count){
			[request.requestParameters setValue:self.increaseDictionary forKey:@"$inc"];
			self.increaseDictionary = nil;
		}
	} 	
	request.delegate = self;
	[request startSync:NO];
}

- (void) updateField:(LiFields)field withValue:(NSNumber *)value{
	switch (field) {
		case GameNumOfChips:
			gameNumOfChips += [value intValue];
			break;
		default:
			break;
	}
}

#pragma mark - Increase

- (void) increaseField:(LiFields)field byValue:(NSNumber *)value{
    if (!self.increaseDictionary)
        self.increaseDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [self.increaseDictionary setValue:value forKey:[[self class] getFieldName:field]];
    [self updateField:field withValue:value];
}

#pragma mark - Delete

- (void) deleteWithBlock:(LiBlockAction)block{        
    LiObjRequest *request = [LiObjRequest requestWithAction:Delete ClassName:kClassName];
	request.shouldWorkOffline = kShouldGameWorkOffline;
	[request setBlock:block];
    request.delegate = self;
    [request addValue:gameID forKey:KEY_gameID];
    [request startSync:NO];    
}

#pragma mark - Get By ID

+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetGameFinished)block{
    __block Game *item = [Game instance];

    LiFilters *filters = [LiBasicFilters filterByField:GameID Operator:Equal Value:idString];
    LiQuery *query = [[LiQuery alloc]init];
    [query setFilters:filters];
    
    [self getArrayWithQuery:query queryKind:queryKind withBlock:^(NSError *error, NSArray *array) {
        item = nil;
        if (array.count)
            item = [array objectAtIndex:0];
        block(error,item);
    }];	
    [query release];
}


#pragma mark - Get Array

+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetGameArrayFinished)block{
    Game *item = [Game instance];
    
 query = [self setFieldsNameToQuery:query];
    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
 [request setBlock:block];
    [request addIntValue:queryKind forKey:@"DbGetKind"];
    [request setDelegate:item];
    [request addValue:query forKey:@"query"];
    request.shouldWorkOffline = (queryKind == LOCAL);
    
    [request startSync:(queryKind == LOCAL)];
    
    if (queryKind == LOCAL)
        [item requestDidFinished:request];
}

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetGameArrayFinished)block{
    Game *item = [Game instance];

    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:block];
    [request addValue:rawQuery forKey:@"filters"];
    [request setShouldWorkOffline:YES];
    [request startSync:YES];
    
    [item requestDidFinished:request];
}

#pragma mark - Upload File

- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block{

    LiObjRequest *request = [LiObjRequest requestWithAction:UploadFile ClassName:kClassName];
    request.delegate = self;

	[request addValue:gameID forKey:KEY_gameID];
    [request addValue:ext forKey:@"ext"];
    [request addValue:data forKey:@"data"];
    [request addIntValue:fileType forKey:@"fileType"];
	[request addIntValue:field forKey:@"fileField"];
    [request addValue:[[self class] getFieldName:field] forKey:@"field"];
	[request setBlock:block];
    [request startSync:NO];
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
            [self setField:fileField toValue:[responseData objectForKey:kResult]];
        }
        case Add:
        case Update:
        case Delete:{
            NSString *itemID = [responseData objectForKey:KEY_gameID];
            if (itemID)
                self.gameID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.gameID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
            [self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[Game getArrayFromStatement:stmt IDsList:idsList] Block:[request getBlock]];
			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    Game *instace = [[Game alloc] init];
    instace.gameID = ID;
    return [instace autorelease];
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetGameArrayFinished _block = (GetGameArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field toValue:(id)value{
	switch (field) {
	case GameID:
		self.gameID = value;
		break;
	case GameNumOfChips:
		self.gameNumOfChips = [value intValue];
		break;
	case GamePlayerOne:
		self.gamePlayerOne = value;
		break;
	case GamePlayerTwo:
		self.gamePlayerTwo = value;
		break;
	case GameName:
		self.gameName = value;
		break;
	default:
	break;
	}
}


# pragma mark - Memory Management

- (void) dealloc
{
	[gameID release];
	[gameLastUpdate release];
	[gameName release];
	[gamePlayerOne release];
	[gamePlayerTwo release];


	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
- (id) init {
	if (self = [super init]) {

		self.gameID				= @"0";
		gameLastUpdate				= [[[[NSDate alloc] initWithTimeIntervalSince1970:0] autorelease] retain];
		self.gameNumOfChips				= 0;
		self.gameName				= @"";
self.gamePlayerOne    = [User instanceWithID:@"0"];
self.gamePlayerTwo    = [User instanceWithID:@"0"];
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.gameID               = [item objectForKey:KeyWithHeader(KEY_gameID, header)];
		gameLastUpdate               = [[item objectForKey:KeyWithHeader(KEY_gameLastUpdate, header)] retain];
		self.gameNumOfChips               = [[item objectForKey:KeyWithHeader(KEY_gameNumOfChips, header)] integerValue];
		self.gameName               = [item objectForKey:KeyWithHeader(KEY_gameName, header)];
		gamePlayerOne               = [[User alloc] initWithDictionary:item Header:KeyWithHeader
	(@"_",KEY_gamePlayerOne)];
		gamePlayerTwo               = [[User alloc] initWithDictionary:item Header:KeyWithHeader
	(@"_",KEY_gamePlayerTwo)];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(Game *)object {
	if (self = [super init]) {

		self.gameID               = object.gameID;
		gameLastUpdate               = [object.gameLastUpdate retain];
		self.gameNumOfChips               = object.gameNumOfChips;
		self.gameName               = object.gameName;
		gamePlayerOne               = [[User alloc] initWithObject:object.gamePlayerOne];
		gamePlayerTwo               = [[User alloc] initWithObject:object.gamePlayerTwo];

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:gameID forKey:KEY_gameID];
	[dictionary addDateValue:gameLastUpdate forKey:KEY_gameLastUpdate];
	[dictionary addIntValue:gameNumOfChips forKey:KEY_gameNumOfChips];
	[dictionary addValue:gameName forKey:KEY_gameName];
	[dictionary addForeignKeyValue:gamePlayerOne.dictionaryRepresentation forKey:KEY_gamePlayerOne];
	[dictionary addForeignKeyValue:gamePlayerTwo.dictionaryRepresentation forKey:KEY_gamePlayerTwo];

	return [dictionary autorelease];
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_gameID];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_gameLastUpdate];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_gameNumOfChips];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"'0'") forKey:KEY_gamePlayerOne];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"'0'") forKey:KEY_gamePlayerTwo];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_gameName];
	
	return [fieldsDic autorelease];
}

+ (NSDictionary *) getForeignKeys{
	NSMutableDictionary *foreignKeysDic = [[NSMutableDictionary alloc] init];

	[foreignKeysDic setValue:[User getClassName] forKey:KEY_gamePlayerOne];
	[foreignKeysDic setValue:[User getClassName] forKey:KEY_gamePlayerTwo];
	
	return [foreignKeysDic autorelease];
}

+ (NSString *) getClassName{
	return kClassName;
}

+ (NSString *) getFieldName:(LiFields)field{
	NSString *fieldName;
	
	switch (field) {
		case Game_None:
			fieldName = @"pos";
			break;
	
		case GameID:
			fieldName = KEY_gameID;
			break;

		case GameLastUpdate:
			fieldName = KEY_gameLastUpdate;
			break;

		case GameNumOfChips:
			fieldName = KEY_gameNumOfChips;
			break;

		case GameName:
			fieldName = KEY_gameName;
			break;

		case GamePlayerOne:
			fieldName = KEY_gamePlayerOne;
			break;

		case GamePlayerTwo:
			fieldName = KEY_gamePlayerTwo;
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
		case Game_None:
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
	[*request addIntValue:gameNumOfChips forKey:KEY_gameNumOfChips];
	[*request addValue:gameName forKey:KEY_gameName];
	[*request addValue:gamePlayerOne.userID forKey:KEY_gamePlayerOne];
	[*request addValue:gamePlayerTwo.userID forKey:KEY_gamePlayerTwo];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.gameID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][GameIDIndex])];
			gameLastUpdate = [[[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][GameLastUpdateIndex])]] retain];
			self.gameNumOfChips = sqlite3_column_int(stmt, array[0][GameNumOfChipsIndex]);

	if (isFK){
		self.gamePlayerOne = [User instanceWithID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][GamePlayerOneIndex])]];
	} else {
		int **gamePlayerOneArray = (int **)malloc(sizeof(int *));
		gamePlayerOneArray[0] = array[1];
		self.gamePlayerOne = [[[User alloc] initWithStatement:stmt Array:gamePlayerOneArray IsFK:YES] autorelease];
		free(gamePlayerOneArray);
	}

;

	if (isFK){
		self.gamePlayerTwo = [User instanceWithID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][GamePlayerTwoIndex])]];
	} else {
		int **gamePlayerTwoArray = (int **)malloc(sizeof(int *));
		gamePlayerTwoArray[0] = array[2];
		self.gamePlayerTwo = [[[User alloc] initWithStatement:stmt Array:gamePlayerTwoArray IsFK:YES] autorelease];
		free(gamePlayerTwoArray);
	}

;
			self.gameName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][GameNameIndex])];
		
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
	
	int **indexes = (int **)malloc(3*sizeof(int *));
	indexes[0] = (int *)malloc(NUM_OF_GAME_FIELDS*sizeof(int));
	indexes[1] = (int *)malloc(NUM_OF_USER_FIELDS*sizeof(int));
	indexes[2] = (int *)malloc(NUM_OF_USER_FIELDS*sizeof(int));

	indexes[0][GameIDIndex] = [columnsArray indexOfObject:KEY_gameID];
	indexes[0][GameLastUpdateIndex] = [columnsArray indexOfObject:KEY_gameLastUpdate];
	indexes[0][GameNumOfChipsIndex] = [columnsArray indexOfObject:KEY_gameNumOfChips];
	indexes[0][GamePlayerOneIndex] = [columnsArray indexOfObject:KEY_gamePlayerOne];
	indexes[0][GamePlayerTwoIndex] = [columnsArray indexOfObject:KEY_gamePlayerTwo];
	indexes[0][GameNameIndex] = [columnsArray indexOfObject:KEY_gameName];

	indexes[1][UserIDIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserID",@"_GamePlayerOne")];
	indexes[1][UserNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserName",@"_GamePlayerOne")];
	indexes[1][UserFirstNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserFirstName",@"_GamePlayerOne")];
	indexes[1][UserLastNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLastName",@"_GamePlayerOne")];
	indexes[1][UserEmailIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserEmail",@"_GamePlayerOne")];
	indexes[1][UserPhoneIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserPhone",@"_GamePlayerOne")];
	indexes[1][UserPasswordIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserPassword",@"_GamePlayerOne")];
	indexes[1][UserLastLoginIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLastLogin",@"_GamePlayerOne")];
	indexes[1][UserRegisterDateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserRegisterDate",@"_GamePlayerOne")];
	indexes[1][UserLocationLatIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLocationLat",@"_GamePlayerOne")];
	indexes[1][UserLocationLongIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLocationLong",@"_GamePlayerOne")];
	indexes[1][UserIsRegisteredFacebookIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserIsRegisteredFacebook",@"_GamePlayerOne")];
	indexes[1][UserIsRegisteredIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserIsRegistered",@"_GamePlayerOne")];
	indexes[1][UserLastUpdateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLastUpdate",@"_GamePlayerOne")];
	indexes[1][UserFacebookIDIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserFacebookID",@"_GamePlayerOne")];
	indexes[1][UserImageIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserImage",@"_GamePlayerOne")];
	indexes[1][UserMainCurrencyBalanceIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserMainCurrencyBalance",@"_GamePlayerOne")];
	indexes[1][UserSecondaryCurrencyBalanceIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserSecondaryCurrencyBalance",@"_GamePlayerOne")];
	indexes[1][UserTempDateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserTempDate",@"_GamePlayerOne")];

	indexes[2][UserIDIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserID",@"_GamePlayerTwo")];
	indexes[2][UserNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserName",@"_GamePlayerTwo")];
	indexes[2][UserFirstNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserFirstName",@"_GamePlayerTwo")];
	indexes[2][UserLastNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLastName",@"_GamePlayerTwo")];
	indexes[2][UserEmailIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserEmail",@"_GamePlayerTwo")];
	indexes[2][UserPhoneIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserPhone",@"_GamePlayerTwo")];
	indexes[2][UserPasswordIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserPassword",@"_GamePlayerTwo")];
	indexes[2][UserLastLoginIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLastLogin",@"_GamePlayerTwo")];
	indexes[2][UserRegisterDateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserRegisterDate",@"_GamePlayerTwo")];
	indexes[2][UserLocationLatIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLocationLat",@"_GamePlayerTwo")];
	indexes[2][UserLocationLongIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLocationLong",@"_GamePlayerTwo")];
	indexes[2][UserIsRegisteredFacebookIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserIsRegisteredFacebook",@"_GamePlayerTwo")];
	indexes[2][UserIsRegisteredIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserIsRegistered",@"_GamePlayerTwo")];
	indexes[2][UserLastUpdateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserLastUpdate",@"_GamePlayerTwo")];
	indexes[2][UserFacebookIDIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserFacebookID",@"_GamePlayerTwo")];
	indexes[2][UserImageIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserImage",@"_GamePlayerTwo")];
	indexes[2][UserMainCurrencyBalanceIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserMainCurrencyBalance",@"_GamePlayerTwo")];
	indexes[2][UserSecondaryCurrencyBalanceIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserSecondaryCurrencyBalance",@"_GamePlayerTwo")];
	indexes[2][UserTempDateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"UserTempDate",@"_GamePlayerTwo")];

	[columnsArray release];
	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][GameIDIndex])];
		if (idsList.count && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			Game *item  = [[Game alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
			[result addObject:item];
			[item release];
		}
	}

	[LiObjRequest removeIDsList:blackList FromObject:kClassName];
	[blackList release];
	
	for (int i=0; i<3; i++) {
		free(indexes[i]);
	}
	free(indexes);
	
	return [result autorelease];
}

#pragma mark - Deprecated Methods
/*********************************************************************************
 DEPRECATED METHODS:
 
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the next release. You should update your code immediately.
 **********************************************************************************/

- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value {
    [self increaseField:field byValue:value];
}

- (void) updateField:(LiFields)field Value:(NSNumber *)value {
    [self updateField:field withValue:value];
}

- (void) setField:(LiFields)field WithValue:(NSNumber *)value {
    [self setField:field toValue:value];
}

+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetGameFinished)block {
    [self getById:idString queryKind:queryKind withBlock:block];
}

+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetGameArrayFinished)block {
    [self getArrayWithQuery:query queryKind:queryKind withBlock:block];
}

+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetGameArrayFinished)block {
    [self getLocalArrayWithRawSQLQuery:rawQuery andBlock:block];
}

- (void)uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block {
    [self uploadFile:data toField:field withFileType:fileType extension:ext andBlock:block];
}

#pragma mark - End of Basic SDK

@end
