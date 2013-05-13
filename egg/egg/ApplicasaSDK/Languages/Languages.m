//
// Languages.m
// Created by Applicasa 
// 5/13/2013
//

#import "Languages.h"

#define kClassName                  @"Languages"

#define KEY_languagesID				@"LanguagesID"
#define KEY_languagesLastUpdate				@"LanguagesLastUpdate"
#define KEY_languagesText				@"LanguagesText"
#define KEY_languagesLanguageName				@"LanguagesLanguageName"

@interface Languages (privateMethods)

- (void) updateField:(LiFields)field withValue:(NSNumber *)value;
- (void) setField:(LiFields)field toValue:(id)value;

@end

@implementation Languages

@synthesize languagesID;
@synthesize languagesLastUpdate;
@synthesize languagesText;
@synthesize languagesLanguageName;

enum LanguagesIndexes {
	LanguagesIDIndex = 0,
	LanguagesLastUpdateIndex,
	LanguagesTextIndex,
	LanguagesLanguageNameIndex,};
#define NUM_OF_LANGUAGES_FIELDS 4



#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldLanguagesWorkOffline;

	[request setBlock:(__bridge void *)(block)];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.languagesID]){
		request.action = Update;
		[request addValue:languagesID forKey:KEY_languagesID];
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
	request.shouldWorkOffline = kShouldLanguagesWorkOffline;
	[request setBlock:(__bridge void *)(block)];
	request.delegate = self;
	[request addValue:languagesID forKey:KEY_languagesID];
	[request startSync:NO];    
}

#pragma mark - Get By ID

+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetLanguagesFinished)block{
    __block Languages *item = [Languages instance];

    LiFilters *filters = [LiBasicFilters filterByField:LanguagesID Operator:Equal Value:idString];
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

+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetLanguagesArrayFinished)block{
    Languages *item = [Languages instance];
    
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

+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetLanguagesArrayFinished)block{
    Languages *item = [Languages instance];

    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:(__bridge void *)(block)];
    [request addValue:rawQuery forKey:@"filters"];
    [request setShouldWorkOffline:YES];
    [request startSync:YES];
    
    [item requestDidFinished:request];
}

+ (NSArray *) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind {
    Languages *item = [Languages instance];
    
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
    
        return [Languages getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer];
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

	[request addValue:languagesID forKey:KEY_languagesID];
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
            NSString *itemID = [responseData objectForKey:KEY_languagesID];
            if (itemID)
                self.languagesID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.languagesID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
			[self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[Languages getArrayFromStatement:stmt IDsList:idsList resultFromServer:request.resultFromServer] Block:[request getBlock]];

			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    Languages *instace = [[Languages alloc] init];
    instace.languagesID = ID;
    return instace;
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetLanguagesArrayFinished _block = (__bridge GetLanguagesArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field toValue:(id)value{
	switch (field) {
	case LanguagesID:
		self.languagesID = value;
		break;
	case LanguagesText:
		self.languagesText = value;
		break;
	case LanguagesLanguageName:
		self.languagesLanguageName = value;
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

		self.languagesID				= @"0";
		languagesLastUpdate				= [[NSDate alloc] initWithTimeIntervalSince1970:0];
		self.languagesText				= @"";
		self.languagesLanguageName				= @"";
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.languagesID               = [item objectForKey:KeyWithHeader(KEY_languagesID, header)];
		languagesLastUpdate               = [item objectForKey:KeyWithHeader(KEY_languagesLastUpdate, header)];
		self.languagesText               = [item objectForKey:KeyWithHeader(KEY_languagesText, header)];
		self.languagesLanguageName               = [item objectForKey:KeyWithHeader(KEY_languagesLanguageName, header)];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(Languages *)object {
	if (self = [super init]) {

		self.languagesID               = object.languagesID;
		languagesLastUpdate               = object.languagesLastUpdate;
		self.languagesText               = object.languagesText;
		self.languagesLanguageName               = object.languagesLanguageName;

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:languagesID forKey:KEY_languagesID];
	[dictionary addDateValue:languagesLastUpdate forKey:KEY_languagesLastUpdate];
	[dictionary addValue:languagesText forKey:KEY_languagesText];
	[dictionary addValue:languagesLanguageName forKey:KEY_languagesLanguageName];

	return dictionary;
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_languagesID];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_languagesLastUpdate];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_languagesText];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_languagesLanguageName];
	
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
		case Languages_None:
			fieldName = @"pos";
			break;
	
		case LanguagesID:
			fieldName = KEY_languagesID;
			break;

		case LanguagesLastUpdate:
			fieldName = KEY_languagesLastUpdate;
			break;

		case LanguagesText:
			fieldName = KEY_languagesText;
			break;

		case LanguagesLanguageName:
			fieldName = KEY_languagesLanguageName;
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
		case Languages_None:
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
	[*request addValue:languagesText forKey:KEY_languagesText];
	[*request addValue:languagesLanguageName forKey:KEY_languagesLanguageName];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.languagesID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LanguagesIDIndex])];
			languagesLastUpdate = [[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LanguagesLastUpdateIndex])]];
			self.languagesText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LanguagesTextIndex])];
			self.languagesLanguageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][LanguagesLanguageNameIndex])];
		
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
	indexes[0] = (int *)malloc(NUM_OF_LANGUAGES_FIELDS*sizeof(int));

	indexes[0][LanguagesIDIndex] = [columnsArray indexOfObject:KEY_languagesID];
	indexes[0][LanguagesLastUpdateIndex] = [columnsArray indexOfObject:KEY_languagesLastUpdate];
	indexes[0][LanguagesTextIndex] = [columnsArray indexOfObject:KEY_languagesText];
	indexes[0][LanguagesLanguageNameIndex] = [columnsArray indexOfObject:KEY_languagesLanguageName];

	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][LanguagesIDIndex])];
		if (resultFromServer && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			Languages *item  = [[Languages alloc] initWithStatement:stmt Array:(int **)indexes IsFK:NO];
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
