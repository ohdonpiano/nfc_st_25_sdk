//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/command/PicopassCommand.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkCommandPicopassCommand")
#ifdef RESTRICT_ComStSt25sdkCommandPicopassCommand
#define INCLUDE_ALL_ComStSt25sdkCommandPicopassCommand 0
#else
#define INCLUDE_ALL_ComStSt25sdkCommandPicopassCommand 1
#endif
#undef RESTRICT_ComStSt25sdkCommandPicopassCommand

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkCommandPicopassCommand_) && (INCLUDE_ALL_ComStSt25sdkCommandPicopassCommand || defined(INCLUDE_ComStSt25sdkCommandPicopassCommand))
#define ComStSt25sdkCommandPicopassCommand_

#define RESTRICT_ComStSt25sdkCommandPicopassCommandInterface 1
#define INCLUDE_ComStSt25sdkCommandPicopassCommandInterface 1
#include "com/st/st25sdk/command/PicopassCommandInterface.h"

@class ComStSt25sdkCommandPicopassCommand_picopassRfMode;
@class IOSByteArray;
@protocol ComStSt25sdkRFReaderInterface;

@interface ComStSt25sdkCommandPicopassCommand : NSObject < ComStSt25sdkCommandPicopassCommandInterface > {
 @public
  id<ComStSt25sdkRFReaderInterface> mReaderInterface_;
  ComStSt25sdkCommandPicopassCommand_picopassRfMode *mPicopassRfFrameMode_;
  jbyte mM1M0Bits_;
}
@property (readonly, class) jbyte PICOPASS_INST_ACT NS_SWIFT_NAME(PICOPASS_INST_ACT);
@property (readonly, class) jbyte PICOPASS_INST_ACTALL NS_SWIFT_NAME(PICOPASS_INST_ACTALL);
@property (readonly, class) jbyte PICOPASS_INST_IDENTIFY NS_SWIFT_NAME(PICOPASS_INST_IDENTIFY);
@property (readonly, class) jbyte PICOPASS_INST_SELECT NS_SWIFT_NAME(PICOPASS_INST_SELECT);
@property (readonly, class) jbyte PICOPASS_INST_DETECT NS_SWIFT_NAME(PICOPASS_INST_DETECT);
@property (readonly, class) jbyte PICOPASS_INST_HALT NS_SWIFT_NAME(PICOPASS_INST_HALT);
@property (readonly, class) jbyte PICOPASS_INST_PAGESEL NS_SWIFT_NAME(PICOPASS_INST_PAGESEL);
@property (readonly, class) jbyte PICOPASS_INST_CHECK NS_SWIFT_NAME(PICOPASS_INST_CHECK);
@property (readonly, class) jbyte PICOPASS_INST_READCHECK NS_SWIFT_NAME(PICOPASS_INST_READCHECK);
@property (readonly, class) jbyte PICOPASS_INST_READBLOCK NS_SWIFT_NAME(PICOPASS_INST_READBLOCK);
@property (readonly, class) jbyte PICOPASS_INST_READ4BLOCK NS_SWIFT_NAME(PICOPASS_INST_READ4BLOCK);
@property (readonly, class) jbyte PICOPASS_INST_UPDATE NS_SWIFT_NAME(PICOPASS_INST_UPDATE);

+ (jbyte)PICOPASS_INST_ACT;

+ (jbyte)PICOPASS_INST_ACTALL;

+ (jbyte)PICOPASS_INST_IDENTIFY;

+ (jbyte)PICOPASS_INST_SELECT;

+ (jbyte)PICOPASS_INST_DETECT;

+ (jbyte)PICOPASS_INST_HALT;

+ (jbyte)PICOPASS_INST_PAGESEL;

+ (jbyte)PICOPASS_INST_CHECK;

+ (jbyte)PICOPASS_INST_READCHECK;

+ (jbyte)PICOPASS_INST_READBLOCK;

+ (jbyte)PICOPASS_INST_READ4BLOCK;

+ (jbyte)PICOPASS_INST_UPDATE;

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader;

- (instancetype __nonnull)initWithComStSt25sdkRFReaderInterface:(id<ComStSt25sdkRFReaderInterface>)reader
                                                       withByte:(jbyte)m1m0Value;

- (void)act;

- (void)actall;

- (IOSByteArray *)checkWithByteArray:(IOSByteArray *)challenge
                       withByteArray:(IOSByteArray *)readerSignature;

