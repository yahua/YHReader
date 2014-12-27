
#import "APLParseOperation.h"
#import "NetBook.h"

// NSNotification name for sending earthquake data back to the app delegate
NSString *kAddNetBookNotificationName = @"AddNetBookNotif";

// NSNotification userInfo key for obtaining the earthquake data
NSString *kNetBookResultsKey = @"NetBookResultsKey";

// NSNotification name for reporting errors
NSString *kNetBookErrorNotificationName = @"NetBookErrorNotif";

// NSNotification userInfo key for obtaining the error message
NSString *kNetBookMessageErrorKey = @"NetBookMsgErrorKey";


@interface APLParseOperation () <NSXMLParserDelegate>

@property (nonatomic, strong) NetBook *currentObject;
@property (nonatomic, strong) NSMutableArray *parseObjectArray;
@property (nonatomic, strong) NSMutableString *currentParsedCharacter;

@end


@implementation APLParseOperation

- (id)initWithData:(NSData *)parseData {
    
    self = [super init];
    if (self) {
        
        _xmlData= [parseData copy];
        self.parseObjectArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)addEarthquakesToList:(NSArray *)earthquakes {
    
    assert([NSThread isMainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddNetBookNotificationName object:self userInfo:@{kNetBookResultsKey: earthquakes}];
}


// The main function for this NSOperation, to start the parsing.
- (void)main {
    
    /*
     It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not desirable because it gives less control over the network, particularly in responding to connection errors.
     */
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
    [parser setDelegate:self];
    [parser parse];
    
    /*
     Depending on the total number of earthquakes parsed, the last batch might not have been a "full" batch, and thus not been part of the regular batch transfer. So, we check the count of the array and, if necessary, send it to the main thread.
     */
    if ([self.parseObjectArray count] > 0) {
        [self performSelectorOnMainThread:@selector(addEarthquakesToList:) withObject:self.parseObjectArray waitUntilDone:NO];
    }
}


#pragma mark - Parser constants

/*
 When an Earthquake object has been fully constructed, it must be passed to the main thread and the table view in RootViewController must be reloaded to display it. It is not efficient to do this for every Earthquake object - the overhead in communicating between the threads and reloading the table exceed the benefit to the user. Instead, we pass the objects in batches, sized by the constant below. In your application, the optimal batch size will vary depending on the amount of data in the object and other factors, as appropriate.
 */
static NSUInteger const kSizeOfEarthquakeBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kEntryElementName = @"book";
static NSString * const kBookName = @"bookName";
static NSString * const kImageName = @"bookImgName";

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.currentParsedCharacter = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:kEntryElementName]) {
        NetBook *netBook = [[NetBook alloc] init];
        self.currentObject = netBook;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kEntryElementName]) {
    
        [self.parseObjectArray addObject:self.currentObject];
        if ([self.parseObjectArray count] >= kSizeOfEarthquakeBatch) {
            [self performSelectorOnMainThread:@selector(addEarthquakesToList:) withObject:self.parseObjectArray waitUntilDone:NO];
            self.parseObjectArray = [NSMutableArray array];
        }
    }
    else if ([elementName isEqualToString:kBookName]) {
        self.currentObject.bookName = self.currentParsedCharacter;
    }
    else if ([elementName isEqualToString:kImageName]) {
        self.currentObject.bookImageName = self.currentParsedCharacter;
    }
    self.currentParsedCharacter = nil;
}

/**
 This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to accumulate character data until the end of the element is reached.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    [self.currentParsedCharacter appendString:string];
}

/** 
 An error occurred while parsing the earthquake data: post the error as an NSNotification to our app delegate.
 */ 
- (void)handleEarthquakesError:(NSError *)parseError {

    assert([NSThread isMainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetBookErrorNotificationName object:self userInfo:@{kNetBookMessageErrorKey: parseError}];
}

/**
 An error occurred while parsing the earthquake data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of earthquakes.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
     
    if ([parseError code] != NSXMLParserDelegateAbortedParseError) {
        [self performSelectorOnMainThread:@selector(handleEarthquakesError:) withObject:parseError waitUntilDone:NO];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if ([self.parseObjectArray count] > 0) {
        [self performSelectorOnMainThread:@selector(addEarthquakesToList:) withObject:self.parseObjectArray waitUntilDone:NO];
        self.parseObjectArray = [NSMutableArray array];
    }
}

@end
