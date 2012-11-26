//
//  STLParser.h
//  HelloOpenGL
//
//  Created by Deepak G Krishnan on 22/11/12.
//  Copyright (c) 2012 dgkris@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLPrimitives.h"

@protocol STLParserDelegate;

@interface STLParser : NSObject {
    FILE   * fileHandle;
    NSLock * mutexLock;
    char   * fileData;
    long double handlePosition;
    NSMutableArray *parseDelegates;
}

-(int)  yyinputToBuffer:(char* )theBuffer withSize:(int)maxSize;
-(void) parseFileWithFilePath:(NSString *) filePath;

-(void) addParseDelegate:(id<STLParserDelegate>) delegate;
-(void) removeAllDelegates;
-(void) removeDelegate:(id<STLParserDelegate>) delegate;

@end

@protocol STLParserDelegate <NSObject>

@required
-(void) notifyParseSuccess:(STLData *) parsedData;
-(void) notifyParseFailure:(NSString *) exceptionData;
@end