- (IOSByteArray *)detect;

- (jbyte)getM1M0Bits;

- (ComStSt25sdkCommandPicopassCommand_picopassRfMode *)getPicopassRfMode;

- (void)halt;

- (IOSByteArray *)identify;

- (IOSByteArray *)pageselWithByte:(jbyte)bookPage;

- (IOSByteArray *)readWithByte:(jbyte)address;

- (IOSByteArray *)read4WithByte:(jbyte)address;

- (IOSByteArray *)readCheckWithByte:(jbyte)address
                        withBoolean:(jboolean)isKc;

- (IOSByteArray *)selectWithByteArray:(IOSByteArray *)aSNBorSN;

- (IOSByteArray *)selectPicopassTag;

- (void)setM1M0BitsWithByte:(jbyte)m1m0Bits;

- (void)setPicopassRfModeWithByte:(jbyte)m1m0Value;

- (IOSByteArray *)updateWithByte:(jbyte)address
                   withByteArray:(IOSByteArray *)data;

- (IOSByteArray *)updateWithByte:(jbyte)address
                   withByteArray:(IOSByteArray *)data
                   withByteArray:(IOSByteArray *)sign;

#pragma mark Protected

- (jbyte)formatOpcodeByteWithByte:(jbyte)instruction
                      withBoolean:(jboolean)isKC;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkCommandPicopassCommand)

