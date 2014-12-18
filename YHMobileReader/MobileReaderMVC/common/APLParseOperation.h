
extern NSString *kAddNetBookNotificationName;
extern NSString *kNetBookResultsKey;

extern NSString *kNetBookErrorNotificationName;
extern NSString *kNetBookMessageErrorKey;


@interface APLParseOperation : NSOperation

@property (copy, readonly) NSData *xmlData;

- (id)initWithData:(NSData *)parseData;

@end
