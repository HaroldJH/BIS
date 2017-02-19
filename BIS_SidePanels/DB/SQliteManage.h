//
//  SQliteManage.h
//  BIS
//
//  Created by Harold Jinho YI on 13. 7. 2..
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <unistd.h>
#import "ExampleSQLite_Prefix.pch"

@interface SQLiteManage : NSObject {
	
	NSInteger retryTimeout;
	sqlite3 *_db;
    NSString *sqliteDBPath;
}

- (void) copyFileInBundleToDocumentsFolder:(NSString *) fileName withExtension:(NSString *)ext;
- (BOOL)open;
- (void)close;

- (NSArray *)executeQuery:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql arguments:(NSArray *)args;
- (BOOL)prepareSql:(NSString *)sql inStatament:(sqlite3_stmt **)stmt;

- (BOOL)executeUpdate:(NSString *)sql, ...;
- (BOOL)executeUpdate:(NSString *)sql arguments:(NSArray *)args;
- (BOOL)executeStatament:(sqlite3_stmt *)stmt;

- (id)columnValue:(sqlite3_stmt *)stmt columnIndex:(NSInteger)index;
- (NSString *)columnName:(sqlite3_stmt *)stmt columnIndex:(NSInteger)index;

- (void)bindObject:(id)obj toColumn:(int)idx inStatament:(sqlite3_stmt *)stmt;
- (BOOL)hasMoreData:(sqlite3_stmt *)stmt;

@end
