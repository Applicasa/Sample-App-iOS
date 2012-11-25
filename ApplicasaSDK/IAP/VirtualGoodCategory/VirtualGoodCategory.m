//
// VirtualGoodCategory.m
// Created by Applicasa 
// 11/25/2012
//

#import "VirtualGoodCategory.h"

#define kClassName                  @"VirtualGoodCategory"

#define KEY_virtualGoodCategoryID				@"VirtualGoodCategoryID"
#define KEY_virtualGoodCategoryName				@"VirtualGoodCategoryName"
#define KEY_virtualGoodCategoryLastUpdate				@"VirtualGoodCategoryLastUpdate"

@interface VirtualGoodCategory (privateMethods)

- (void) updateField:(LiFields)field Value:(NSNumber *)value;
- (void) setField:(LiFields)field WithValue:(id)value;

@end

@implementation VirtualGoodCategory

@synthesize virtualGoodCategoryID;
@synthesize virtualGoodCategoryName;
@synthesize virtualGoodCategoryLastUpdate;

enum VirtualGoodCategoryIndexes {
	VirtualGoodCategoryIDIndex = 0,
	VirtualGoodCategoryNameIndex,
	VirtualGoodCategoryLastUpdateIndex,};
#define NUM_OF_VIRTUALGOODCATEGORY_FIELDS 3



#pragma mark - Save

- (void) saveWithBlock:(LiBlockAction)block{
	LiObjRequest *request = [LiObjRequest requestWithAction:Add ClassName:kClassName];
	request.shouldWorkOffline = kShouldVirtualGoodCategoryWorkOffline;

	[request setBlock:block];
	[self addValuesToRequest:&request];

	if ([self isServerId:self.virtualGoodCategoryID]){
		request.action = Update;
		[request addValue:virtualGoodCategoryID forKey:KEY_virtualGoodCategoryID];
		if (self.increaseDictionary.count){
			[request.requestParameters setValue:self.increaseDictionary forKey:@"$inc"];
			self.increaseDictionary = nil;
		}
	} 	
	request.delegate = self;
	[request startSync:FALSE];
}

- (void) updateField:(LiFields)field Value:(NSNumber *)value{
	switch (field) {
		default:
			break;
	}
}

#pragma mark - Increase

- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value{
    if (!self.increaseDictionary)
        self.increaseDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [self.increaseDictionary setValue:value forKey:[[self class] getFieldName:field]];
    [self updateField:field Value:value];
}

#pragma mark - Delete

- (void) deleteWithBlock:(LiBlockAction)block{        
    LiObjRequest *request = [LiObjRequest requestWithAction:Delete ClassName:kClassName];
	request.shouldWorkOffline = kShouldVirtualGoodCategoryWorkOffline;
	[request setBlock:block];
    request.delegate = self;
    [request addValue:virtualGoodCategoryID forKey:KEY_virtualGoodCategoryID];
    [request startSync:FALSE];    
}


#pragma mark - Get By ID

+ (void) getByID:(NSString *)Id QueryKind:(QueryKind)queryKind WithBlock:(GetVirtualGoodCategoryFinished)block{
    __block VirtualGoodCategory *item = [VirtualGoodCategory instance];

    LiFilters *filters = [LiBasicFilters filterByField:VirtualGoodCategoryID Operator:Equal Value:Id];
    LiQuery *query = [[LiQuery alloc]init];
    [query setFilters:filters];
    
    [self getArrayWithQuery:query QueryKind:queryKind WithBlock:^(NSError *error, NSArray *array) {
        item = nil;
        if (array.count)
            item = [array objectAtIndex:0];
        block(error,item);
    }];
    [query release];
}


#pragma mark - Get Array

+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetVirtualGoodCategoryArrayFinished)block{
    VirtualGoodCategory *item = [VirtualGoodCategory instance];
    
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

+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetVirtualGoodCategoryArrayFinished)block{
    VirtualGoodCategory *item = [VirtualGoodCategory instance];

    LiObjRequest *request = [LiObjRequest requestWithAction:GetArray ClassName:kClassName];
	[request setBlock:block];
    [request addValue:rawQuery forKey:@"filters"];
    [request setShouldWorkOffline:TRUE];
    [request startSync:TRUE];
    
    [item requestDidFinished:request];
}

