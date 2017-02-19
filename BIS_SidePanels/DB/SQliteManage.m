//
//  SQliteManage.m
//  BIS
//
//  Created by Harold Jinho YI on 13. 7. 2..
//
//

#import "SQliteManage.h"


@implementation SQLiteManage

- (id)init {
	if (self = [super init]) {
		_db = nil;
		retryTimeout = 1;
	}
	
	return self;
}

- (void) copyFileInBundleToDocumentsFolder:(NSString *)fileName withExtension:(NSString *)ext {
    
    //Fetch Directory of Documents Folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

    //Fetch Directory of File witch copy to folder
    sqliteDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:fileName]];
    
    sqliteDBPath = [sqliteDBPath stringByAppendingString:@"."];
    sqliteDBPath = [sqliteDBPath stringByAppendingString:ext];
    
    //Check existed File in Document Folder
    //if no File, Copy from bundle
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:sqliteDBPath]){
        //Fetch directory of file in bundle
        NSString *pathToFileInBundle = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        
        //copy file from bundle to documents folder
        NSError *error = nil;
        bool success = [fileManager copyItemAtPath:pathToFileInBundle toPath:sqliteDBPath error:&error];
        if (success) {
            NSLog(@"File Copied");
        } else {
            NSLog([error localizedDescription]);
        }
    }
}

//For using the DB, Open the DB File
#pragma mark -
#pragma mark SQLite open/close
- (BOOL)open {
	[self close];
	[self copyFileInBundleToDocumentsFolder:@"database" withExtension:@"sqlite"];
	if (sqlite3_open([sqliteDBPath fileSystemRepresentation], &_db) != SQLITE_OK) {
		//Logger(@"sqlite3_errmsg [%s]", sqlite3_errmsg(_db));
		return NO;
	}
	
	return YES;
}

//close the opened db
- (void)close {
	if (_db == nil) return;
	
	int numOfRetries = 0;
	int rc;
	
	do {
		rc = sqlite3_close(_db);
		
		if (rc == SQLITE_OK) {
			break;
		} else if (rc == SQLITE_BUSY) {
			usleep(20);
			
			if (numOfRetries == retryTimeout) {
				//Logger(@"SQLite busy, unable to close");
				break;
			}
		} else {
			//Logger(@"sqlite3_errmsg [%s]", sqlite3_errmsg(_db));
			break;
		}
	} while (numOfRetries++ > retryTimeout);
	
	_db = nil;
}

//Search that Content of DB by using SQL(Query)
#pragma mark -
- (NSArray *)executeQuery:(NSString *)sql, ... {
	va_list args;
	va_start(args, sql);
	
	NSMutableArray *argsArray = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [sql length]; i++) {
		
		if ([sql characterAtIndex:i] == '?')
			[argsArray addObject:va_arg(args, id)];
	}
	
	va_end(args);
	
	NSArray *result = [self executeQuery:sql arguments:argsArray];
    return result;
}

//Search that Data of DB by using SQL(Query)
- (NSArray *)executeQuery:(NSString *)sql arguments:(NSArray *)args {
	sqlite3_stmt *sqlStmt;
	
	if (![self prepareSql:sql inStatament:(&sqlStmt)])
		return nil;
	
	//Bind that argument separated by data type
	{
		int i = 0;
		int queryParamCount = sqlite3_bind_parameter_count(sqlStmt);
		
		while (i++ < queryParamCount) {
			[self bindObject:[args objectAtIndex:(i - 1)] toColumn:i inStatament:sqlStmt];
		}
	}
	
	NSMutableArray *arrayList = [[NSMutableArray alloc] init];
	int columnCount = sqlite3_column_count(sqlStmt);
	
	while ([self hasMoreData:sqlStmt]) {
		
		NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
		
		for (int i = 0; i < columnCount; i++) {
			
			id columnName = [self columnName:sqlStmt columnIndex:i];
			id columnValue = [self columnValue:sqlStmt columnIndex:i];
			
			if ([columnValue isKindOfClass:[NSString class]]) {
				NSString *decodedString = [NSString stringWithUTF8String:[(NSString*)columnValue cStringUsingEncoding:[NSString defaultCStringEncoding]]];
				[dictionary setObject:decodedString forKey:columnName];
			} else {
				[dictionary setObject:columnValue forKey:columnName];
			}
		}
		[arrayList addObject:dictionary];
	}
	sqlite3_finalize(sqlStmt);
	
	return arrayList;
}

//Ready to DB
- (BOOL)prepareSql:(NSString *)sql inStatament:(sqlite3_stmt **)stmt {
	//Logger(@"sql [%@]", sql);
	
	int numOfRetries = 0;
	int rc;
	
	do {
		rc = sqlite3_prepare_v2(_db, [sql UTF8String], -1, stmt, NULL);
		
		if (rc == SQLITE_OK) {
			return YES;
		} else if (rc == SQLITE_BUSY) {
			usleep(20);
			
			if (numOfRetries == retryTimeout) {
				//Logger(@"SQLite busy, unable to close");
				break;
			}
		} else {
			//Logger(@"sqlite3_errmsg [%s]", sqlite3_errmsg(_db));
			break;
		}
	} while (numOfRetries++ > retryTimeout);
	
	return NO;
}

