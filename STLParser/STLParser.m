//
//  STLParser.m
//  HelloOpenGL
//
//  Created by Deepak G Krishnan on 22/11/12.
//  Copyright (c) 2012 dgkris@gmail.com. All rights reserved.
//

#import "STLParser.h"

void yyparse();
void yyrestart();
void yyreset_state();

@implementation STLParser
@class STLParserDelegate;

STLParser * parser;

-(id) init {
    if(self=[super init]) {
        
    }
    parseDelegates=[[NSMutableArray alloc] init];
    return self;
}

-(void) addParseDelegate:(id<STLParserDelegate>) delegate {
    [parseDelegates addObject:delegate];
}

-(void) removeAllDelegates {
    [parseDelegates removeAllObjects];
}

-(void) removeDelegate:(id<STLParserDelegate>) delegate {
    [parseDelegates removeObject:delegate];
}


-(void) parseFileWithFilePath:(NSString *) filePath {
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        parser=self;
        fileHandle = fopen([filePath UTF8String],"r");
        [self parse];
        fclose(fileHandle);
    } else {
        [self notifyFailureToAll:[NSString stringWithFormat:@"File not found :%@",filePath]];
    }
}

-(void )parse {
    [mutexLock lock];
    
    @try {
        yyreset_state();
        yyrestart(NULL);
        yyparse();
    }
    @catch(NSException* theException) {
        [self notifyFailureToAll:theException.reason];
    }
    @finally {
        [mutexLock unlock];
        fclose(fileHandle);
    }
}

-(void) dealloc {
    [parseDelegates release];
    [super dealloc];
}


-(int) yyinputToBuffer:(char *)theBuffer withSize:(int)maxSize {
    int copySize = 0;
    copySize=fread(theBuffer, 1, maxSize, fileHandle);
    return copySize;
}

-(void) notifySuccessToAll:(STLData *) parsedData {
    NSEnumerator *delegatesEnum=[parseDelegates objectEnumerator];
    STLParserDelegate *delegate;
    while(delegate=[delegatesEnum nextObject]) {
        [delegate notifyParseSuccess:parsedData];
    }
}
         
-(void) notifyFailureToAll:(NSString *) errorMsg {
    NSEnumerator *delegatesEnum=[parseDelegates objectEnumerator];
    STLParserDelegate *delegate;
    while(delegate=[delegatesEnum nextObject]) {
        [delegate notifyParseFailure:errorMsg];
    }
}

int yyYYINPUT(char * theBuffer,int maxSize) {
    return [parser yyinputToBuffer:theBuffer withSize:maxSize];
}

void sendParsedData(STLData *stlData) {
    [parser notifySuccessToAll:stlData];
}

void sendFailedMessage(char *exceptionMsg) {
    [parser notifyFailureToAll:[NSString stringWithUTF8String:exceptionMsg]];
}

@end
