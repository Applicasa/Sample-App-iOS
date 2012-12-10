//
// Move.m
// Created by Applicasa 
// 09/12/2012
//

#import "Move.h"
#import "Game.h"

#define kClassName                  @"Move"

#define KEY_moveID				@"MoveID"
#define KEY_moveLastUpdate				@"MoveLastUpdate"
#define KEY_moveNum				@"MoveNum"
#define KEY_moveGame				@"MoveGame"

@interface Move (privateMethods)

- (void) updateField:(LiFields)field withValue:(NSNumber *)value;
- (void) updateField:(LiFields)field Value:(NSNumber *)value DEPRECATED_ATTRIBUTE;
- (void) setField:(LiFields)field toValue:(id)value;
- (void) setField:(LiFields)field WithValue:(id)value DEPRECATED_ATTRIBUTE;

@end

@implementation Move

@synthesize moveID;
@synthesize moveLastUpdate;
@synthesize moveNum;
@synthesize moveGame;

enum MoveIndexes {
	MoveIDIndex = 0,
	MoveLastUpdateIndex,
	MoveNumIndex,
	MoveGameIndex,};
#define NUM_OF_MOVE_FIELDS 4

enum GameIndexes {
	GameIDIndex = 0,
	GameLastUpdateIndex,
	GameNumOfChipsIndex,
	GamePlayerOneIndex,
	GamePlayerTwoIndex,
	GameNameIndex,};
#define NUM_OF_GAME_FIELDS 6


#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldMoveWorkOffline;

	[request setBlock:block];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.moveID]){
		request.action = Update;
		[request addValue:moveID forKey:KEY_moveID];
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
		case MoveNum:
			moveNum += [value intValue];
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
	request.shouldWorkOffline = kShouldMoveWorkOffline;
	[request setBlock:block];
    request.delegate = self;
    [request addValue:moveID forKey:KEY_moveID];
    [request startSync:NO];    
}

#pragma mark - Get By ID

+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetMoveFinished)block{
    __block Move *item = [Move instance];

    LiFilters *filters = [LiBasicFilters filterByField:MoveID Operator:Equal Value:idString];
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

+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetMoveArrayFinished)block{
    Move *item = [Move instance];
    
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

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetMoveArrayFinished)block{
    Move *item = [Move instance];

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

	[request addValue:moveID forKey:KEY_moveID];
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
            NSString *itemID = [responseData objectForKey:KEY_moveID];
            if (itemID)
                self.moveID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.moveID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
            [self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[Move getArrayFromStatement:stmt IDsList:idsList] Block:[request getBlock]];
			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    Move *instace = [[Move alloc] init];
    instace.moveID = ID;
    return [instace autorelease];
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetMoveArrayFinished _block = (GetMoveArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field toValue:(id)value{
	switch (field) {
	case MoveID:
		self.moveID = value;
		break;
	case MoveNum:
		self.moveNum = [value intValue];
		break;
	case MoveGame:
		self.moveGame = value;
		break;
	default:
	break;
	}
}


# pragma mark - Memory Management

- (void) dealloc
{
	[moveID release];
	[moveLastUpdate release];
	[moveGame release];


	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
- (id) init {
	if (self = [super init]) {

		self.moveID				= @"0";
		moveLastUpdate				= [[[[NSDate alloc] initWithTimeIntervalSince1970:0] autorelease] retain];
		self.moveNum				= 0;
self.moveGame    = [Game instanceWithID:@"0"];
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.moveID               = [item objectForKey:KeyWithHeader(KEY_moveID, header)];
		moveLastUpdate               = [[item objectForKey:KeyWithHeader(KEY_moveLastUpdate, header)] retain];
		self.moveNum               = [[item objectForKey:KeyWithHeader(KEY_moveNum, header)] integerValue];
		moveGame               = [[Game alloc] initWithDictionary:item Header:KeyWithHeader
	(@"_",KEY_moveGame)];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(Move *)object {
	if (self = [super init]) {

		self.moveID               = object.moveID;
		moveLastUpdate               = [object.moveLastUpdate retain];
		self.moveNum               = object.moveNum;
		moveGame               = [[Game alloc] initWithObject:object.moveGame];

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:moveID forKey:KEY_moveID];
	[dictionary addDateValue:moveLastUpdate forKey:KEY_moveLastUpdate];
	[dictionary addIntValue:moveNum forKey:KEY_moveNum];
	[dictionary addForeignKeyValue:moveGame.dictionaryRepresentation forKey:KEY_moveGame];

	return [dictionary autorelease];
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_moveID];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_moveLastUpdate];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_moveNum];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"'0'") forKey:KEY_moveGame];
	
	return [fieldsDic autorelease];
}