#pragma mark - Upload File

- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block{

    LiObjRequest *request = [LiObjRequest requestWithAction:UploadFile ClassName:kClassName];
    request.delegate = self;

	[request addValue:virtualGoodCategoryID forKey:KEY_virtualGoodCategoryID];
    [request addValue:ext forKey:@"ext"];
    [request addValue:data forKey:@"data"];
    [request addIntValue:fileType forKey:@"fileType"];
	[request addIntValue:field forKey:@"fileField"];
    [request addValue:[[self class] getFieldName:field] forKey:@"field"];
	[request setBlock:block];
    [request startSync:FALSE];
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
            NSString *itemID = [responseData objectForKey:KEY_virtualGoodCategoryID];
            if (itemID)
                self.virtualGoodCategoryID = itemID;
            
            [self respondToLiActionCallBack:responseType ResponseMessage:responseMessage ItemID:self.virtualGoodCategoryID Action:action Block:[request getBlock]];
			[request releaseBlock];
        }
            break;

        case GetArray:{            
			sqlite3_stmt *stmt = (sqlite3_stmt *)[request.response getStatement];
            NSArray *idsList = [request.response.responseData objectForKey:@"ids"];
            [self respondToGetArray_ResponseType:responseType ResponseMessage:responseMessage Array:[VirtualGoodCategory getArrayFromStatement:stmt IDsList:idsList] Block:[request getBlock]];
			[request releaseBlock];
			
        }
            break;
        default:
            break;
    }
}

+ (id) instanceWithID:(NSString *)ID{
    VirtualGoodCategory *instace = [[VirtualGoodCategory alloc] init];
    instace.virtualGoodCategoryID = ID;
    return [instace autorelease];
}


#pragma mark - Responders

- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
	
    GetVirtualGoodCategoryArrayFinished _block = (GetVirtualGoodCategoryArrayFinished)block;
    _block(error,array);
}



- (void) setField:(LiFields)field WithValue:(id)value{
	switch (field) {
	case VirtualGoodCategoryID:
		self.virtualGoodCategoryID = value;
		break;
	case VirtualGoodCategoryName:
		self.virtualGoodCategoryName = value;
		break;
	default:
	break;
	}
}


# pragma mark - Memory Management

