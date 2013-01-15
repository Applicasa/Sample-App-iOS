//
// Tips.m
// Created by Applicasa 
// 1/15/2013
//

#import "Tips.h"

#define kClassName                  @"Tips"

#define KEY_tipsID				@"TipsID"
#define KEY_tipsLastUpdate				@"TipsLastUpdate"
#define KEY_tipsContent				@"TipsContent"
#define KEY_tipsNum				@"TipsNum"
#define KEY_tipsFdfsd				@"TipsFdfsd"

@interface Tips (privateMethods)

- (void) updateField:(LiFields)field withValue:(NSNumber *)value;
- (void) updateField:(LiFields)field Value:(NSNumber *)value DEPRECATED_ATTRIBUTE;
- (void) setField:(LiFields)field toValue:(id)value;
- (void) setField:(LiFields)field WithValue:(id)value DEPRECATED_ATTRIBUTE;

@end

@implementation Tips

@synthesize tipsID;
@synthesize tipsLastUpdate;
@synthesize tipsContent;
@synthesize tipsNum;
@synthesize tipsFdfsd;

enum TipsIndexes {
	TipsIDIndex = 0,
	TipsLastUpdateIndex,
	TipsContentIndex,
	TipsNumIndex,
	TipsFdfsdIndex,};
#define NUM_OF_TIPS_FIELDS 5



#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldTipsWorkOffline;

	[request setBlock:(__bridge void *)(block)];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.tipsID]){
		request.action = Update;
		[request addValue:tipsID forKey:KEY_tipsID];
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
		case TipsNum:
			tipsNum += [value intValue];
			break;
		case TipsFdfsd:
			tipsFdfsd += [value intValue];
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
	request.shouldWorkOffline = kShouldTipsWorkOffline;
	[request setBlock:(__bridge void *)(block)];
	request.delegate = self;
	[request addValue:tipsID forKey:KEY_tipsID];
	[request startSync:NO];    
}

#pragma mark - Get By ID

+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetTipsFinished)block{
    __block Tips *item = [Tips instance];

    LiFilters *filters = [LiBasicFilters filterByField:TipsID Operator:Equal Value:idString];
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

+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetTipsArrayFinished)block{
    Tips *item = [Tips instance];
    
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

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetTipsArrayFinished)block{
    Tips *item = [Tips instance];

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

	[request addValue:tipsID forKey:KEY_tipsID];
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
            NSString *itemID = [responseData objectForKey:KEY_tipsID];
            if (itemID)
                self.tipsID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.tipsID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
			[self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[Tips getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer] Block:[request getBlock]];

			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    Tips *instace = [[Tips alloc] init];
    instace.tipsID = ID;
    return instace;
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetTipsArrayFinished _block = (__bridge GetTipsArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field toValue:(id)value{
	switch (field) {
	case TipsID:
		self.tipsID = value;
		break;
	case TipsContent:
		self.tipsContent = value;
		break;
	case TipsNum:
		self.tipsNum = [value intValue];
		break;
	case TipsFdfsd:
		self.tipsFdfsd = [value intValue];
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

		self.tipsID				= @"0";
		tipsLastUpdate				= [[NSDate alloc] initWithTimeIntervalSince1970:0];
		self.tipsContent				= @"";
		self.tipsNum				= 0;
		self.tipsFdfsd				= 0;
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.tipsID               = [item objectForKey:KeyWithHeader(KEY_tipsID, header)];
		tipsLastUpdate               = [item objectForKey:KeyWithHeader(KEY_tipsLastUpdate, header)];
		self.tipsContent               = [item objectForKey:KeyWithHeader(KEY_tipsContent, header)];
		self.tipsNum               = [[item objectForKey:KeyWithHeader(KEY_tipsNum, header)] integerValue];
		self.tipsFdfsd               = [[item objectForKey:KeyWithHeader(KEY_tipsFdfsd, header)] integerValue];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(Tips *)object {
	if (self = [super init]) {

		self.tipsID               = object.tipsID;
		tipsLastUpdate               = object.tipsLastUpdate;
		self.tipsContent               = object.tipsContent;
		self.tipsNum               = object.tipsNum;
		self.tipsFdfsd               = object.tipsFdfsd;

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:tipsID forKey:KEY_tipsID];
	[dictionary addDateValue:tipsLastUpdate forKey:KEY_tipsLastUpdate];
	[dictionary addValue:tipsContent forKey:KEY_tipsContent];
	[dictionary addIntValue:tipsNum forKey:KEY_tipsNum];
	[dictionary addIntValue:tipsFdfsd forKey:KEY_tipsFdfsd];

	return dictionary;
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_tipsID];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_tipsLastUpdate];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_tipsContent];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_tipsNum];
	[fieldsDic setValue:TypeAndDefaultValue(kINTEGER_TYPE,@"0") forKey:KEY_tipsFdfsd];
	
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
		case Tips_None:
			fieldName = @"pos";
			break;
	
		case TipsID:
			fieldName = KEY_tipsID;
			break;

		case TipsLastUpdate:
			fieldName = KEY_tipsLastUpdate;
			break;

		case TipsContent:
			fieldName = KEY_tipsContent;
			break;

		case TipsNum:
			fieldName = KEY_tipsNum;
			break;

		case TipsFdfsd:
			fieldName = KEY_tipsFdfsd;
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
		case Tips_None:
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
	[*request addValue:tipsContent forKey:KEY_tipsContent];
	[*request addIntValue:tipsNum forKey:KEY_tipsNum];
	[*request addIntValue:tipsFdfsd forKey:KEY_tipsFdfsd];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.tipsID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][TipsIDIndex])];
			tipsLastUpdate = [[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][TipsLastUpdateIndex])]];
			self.tipsContent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][TipsContentIndex])];
			self.tipsNum = sqlite3_column_int(stmt, array[0][TipsNumIndex]);
			self.tipsFdfsd = sqlite3_column_int(stmt, array[0][TipsFdfsdIndex]);
		
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
	indexes[0] = (int *)malloc(NUM_OF_TIPS_FIELDS*sizeof(int));

	indexes[0][TipsIDIndex] = [columnsArray indexOfObject:KEY_tipsID];
	indexes[0][TipsLastUpdateIndex] = [columnsArray indexOfObject:KEY_tipsLastUpdate];
	indexes[0][TipsContentIndex] = [columnsArray indexOfObject:KEY_tipsContent];
	indexes[0][TipsNumIndex] = [columnsArray indexOfObject:KEY_tipsNum];
	indexes[0][TipsFdfsdIndex] = [columnsArray indexOfObject:KEY_tipsFdfsd];

	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][TipsIDIndex])];
		if (resultFromServer && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			Tips *item  = [[Tips alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
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

+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetTipsFinished)block {
    [self getById:idString queryKind:queryKind withBlock:block];
}

+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetTipsArrayFinished)block {
    [self getArrayWithQuery:query queryKind:queryKind withBlock:block];
}

+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetTipsArrayFinished)block {
    [self getLocalArrayWithRawSQLQuery:rawQuery andBlock:block];
}

- (void)uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block {
    [self uploadFile:data toField:field withFileType:fileType extension:ext andBlock:block];
}

#pragma mark - End of Basic SDK

@end
