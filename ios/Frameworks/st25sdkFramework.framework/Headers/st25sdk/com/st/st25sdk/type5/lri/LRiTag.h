//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/lri/LRiTag.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5LriLRiTag")
#ifdef RESTRICT_ComStSt25sdkType5LriLRiTag
#define INCLUDE_ALL_ComStSt25sdkType5LriLRiTag 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5LriLRiTag 1
#endif
#undef RESTRICT_ComStSt25sdkType5LriLRiTag

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5LriLRiTag_) && (INCLUDE_ALL_ComStSt25sdkType5LriLRiTag || defined(INCLUDE_ComStSt25sdkType5LriLRiTag))
#define ComStSt25sdkType5LriLRiTag_

#define RESTRICT_ComStSt25sdkType5STType5Tag 1
#define INCLUDE_ComStSt25sdkType5STType5Tag 1
#include "com/st/st25sdk/type5/STType5Tag.h"

#define RESTRICT_ComStSt25sdkCommandIso15693CustomKillCommandInterface 1
#define INCLUDE_ComStSt25sdkCommandIso15693CustomKillCommandInterface 1
#include "com/st/st25sdk/command/Iso15693CustomKillCommandInterface.h"

@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkType5LriLRiTag : ComStSt25sdkType5STType5Tag < ComStSt25sdkCommandIso15693CustomKillCommandInterface >

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)readerInterface
                                                  withByteArray:(IOSByteArray *)uid;

- (IOSByteArray *)fastInitiateWithByte:(jbyte)flag;

- (IOSByteArray *)fastInventoryInitiatedWithByte:(jbyte)flag;

- (IOSByteArray *)fastInventoryInitiatedWithByte:(jbyte)flag
                                        withByte:(jbyte)maskLength
                                   withByteArray:(IOSByteArray *)maskValue;

- (IOSByteArray *)fastInventoryInitiatedWithByte:(jbyte)flag
                                        withByte:(jbyte)maskLength
                                   withByteArray:(IOSByteArray *)maskValue
                                        withByte:(jbyte)afiField;

- (IOSByteArray *)initiateWithByte:(jbyte)flag OBJC_METHOD_FAMILY_NONE;

- (IOSByteArray *)inventoryInitiatedWithByte:(jbyte)flag;

- (IOSByteArray *)inventoryInitiatedWithByte:(jbyte)flag
                                    withByte:(jbyte)maskLength
                               withByteArray:(IOSByteArray *)maskValue;

- (IOSByteArray *)inventoryInitiatedWithByte:(jbyte)flag
                                    withByte:(jbyte)maskLength
                               withByteArray:(IOSByteArray *)maskValue
                                    withByte:(jbyte)afiField;

- (jbyte)killWithByteArray:(IOSByteArray *)unencryptedKillCode;

- (jbyte)lockKill;

- (jbyte)writeKillWithByteArray:(IOSByteArray *)unencryptedKillPassword;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5LriLRiTag)

FOUNDATION_EXPORT void ComStSt25sdkType5LriLRiTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(ComStSt25sdkType5LriLRiTag *self, id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid);

FOUNDATION_EXPORT ComStSt25sdkType5LriLRiTag *new_ComStSt25sdkType5LriLRiTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5LriLRiTag *create_ComStSt25sdkType5LriLRiTag_initWithComStSt25sdkRFReaderInterface_withByteArray_(id<ComStSt25sdkRFReaderInterface> readerInterface, IOSByteArray *uid);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5LriLRiTag)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5LriLRiTag")