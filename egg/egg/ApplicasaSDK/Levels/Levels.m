//
// Levels.m
// Created by Applicasa 
// 5/13/2013
//

#import "Levels.h"

#define kClassName                  @"Levels"

#define KEY_levelsID				@"LevelsID"
#define KEY_levelsLastUpdate				@"LevelsLastUpdate"
#define KEY_levelsGtgtg				@"LevelsGtgtg"
#define KEY_levelsTgtggtg				@"LevelsTgtggtg"

@interface Levels (privateMethods)

- (void) updateField:(LiFields)field withValue:(NSNumber *)value;
- (void) setField:(LiFields)field toValue:(id)value;

@end

@implementation Levels

@synthesize levelsID;
@synthesize levelsLastUpdate;
@synthesize levelsGtgtg;
@synthesize levelsTgtggtg;

enum LevelsIndexes {
	LevelsIDIndex = 0,
	LevelsLastUpdateIndex,
	LevelsGtgtgIndex,
	LevelsTgtggtgIndex,};
#define NUM_OF_LEVELS_FIELDS 4



#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldLevelsWorkOffline;

	[request setBlock:(__bridge void *)(block)];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.levelsID]){
		request.action = Update;
		[request addValue:levelsID forKey:KEY_levelsID];
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
		case LevelsTgtggtg:
			levelsTgtggtg += [value intValue];
			break;
		default:
			break;
	}
}

#pragma mark - Increase

- (void) increaseField:(LiFields)field byValue:(NSNumber *)value{
    if (!self.increaseDictionary)
        self.increaseDictionary = [[NSMutableDictionary alloc] init];
    [self.increaseDictionary setValue:value forKey:[[self class] getFieldName:field]];
    [self updateField:field withValue:value];
}

#pragma mark - Delete

- (void) deleteWithBlock:(LiBlockAction)block{        
	LiObjRequest *request = [LiObjRequest requestWithAction:Delete ClassName:kClassName];
	request.shouldWorkOffline = kShouldLevelsWorkOffline;
	[request setBlock:(__bridge void *)(block)];
	request.delegate = self;
	[request addValue:levelsID forKey:KEY_levelsID];
	[request startSync:NO];    
}

#pragma mark - Get By ID

+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetLevelsFinished)block{
    __block Levels *item = [Levels instance];

    LiFilters *filters = [LiBasicFilters filterByField:LevelsID Operator:Equal Value:idString];
    LiQuery *query = [[LiQuery alloc]init];
    [query setFilters:filters];
    
    [self getArrayWithQuery:query queryKind:queryKind withBlock:^(NSError *error, NSArray *array) {
        item = nil;
        if (array.count)
            item = [array objectAtIndex:0];
        block(error,item);
    }];	 
}


#pragma mark - Get Array

+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetLevelsArrayFinished)block{
    Levels *item = [Levels instance];
    
 query = [self setFieldsNameToQuery:query];
    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:(__bridge void *)(block)];
    [request addIntValue:queryKind forKey:@"DbGetKind"];
    [request setDelegate:item];
    [request addValue:query forKey:@"query"];
    request.shouldWorkOffline = (queryKind == LOCAL);
    
    [request startSync:(queryKind == LOCAL)];
    
    if (queryKind == LOCAL)
        [item requestDidFinished:request];
}

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetLevelsArrayFinished)block{
    Levels *item = [Levels instance];

    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:(__bridge void *)(block)];
    [request addValue:rawQuery forKey:@"filters"];
    [request setShouldWorkOffline:YES];
    [request startSync:YES];
    
    [item requestDidFinished:request];
}

+ (NSArray *) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind {
    Levels *item = [Levels instance];
    
    query = [self setFieldsNameToQuery:query];
    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
    [request addIntValue:queryKind forKey:@"DbGetKind"];
    [request setDelegate:item];
    [request addValue:query forKey:@"query"];
    request.shouldWorkOffline = YES;
    
    [request startSync:YES];
    
    NSInteger responseType = request.response.responseType;   
    
    if (responseType == 1)
    {
        sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
    
        NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
    
        return [Levels getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer];
    }
    return nil;
}

+ (void) getArrayWithFilter:(LiFilters *)filter withBlock:(UpdateObjectFinished)block
{
    LiQuery *query = [[LiQuery alloc] initWithFilter:filter];
    query = [self setFieldsNameToQuery:query];
    [UpdateObject getArrayWithQuery:query andWithClassName:kClassName withBlock:block];
}

#pragma mark - Upload File

- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block{

    LiObjRequest *request = [LiObjRequest requestWithAction:UploadFile ClassName:kClassName];
    request.delegate = self;

	[request addValue:levelsID forKey:KEY_levelsID];
    [request addValue:ext forKey:@"ext"];
    [request addValue:data forKey:@"data"];
    [request addIntValue:fileType forKey:@"fileType"];
	[request addIntValue:field forKey:@"fileField"];
    [request addValue:[[self class] getFieldName:field] forKey:@"field"];
	[request setBlock:(__bridge void *)(block)];
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
            NSString *itemID = [responseData objectForKey:KEY_levelsID];
            if (itemID)
                self.levelsID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.levelsID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
			[self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[Levels getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer] Block:[request getBlock]];

			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    Levels *instace = [[Levels alloc] init];
    instace.levelsID = ID;
    return instace;
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetLevelsArrayFinished _block = (__bridge GetLevelsArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field toValue:(id)value{
	switch (field) {
	case LevelsID:
		self.levelsID = value;
		break;
	case LevelsGtgtg:
		self.levelsGtgtg = value;
		break;
	case LevelsTgtggtg:
		self.levelsTgtggtg = [value intValue];
		break;
	default:
	break;
	}
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
- (id) init {
	if (self = [super init]) {

		self.levelsID				= @"0";
		levelsLastUpdate				= [[NSDate alloc] initWithTimeIntervalSince1970:0];
		self.levelsGtgtg				= @"";
		self.levelsTgtggtg				= 0;
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.levelsID               = [item objectForKey:KeyWithHeader(KEY_levelsID, header)];
		levelsLastUpdate               = [item objectForKey:KeyWithHeader(KEY_levelsLastUpdate, header)];
		self.levelsGtgtg               = [item objectForKey:KeyWithHeader(KEY_levelsGtgtg, header)];
		self.levelsTgtggtg               = [[item objectForKey:KeyWithHeader(KEY_levelsTgtggtg, header)] integerValue];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(Levels *)object {
	if (self = [super init]) {

		self.levelsID               = object.levelsID;
		levelsLastUpdate               = object.levelsLastUpdate;
		self.levelsGtgtg               = object.levelsGtgtg;
		self.levelsTgtggtg               = object.levelsTgtggtg;

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:levelsID forKey:KEY_levelsID];
	[dictionary addDateValue:levelsLastUpdate forKey:KEY_levelsLastUpdate];
	[dictionary addValue:levelsGtgtg forKey:KEY_levelsGtgtg];
	[dictionary addIntValue:levelsTgtggtg forKey:KEY_levelsTgtggtg];

	return dictionary;
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_levelsID];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_levelsLastUpdate];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_levelsGtgtg];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_levelsTgtggtg];
	
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
		case Levels_None:
			fieldName = @"pos";
			break;
	
		case LevelsID:
			fieldName = KEY_levelsID;
			break;

		case LevelsLastUpdate:
			fieldName = KEY_levelsLastUpdate;
			break;

		case LevelsGtgtg:
			fieldName = KEY_levelsGtgtg;
			break;

		case LevelsTgtggtg:
			fieldName = KEY_levelsTgtggtg;
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
		case Levels_None:
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
	[*request addValue:levelsGtgtg forKey:KEY_levelsGtgtg];
	[*request addIntValue:levelsTgtggtg forKey:KEY_levelsTgtggtg];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.levelsID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LevelsIDIndex])];
			levelsLastUpdate = [[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LevelsLastUpdateIndex])]];
			self.levelsGtgtg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LevelsGtgtgIndex])];
			self.levelsTgtggtg = sqlite3_column_int(stmt, array[0][LevelsTgtggtgIndex]);
		
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
	indexes[0] = (int *)malloc(NUM_OF_LEVELS_FIELDS*sizeof(int));

	indexes[0][LevelsIDIndex] = [columnsArray indexOfObject:KEY_levelsID];
	indexes[0][LevelsLastUpdateIndex] = [columnsArray indexOfObject:KEY_levelsLastUpdate];
	indexes[0][LevelsGtgtgIndex] = [columnsArray indexOfObject:KEY_levelsGtgtg];
	indexes[0][LevelsTgtggtgIndex] = [columnsArray indexOfObject:KEY_levelsTgtggtg];

	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][LevelsIDIndex])];
		if (resultFromServer && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			Levels *item  = [[Levels alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
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

@end