J2OBJC_FIELD_SETTER(ComStSt25sdkCommandPicopassCommand, mReaderInterface_, id<ComStSt25sdkRFReaderInterface>)
J2OBJC_FIELD_SETTER(ComStSt25sdkCommandPicopassCommand, mPicopassRfFrameMode_, ComStSt25sdkCommandPicopassCommand_picopassRfMode *)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_ACT(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_ACT 14
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_ACT, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_ACTALL(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_ACTALL 10
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_ACTALL, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_IDENTIFY(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_IDENTIFY 12
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_IDENTIFY, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_SELECT(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_SELECT 1
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_SELECT, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_DETECT(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_DETECT 15
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_DETECT, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_HALT(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_HALT 0
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_HALT, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_PAGESEL(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_PAGESEL 4
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_PAGESEL, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_CHECK(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_CHECK 5
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_CHECK, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_READCHECK(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_READCHECK 8
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_READCHECK, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_READBLOCK(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_READBLOCK 12
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_READBLOCK, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_READ4BLOCK(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_READ4BLOCK 6
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_READ4BLOCK, jbyte)

inline jbyte ComStSt25sdkCommandPicopassCommand_get_PICOPASS_INST_UPDATE(void);
#define ComStSt25sdkCommandPicopassCommand_PICOPASS_INST_UPDATE 7
J2OBJC_STATIC_FIELD_CONSTANT(ComStSt25sdkCommandPicopassCommand, PICOPASS_INST_UPDATE, jbyte)

FOUNDATION_EXPORT void ComStSt25sdkCommandPicopassCommand_initWithComStSt25sdkRFReaderInterface_(ComStSt25sdkCommandPicopassCommand *self, id<ComStSt25sdkRFReaderInterface> reader);

FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand *new_ComStSt25sdkCommandPicopassCommand_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand *create_ComStSt25sdkCommandPicopassCommand_initWithComStSt25sdkRFReaderInterface_(id<ComStSt25sdkRFReaderInterface> reader);

FOUNDATION_EXPORT void ComStSt25sdkCommandPicopassCommand_initWithComStSt25sdkRFReaderInterface_withByte_(ComStSt25sdkCommandPicopassCommand *self, id<ComStSt25sdkRFReaderInterface> reader, jbyte m1m0Value);

FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand *new_ComStSt25sdkCommandPicopassCommand_initWithComStSt25sdkRFReaderInterface_withByte_(id<ComStSt25sdkRFReaderInterface> reader, jbyte m1m0Value) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand *create_ComStSt25sdkCommandPicopassCommand_initWithComStSt25sdkRFReaderInterface_withByte_(id<ComStSt25sdkRFReaderInterface> reader, jbyte m1m0Value);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkCommandPicopassCommand)

#endif

#if !defined (ComStSt25sdkCommandPicopassCommand_picopassRfMode_) && (INCLUDE_ALL_ComStSt25sdkCommandPicopassCommand || defined(INCLUDE_ComStSt25sdkCommandPicopassCommand_picopassRfMode))
#define ComStSt25sdkCommandPicopassCommand_picopassRfMode_

#define RESTRICT_JavaLangEnum 1
#define INCLUDE_JavaLangEnum 1
#include "java/lang/Enum.h"

@class IOSObjectArray;

typedef NS_ENUM(NSUInteger, ComStSt25sdkCommandPicopassCommand_picopassRfMode_Enum) {
  ComStSt25sdkCommandPicopassCommand_picopassRfMode_Enum_PICOPASS_M1M0_00_MODE = 0,
  ComStSt25sdkCommandPicopassCommand_picopassRfMode_Enum_PICOPASS_M1M0_01_MODE = 1,
  ComStSt25sdkCommandPicopassCommand_picopassRfMode_Enum_PICOPASS_M1M0_10_MODE = 2,
  ComStSt25sdkCommandPicopassCommand_picopassRfMode_Enum_PICOPASS_M1M0_11_MODE = 3,
};

@interface ComStSt25sdkCommandPicopassCommand_picopassRfMode : JavaLangEnum

@property (readonly, class, nonnull) ComStSt25sdkCommandPicopassCommand_picopassRfMode *PICOPASS_M1M0_00_MODE NS_SWIFT_NAME(PICOPASS_M1M0_00_MODE);
@property (readonly, class, nonnull) ComStSt25sdkCommandPicopassCommand_picopassRfMode *PICOPASS_M1M0_01_MODE NS_SWIFT_NAME(PICOPASS_M1M0_01_MODE);
@property (readonly, class, nonnull) ComStSt25sdkCommandPicopassCommand_picopassRfMode *PICOPASS_M1M0_10_MODE NS_SWIFT_NAME(PICOPASS_M1M0_10_MODE);
@property (readonly, class, nonnull) ComStSt25sdkCommandPicopassCommand_picopassRfMode *PICOPASS_M1M0_11_MODE NS_SWIFT_NAME(PICOPASS_M1M0_11_MODE);
+ (ComStSt25sdkCommandPicopassCommand_picopassRfMode * __nonnull)PICOPASS_M1M0_00_MODE;

+ (ComStSt25sdkCommandPicopassCommand_picopassRfMode * __nonnull)PICOPASS_M1M0_01_MODE;

+ (ComStSt25sdkCommandPicopassCommand_picopassRfMode * __nonnull)PICOPASS_M1M0_10_MODE;

+ (ComStSt25sdkCommandPicopassCommand_picopassRfMode * __nonnull)PICOPASS_M1M0_11_MODE;

#pragma mark Public

+ (ComStSt25sdkCommandPicopassCommand_picopassRfMode *)valueOfWithNSString:(NSString *)name;

+ (IOSObjectArray *)values;

#pragma mark Package-Private

- (ComStSt25sdkCommandPicopassCommand_picopassRfMode_Enum)toNSEnum;

@end

J2OBJC_STATIC_INIT(ComStSt25sdkCommandPicopassCommand_picopassRfMode)

/*! INTERNAL ONLY - Use enum accessors declared below. */
FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_values_[];

inline ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_get_PICOPASS_M1M0_00_MODE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkCommandPicopassCommand_picopassRfMode, PICOPASS_M1M0_00_MODE)

inline ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_get_PICOPASS_M1M0_01_MODE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkCommandPicopassCommand_picopassRfMode, PICOPASS_M1M0_01_MODE)

inline ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_get_PICOPASS_M1M0_10_MODE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkCommandPicopassCommand_picopassRfMode, PICOPASS_M1M0_10_MODE)

inline ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_get_PICOPASS_M1M0_11_MODE(void);
J2OBJC_ENUM_CONSTANT(ComStSt25sdkCommandPicopassCommand_picopassRfMode, PICOPASS_M1M0_11_MODE)

FOUNDATION_EXPORT IOSObjectArray *ComStSt25sdkCommandPicopassCommand_picopassRfMode_values(void);

FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_valueOfWithNSString_(NSString *name);

FOUNDATION_EXPORT ComStSt25sdkCommandPicopassCommand_picopassRfMode *ComStSt25sdkCommandPicopassCommand_picopassRfMode_fromOrdinal(NSUInteger ordinal);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkCommandPicopassCommand_picopassRfMode)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkCommandPicopassCommand")