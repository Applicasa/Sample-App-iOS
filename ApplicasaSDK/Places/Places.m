//
// Places.m
// Created by Applicasa 
// 1/23/2013
//

#import "Places.h"

#define kClassName                  @"Places"

#define KEY_placesID				@"PlacesID"
#define KEY_placesLastUpdate				@"PlacesLastUpdate"
#define KEY_placesLoc				@"PlacesLoc"
#define KEY_placesLocLong				@"PlacesLocLong"
#define KEY_placesLocLat				@"PlacesLocLat"
#define KEY_placesName				@"PlacesName"

@interface Places (privateMethods)

- (void) updateField:(LiFields)field withValue:(NSNumber *)value;
- (void) updateField:(LiFields)field Value:(NSNumber *)value DEPRECATED_ATTRIBUTE;
- (void) setField:(LiFields)field toValue:(id)value;
- (void) setField:(LiFields)field WithValue:(id)value DEPRECATED_ATTRIBUTE;

@end

@implementation Places

@synthesize placesID;
@synthesize placesLastUpdate;
@synthesize placesLoc;
@synthesize placesName;

enum PlacesIndexes {
	PlacesIDIndex = 0,
	PlacesLastUpdateIndex,
	PlacesLocLatIndex,
	PlacesLocLongIndex,
	PlacesNameIndex,};
#define NUM_OF_PLACES_FIELDS 5



#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldPlacesWorkOffline;

	[request setBlock:(__bridge void *)(block)];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.placesID]){
		request.action = Update;
		[request addValue:placesID forKey:KEY_placesID];
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
	request.shouldWorkOffline = kShouldPlacesWorkOffline;
	[request setBlock:(__bridge void *)(block)];
	request.delegate = self;
	[request addValue:placesID forKey:KEY_placesID];
	[request startSync:NO];    
}

#pragma mark - Get By ID

+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetPlacesFinished)block{
    __block Places *item = [Places instance];

    LiFilters *filters = [LiBasicFilters filterByField:PlacesID Operator:Equal Value:idString];
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

+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetPlacesArrayFinished)block{
    Places *item = [Places instance];
    
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

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetPlacesArrayFinished)block{
    Places *item = [Places instance];

    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:(__bridge void *)(block)];
    [request addValue:rawQuery forKey:@"filters"];
    [request setShouldWorkOffline:YES];
    [request startSync:YES];
    
    [item requestDidFinished:request];
}

#pragma mark - Upload File

- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block{

    LiObjRequest *request = [LiObjRequest requestWithAction:UploadFile ClassName:kClassName];
    request.delegate = self;

	[request addValue:placesID forKey:KEY_placesID];
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
            NSString *itemID = [responseData objectForKey:KEY_placesID];
            if (itemID)
                self.placesID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.placesID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
			[self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[Places getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer] Block:[request getBlock]];

			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    Places *instace = [[Places alloc] init];
    instace.placesID = ID;
    return instace;
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetPlacesArrayFinished _block = (__bridge GetPlacesArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field toValue:(id)value{
	switch (field) {
	case PlacesID:
		self.placesID = value;
		break;
	case PlacesLoc:
		self.placesLoc = value;
		break;
	case PlacesName:
		self.placesName = value;
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

		self.placesID				= @"0";
		placesLastUpdate				= [[NSDate alloc] initWithTimeIntervalSince1970:0];
		self.placesLoc				=  [[CLLocation alloc] initWithLatitude:0 longitude:0];
		self.placesName				= @"";
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.placesID               = [item objectForKey:KeyWithHeader(KEY_placesID, header)];
		placesLastUpdate               = [item objectForKey:KeyWithHeader(KEY_placesLastUpdate, header)];
		self.placesLoc               = [[CLLocation alloc] initWithLatitude:[[item objectForKey:KeyWithHeader(KEY_placesLocLat, header)] floatValue] longitude:[[item objectForKey:KeyWithHeader(KEY_placesLocLong, header)] floatValue]];
		self.placesName               = [item objectForKey:KeyWithHeader(KEY_placesName, header)];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(Places *)object {
	if (self = [super init]) {

		self.placesID               = object.placesID;
		placesLastUpdate               = object.placesLastUpdate;
		self.placesLoc               = object.placesLoc;
		self.placesName               = object.placesName;

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:placesID forKey:KEY_placesID];
	[dictionary addDateValue:placesLastUpdate forKey:KEY_placesLastUpdate];
	[dictionary addGeoValue:placesLoc forKey:KEY_placesLoc];
	[dictionary addValue:placesName forKey:KEY_placesName];

	return dictionary;
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_placesID];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_placesLastUpdate];
	[fieldsDic setValue:TypeAndDefaultValue(kREAL_TYPE,@"0") forKey:KEY_placesLocLong];
	[fieldsDic setValue:TypeAndDefaultValue(kREAL_TYPE,@"0") forKey:KEY_placesLocLat];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_placesName];
	
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
		case Places_None:
			fieldName = @"pos";
			break;
	
		case PlacesID:
			fieldName = KEY_placesID;
			break;

		case PlacesLastUpdate:
			fieldName = KEY_placesLastUpdate;
			break;

		case PlacesName:
			fieldName = KEY_placesName;
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
		case Places_None:
			fieldName = @"pos";
			break;
	
		case PlacesLoc:
			fieldName = KEY_placesLoc;
			break;

		default:
			NSLog(@"Wrong Geo LiFields numerator for %@ Class",kClassName);
			fieldName = nil;
			break;
	}
	
	return fieldName;
}


- (void) addValuesToRequest:(LiObjRequest **)request{
	[*request addLocationValue:placesLoc forKey:KEY_placesLoc];
	[*request addValue:placesName forKey:KEY_placesName];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.placesID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][PlacesIDIndex])];
			placesLastUpdate = [[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][PlacesLastUpdateIndex])]];
			self.placesLoc =  [[CLLocation alloc] initWithLatitude:sqlite3_column_double(stmt, array[0][PlacesLocLatIndex]) longitude:sqlite3_column_double(stmt, array[0][PlacesLocLongIndex])];
			self.placesName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][PlacesNameIndex])];
		
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
	indexes[0] = (int *)malloc(NUM_OF_PLACES_FIELDS*sizeof(int));

	indexes[0][PlacesIDIndex] = [columnsArray indexOfObject:KEY_placesID];
	indexes[0][PlacesLastUpdateIndex] = [columnsArray indexOfObject:KEY_placesLastUpdate];
	indexes[0][PlacesLocLatIndex] = [columnsArray indexOfObject:KEY_placesLocLat];
	indexes[0][PlacesLocLongIndex] = [columnsArray indexOfObject:KEY_placesLocLong];
	indexes[0][PlacesNameIndex] = [columnsArray indexOfObject:KEY_placesName];

	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][PlacesIDIndex])];
		if (resultFromServer && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			Places *item  = [[Places alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
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

+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetPlacesFinished)block {
    [self getById:idString queryKind:queryKind withBlock:block];
}

+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetPlacesArrayFinished)block {
    [self getArrayWithQuery:query queryKind:queryKind withBlock:block];
}

+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetPlacesArrayFinished)block {
    [self getLocalArrayWithRawSQLQuery:rawQuery andBlock:block];
}

- (void)uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block {
    [self uploadFile:data toField:field withFileType:fileType extension:ext andBlock:block];
}

#pragma mark - End of Basic SDK

@end
