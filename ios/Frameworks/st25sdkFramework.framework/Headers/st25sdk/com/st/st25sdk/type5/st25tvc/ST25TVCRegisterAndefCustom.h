//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: st25sdk_ios/type5/st25tvc/ST25TVCRegisterAndefCustom.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom")
#ifdef RESTRICT_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom
#define INCLUDE_ALL_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom 0
#else
#define INCLUDE_ALL_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom 1
#endif
#undef RESTRICT_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom_) && (INCLUDE_ALL_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom || defined(INCLUDE_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom))
#define ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom_

#define RESTRICT_ComStSt25sdkType5STType5Register 1
#define INCLUDE_ComStSt25sdkType5STType5Register 1
#include "com/st/st25sdk/type5/STType5Register.h"

@class ComStSt25sdkCommandIso15693CustomCommand;
@class ComStSt25sdkSTRegister_RegisterAccessRights;
@class ComStSt25sdkSTRegister_RegisterDataSize;

@interface ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom : ComStSt25sdkType5STType5Register

#pragma mark Public

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                   withInt:(jint)registerAddress
                                                                   withInt:(jint)registerParameterAddress
                                                              withNSString:(NSString *)registerName
                                                              withNSString:(NSString *)registerContentDescription
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)registerAccessRights
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)registerDataSize;

- (jint)getAndefCustMsg;

+ (ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom *)newInstanceWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)iso15693CustomCommand
                                                                                                        withInt:(jint)registerParameterAddress OBJC_METHOD_FAMILY_NONE;

- (void)setAndefCustMsgWithInt:(jint)andefCustMsg;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)initWithComStSt25sdkCommandIso15693CustomCommand:(ComStSt25sdkCommandIso15693CustomCommand *)arg0
                                                                   withInt:(jint)arg1
                                                              withNSString:(NSString *)arg2
                                                              withNSString:(NSString *)arg3
                           withComStSt25sdkSTRegister_RegisterAccessRights:(ComStSt25sdkSTRegister_RegisterAccessRights *)arg4
                               withComStSt25sdkSTRegister_RegisterDataSize:(ComStSt25sdkSTRegister_RegisterDataSize *)arg5 NS_UNAVAILABLE;

@end

J2OBJC_EMPTY_STATIC_INIT(ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom)

FOUNDATION_EXPORT ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom *ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom_newInstanceWithComStSt25sdkCommandIso15693CustomCommand_withInt_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerParameterAddress);

FOUNDATION_EXPORT void ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom *self, ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, jint registerParameterAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

FOUNDATION_EXPORT ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom *new_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, jint registerParameterAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom *create_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom_initWithComStSt25sdkCommandIso15693CustomCommand_withInt_withInt_withNSString_withNSString_withComStSt25sdkSTRegister_RegisterAccessRights_withComStSt25sdkSTRegister_RegisterDataSize_(ComStSt25sdkCommandIso15693CustomCommand *iso15693CustomCommand, jint registerAddress, jint registerParameterAddress, NSString *registerName, NSString *registerContentDescription, ComStSt25sdkSTRegister_RegisterAccessRights *registerAccessRights, ComStSt25sdkSTRegister_RegisterDataSize *registerDataSize);

J2OBJC_TYPE_LITERAL_HEADER(ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_ComStSt25sdkType5St25tvcST25TVCRegisterAndefCustom")