- (void) dealloc
{
	[virtualGoodCategoryID release];
	[virtualGoodCategoryName release];
	[virtualGoodCategoryLastUpdate release];


	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
- (id) init {
	if (self = [super init]) {

		self.virtualGoodCategoryID				= @"0";		self.virtualGoodCategoryName				= @"";
		virtualGoodCategoryLastUpdate				= [[[[NSDate alloc] initWithTimeIntervalSince1970:0] autorelease] retain];
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header{
	if (self = [self init]) {

		self.virtualGoodCategoryID               = [item objectForKey:KeyWithHeader(KEY_virtualGoodCategoryID, header)];
		self.virtualGoodCategoryName               = [item objectForKey:KeyWithHeader(KEY_virtualGoodCategoryName, header)];
		virtualGoodCategoryLastUpdate               = [[item objectForKey:KeyWithHeader(KEY_virtualGoodCategoryLastUpdate, header)] retain];

	}
	return self;
}

/*
*  init values from Object
*/
- (id) initWithObject:(VirtualGoodCategory *)object {
	if (self = [super init]) {

		self.virtualGoodCategoryID               = object.virtualGoodCategoryID;
		self.virtualGoodCategoryName               = object.virtualGoodCategoryName;
		virtualGoodCategoryLastUpdate               = [object.virtualGoodCategoryLastUpdate retain];

	}
	return self;
}

- (NSDictionary *) dictionaryRepresentation{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

	[dictionary addValue:virtualGoodCategoryID forKey:KEY_virtualGoodCategoryID];
	[dictionary addValue:virtualGoodCategoryName forKey:KEY_virtualGoodCategoryName];
	[dictionary addDateValue:virtualGoodCategoryLastUpdate forKey:KEY_virtualGoodCategoryLastUpdate];

	return [dictionary autorelease];
}

+ (NSDictionary *) getFields{
	NSMutableDictionary *fieldsDic = [[NSMutableDictionary alloc] init];
	
	[fieldsDic setValue:[NSString stringWithFormat:@"%@ %@",kTEXT_TYPE,kPRIMARY_KEY] forKey:KEY_virtualGoodCategoryID];
	[fieldsDic setValue:TypeAndDefaultValue(kTEXT_TYPE,@"''") forKey:KEY_virtualGoodCategoryName];
	[fieldsDic setValue:TypeAndDefaultValue(kDATETIME_TYPE,@"'1970-01-01 00:00:00'") forKey:KEY_virtualGoodCategoryLastUpdate];
	
	return [fieldsDic autorelease];
}

+ (NSDictionary *) getForeignKeys{
	NSMutableDictionary *foreignKeysDic = [[NSMutableDictionary alloc] init];

	
	return [foreignKeysDic autorelease];
}

+ (NSString *) getClassName{
	return kClassName;
}

+ (NSString *) getFieldName:(LiFields)field{
	NSString *fieldName;
	
	switch (field) {
		case VirtualGoodCategory_None:
			fieldName = @"pos";
			break;
	
		case VirtualGoodCategoryID:
			fieldName = KEY_virtualGoodCategoryID;
			break;

		case VirtualGoodCategoryName:
			fieldName = KEY_virtualGoodCategoryName;
			break;

		case VirtualGoodCategoryLastUpdate:
			fieldName = KEY_virtualGoodCategoryLastUpdate;
			break;

		default:
			NSLog(@"Wrong LiField numerator for %@ Class",kClassName);
			fieldName = nil;
			break;
	}
	
	return fieldName;
}


- (void) addValuesToRequest:(LiObjRequest **)request{
	[*request addValue:virtualGoodCategoryName forKey:KEY_virtualGoodCategoryName];
}


- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK{
	if (self = [super init]){
	
			self.virtualGoodCategoryID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodCategoryIDIndex])];
			self.virtualGoodCategoryName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodCategoryNameIndex])];
			virtualGoodCategoryLastUpdate = [[[LiCore liSqliteDateFormatter] dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, array[0][VirtualGoodCategoryLastUpdateIndex])]] retain];
		
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
	
	int **indexes = (int **)malloc(1*sizeof(int *));
	indexes[0] = (int *)malloc(NUM_OF_VIRTUALGOODCATEGORY_FIELDS*sizeof(int));

	indexes[0][VirtualGoodCategoryIDIndex] = [columnsArray indexOfObject:KEY_virtualGoodCategoryID];
	indexes[0][VirtualGoodCategoryNameIndex] = [columnsArray indexOfObject:KEY_virtualGoodCategoryName];
	indexes[0][VirtualGoodCategoryLastUpdateIndex] = [columnsArray indexOfObject:KEY_virtualGoodCategoryLastUpdate];

	[columnsArray release];
	NSMutableArray *blackList = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		NSString *ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, indexes[0][VirtualGoodCategoryIDIndex])];
		if (idsList.count && ([idsList indexOfObject:ID] == NSNotFound)){
			[blackList addObject:ID];
		} else {
			VirtualGoodCategory *item  = [[VirtualGoodCategory alloc] initWithStatement:stmt Array:(int **)indexes IsFK:FALSE];
			[result addObject:item];
			[item release];
		}
	}

	[LiObjRequest removeIDsList:blackList FromObject:kClassName];
	[blackList release];
	
	for (int i=0; i<1; i++) {
		free(indexes[i]);
	}
	free(indexes);
	
	return [result autorelease];
}


#pragma mark - End of Basic SDK

@end
