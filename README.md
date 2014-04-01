ObjectiveC-STL-Parser
=====================

Objective C Parser for STL Files. 

1. Add the following files to your project.
	STLParser.h	STLParser.m	STLParser.ym	STLPrimitives.h	STLTokenizer.lm
2. To parse the stl file call the parseFileWithFilePath method of STLParser class. To receive parsed data/syntax error exception your class should be a delegate of STLParser class. To achieve this you can use STLParserDelegate protocol and then you should add your instance to the parserDelegate observer array as in (B). Now in a background thread you may call the parseFileWithFilePath on the parser instance with the full path of the stl file as argument.

    Sample usage :
    	STLParser *parser=[[STLParser alloc] init]; //Allocates the parser

	[parser addParseDelegate:self]; // (B)

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 
                                             (unsigned long)NULL), ^(void) {
        	[parser parseFileWithFilePath:path];
    	});

3. Once the parsing is successful you will get a callback on (void) notifyParseSuccess:(STLData *) parsedData method and when the parsing fails you will get a callback on (void) notifyParseFailure:(NSString *) exceptionData. Be aware that when the parse succeeds you will get a parsedData reference. This is allocated in the heap. Do a free(parsedData) call whenever you are done with that data.

4. Make sure you release the parser instance of STLParser class in the dealloc method.

PS: Works only with ASCII STL files. 