+ (NSDictionary *) getForeignKeys{
	NSMutableDictionary *foreignKeysDic = [[NSMutableDictionary alloc] init];

	[foreignKeysDic setValue:[Game getClassName] forKey:KEY_moveGame];
	
	return [foreignKeysDic autorelease];
}

+ (NSString *) getClassName{
	return kClassName;
}

+ (NSString *) getFieldName:(LiFields)field{
	NSString *fieldName;
	
	switch (field) {
		case Move_None:
			fieldName = @"pos";
			break;
	
		case MoveID:
			fieldName = KEY_moveID;
			break;

		case MoveLastUpdate:
			fieldName = KEY_moveLastUpdate;
			break;

		case MoveNum:
			fieldName = KEY_moveNum;
			break;

		case MoveGame:
			fieldName = KEY_moveGame;
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
		case Move_None:
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
	[*request addIntValue:moveNum forKey:KEY_moveNum];
	[*request addValue:moveGame.gameID forKey:KEY_moveGame];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.moveID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][MoveIDIndex])];
			moveLastUpdate = [[[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][MoveLastUpdateIndex])]] retain];
			self.moveNum = sqlite3_column_int(stmt, array[0][MoveNumIndex]);

	if (isFK){
		self.moveGame = [Game instanceWithID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][MoveGameIndex])]];
	} else {
		int **moveGameArray = (int **)malloc(sizeof(int *));
		moveGameArray[0] = array[1];
		self.moveGame = [[[Game alloc] initWithStatement:stmt Array:moveGameArray IsFK:YES] autorelease];
		free(moveGameArray);
	}

;
		
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
	indexes[0] = (int *)malloc(NUM_OF_MOVE_FIELDS*sizeof(int));
	indexes[1] = (int *)malloc(NUM_OF_GAME_FIELDS*sizeof(int));

	indexes[0][MoveIDIndex] = [columnsArray indexOfObject:KEY_moveID];
	indexes[0][MoveLastUpdateIndex] = [columnsArray indexOfObject:KEY_moveLastUpdate];
	indexes[0][MoveNumIndex] = [columnsArray indexOfObject:KEY_moveNum];
	indexes[0][MoveGameIndex] = [columnsArray indexOfObject:KEY_moveGame];

	indexes[1][GameIDIndex] = [columnsArray indexOfObject:KeyWithHeader(@"GameID",@"_MoveGame")];
	indexes[1][GameLastUpdateIndex] = [columnsArray indexOfObject:KeyWithHeader(@"GameLastUpdate",@"_MoveGame")];
	indexes[1][GameNumOfChipsIndex] = [columnsArray indexOfObject:KeyWithHeader(@"GameNumOfChips",@"_MoveGame")];
	indexes[1][GamePlayerOneIndex] = [columnsArray indexOfObject:KeyWithHeader(@"GamePlayerOne",@"_MoveGame")];
	indexes[1][GamePlayerTwoIndex] = [columnsArray indexOfObject:KeyWithHeader(@"GamePlayerTwo",@"_MoveGame")];
	indexes[1][GameNameIndex] = [columnsArray indexOfObject:KeyWithHeader(@"GameName",@"_MoveGame")];

	[columnsArray release];
	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][MoveIDIndex])];
		if (idsList.count && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			Move *item  = [[Move alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
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

+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetMoveFinished)block {
    [self getById:idString queryKind:queryKind withBlock:block];
}

+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetMoveArrayFinished)block {
    [self getArrayWithQuery:query queryKind:queryKind withBlock:block];
}

+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetMoveArrayFinished)block {
    [self getLocalArrayWithRawSQLQuery:rawQuery andBlock:block];
}

- (void)uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block {
    [self uploadFile:data toField:field withFileType:fileType extension:ext andBlock:block];
}

#pragma mark - End of Basic SDK

@end