//Separate that argument of Query
#pragma mark -
- (BOOL)executeUpdate:(NSString *)sql, ... {
	va_list args;
	va_start(args, sql);
	
	NSMutableArray *argsArray = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [sql length]; i++) {
		
		if ([sql characterAtIndex:i] == '?')
			[argsArray addObject:va_arg(args, id)];
	}
	
	va_end(args);
    
	BOOL result = [self executeUpdate:sql arguments:argsArray];
	
	return result;
}

//Reflect Data to DB
- (BOOL)executeUpdate:(NSString *)sql arguments:(NSArray *)args {
	sqlite3_stmt *sqlStmt;
	
	if (![self prepareSql:sql inStatament:(&sqlStmt)])
		return NO;
	
	//Bind that argument separated by data type in statment
	{
		int i = 0;
		int queryParamCount = sqlite3_bind_parameter_count(sqlStmt);
		
		while (i++ < queryParamCount) {
			[self bindObject:[args objectAtIndex:(i - 1)] toColumn:i inStatament:sqlStmt];
		}
	}
	
	BOOL result = [self executeStatament:sqlStmt];
	
	sqlite3_finalize(sqlStmt);
	
	return result;
}

//Run query and Check the success
- (BOOL)executeStatament:(sqlite3_stmt *)stmt {
	int numOfRetries = 0;
	int rc;
	
	do {
		rc = sqlite3_step(stmt);
		if (rc == SQLITE_OK || rc == SQLITE_DONE) {
			return YES;
		} else if (rc == SQLITE_BUSY) {
			usleep(20);
			
			if (numOfRetries == retryTimeout) {
				//Logger(@"SQLite busy, unable to close");
				break;
			}
		} else {
			//Logger(@"sqlite3_errmsg [%s]", sqlite3_errmsg(_db));
			break;
		}
	} while (numOfRetries++ > retryTimeout);
	
	return NO;
}


#pragma mark -

//Bind that argument separated by data type in statement
- (void)bindObject:(id)obj toColumn:(int)idx inStatament:(sqlite3_stmt *)stmt {
	if (obj == nil || obj == [NSNull null]) {
		sqlite3_bind_null(stmt, idx);
	} else if ([obj isKindOfClass:[NSData class]]) {
		sqlite3_bind_blob(stmt, idx, [obj bytes], [obj length], SQLITE_STATIC);
	} else if ([obj isKindOfClass:[NSDate class]]) {
		sqlite3_bind_double(stmt, idx, [obj timeIntervalSince1970]);
	} else if ([obj isKindOfClass:[NSNumber class]]) {
		if (!strcmp([obj objCType], @encode(BOOL))) {
			sqlite3_bind_int(stmt, idx, [obj boolValue] ? 1 : 0);
		} else if (!strcmp([obj objCType], @encode(int))) {
			sqlite3_bind_int64(stmt, idx, [obj longValue]);
		} else if (!strcmp([obj objCType], @encode(long))) {
			sqlite3_bind_int64(stmt, idx, [obj longValue]);
		} else if (!strcmp([obj objCType], @encode(float))) {
			sqlite3_bind_double(stmt, idx, [obj floatValue]);
		} else if (!strcmp([obj objCType], @encode(double))) {
			sqlite3_bind_double(stmt, idx, [obj doubleValue]);
		} else {
			sqlite3_bind_text(stmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
		}
	} else {
		sqlite3_bind_text(stmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
	}
}

//Check the more data
- (BOOL)hasMoreData:(sqlite3_stmt *)stmt {
	int numOfRetries = 0;
	int rc;
	
	do {
		rc = sqlite3_step(stmt);
		
		if (rc == SQLITE_ROW) {
			return YES;
            
		} else if (rc == SQLITE_DONE) {
			break;
            
		} else if (rc == SQLITE_BUSY) {
			usleep(20);
			
			if (numOfRetries == retryTimeout) {
				//Logger(@"SQLite busy, unable to close");
				break;
			}
		} else {
			//Logger(@"sqlite3_errmsg [%s]", sqlite3_errmsg(_db));
			break;
		}
	} while (numOfRetries++ > retryTimeout);
	
	return NO;
}

#pragma mark -

//Return separated data by data type  in column
- (id)columnValue:(sqlite3_stmt *)stmt columnIndex:(NSInteger)index {
	int columnType = sqlite3_column_type(stmt, index);
	
	if (columnType == SQLITE_NULL) {
		return([NSNull null]);
        
	} else if (columnType == SQLITE_INTEGER) {
		return [NSNumber numberWithInt:sqlite3_column_int(stmt, index)];
        
	} else if (columnType == SQLITE_FLOAT) {
		return [NSNumber numberWithDouble:sqlite3_column_double(stmt, index)];
        
	} else if (columnType == SQLITE_TEXT) {
		const unsigned char *text = sqlite3_column_text(stmt, index);
		
		return [NSString stringWithFormat:@"%s", text];
		
	} else if (columnType == SQLITE_BLOB) {
		int nbytes = sqlite3_column_bytes(stmt, index);
		const char *bytes = sqlite3_column_blob(stmt, index);
		
		return [NSData dataWithBytes:bytes length:nbytes];
		
	} else {
		return nil;
	}
}

//Return that searched name of Column
- (NSString *)columnName:(sqlite3_stmt *)stmt columnIndex:(NSInteger)index {
	return [NSString stringWithUTF8String:sqlite3_column_name(stmt, index)];
}

@end
