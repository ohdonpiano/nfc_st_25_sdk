//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: android/platform/external/icu/android_icu4j/src/main/java/android/icu/math/MathContext.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_AndroidIcuMathMathContext")
#ifdef RESTRICT_AndroidIcuMathMathContext
#define INCLUDE_ALL_AndroidIcuMathMathContext 0
#else
#define INCLUDE_ALL_AndroidIcuMathMathContext 1
#endif
#undef RESTRICT_AndroidIcuMathMathContext

#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (AndroidIcuMathMathContext_) && (INCLUDE_ALL_AndroidIcuMathMathContext || defined(INCLUDE_AndroidIcuMathMathContext))
#define AndroidIcuMathMathContext_

#define RESTRICT_JavaIoSerializable 1
#define INCLUDE_JavaIoSerializable 1
#include "java/io/Serializable.h"

/*!
 @brief The <code>MathContext</code> immutable class encapsulates the
  settings understood by the operator methods of the <code>BigDecimal</code>
  class (and potentially other classes).Operator methods are those
  that effect an operation on a number or a pair of numbers.
 <p>
  The settings, which are not base-dependent, comprise: 
 <ol>
  <li><code>digits</code>:
  the number of digits (precision) to be used for an operation 
 <li><code>form</code>:
  the form of any exponent that results from the operation 
 <li><code>lostDigits</code>:
  whether checking for lost digits is enabled 
 <li><code>roundingMode</code>:
  the algorithm to be used for rounding. 
 </ol>
  <p>
  When provided, a <code>MathContext</code> object supplies the
  settings for an operation directly. 
 <p>
  When <code>MathContext.DEFAULT</code> is provided for a 
 <code>MathContext</code> parameter then the default settings are used
  (<code>9, SCIENTIFIC, false, ROUND_HALF_UP</code>).
  <p>
  In the <code>BigDecimal</code> class, all methods which accept a 
 <code>MathContext</code> object defaults) also have a version of the
  method which does not accept a MathContext parameter.  These versions
  carry out unlimited precision fixed point arithmetic (as though the
  settings were (<code>0, PLAIN, false, ROUND_HALF_UP</code>).
  <p>
  The instance variables are shared with default access (so they are
  directly accessible to the <code>BigDecimal</code> class), but must
  never be changed. 
 <p>
  The rounding mode constants have the same names and values as the
  constants of the same name in <code>java.math.BigDecimal</code>, to
  maintain compatibility with earlier versions of 
 <code>BigDecimal</code>.
 - seealso: BigDecimal
 @author Mike Cowlishaw
 */
@interface AndroidIcuMathMathContext : NSObject < JavaIoSerializable > {
 @public
  /*!
   @brief The number of digits (precision) to be used for an operation.
   A value of 0 indicates that unlimited precision (as many digits
  as are required) will be used. 
 <p>
  The <code>BigDecimal</code> operator methods use this value to
  determine the precision of results.
  Note that leading zeros (in the integer part of a number) are
  never significant. 
 <p>
  <code>digits</code> will always be non-negative.
   */
  jint digits_;
  /*!
   @brief The form of results from an operation.
   <p>
  The <code>BigDecimal</code> operator methods use this value to
  determine the form of results, in particular whether and how
  exponential notation should be used.
   - seealso: #ENGINEERING
   - seealso: #PLAIN
   - seealso: #SCIENTIFIC
   */
  jint form_;
  /*!
   @brief Controls whether lost digits checking is enabled for an
  operation.
   Set to <code>true</code> to enable checking, or to 
 <code>false</code> to disable checking. 
 <p>
  When enabled, the <code>BigDecimal</code> operator methods check
  the precision of their operand or operands, and throw an 
 <code>ArithmeticException</code> if an operand is more precise
  than the digits setting (that is, digits would be lost).
  When disabled, operands are rounded to the specified digits.
   */
  jboolean lostDigits_;
  /*!
   @brief The rounding algorithm to be used for an operation.
   <p>
  The <code>BigDecimal</code> operator methods use this value to
  determine the algorithm to be used when non-zero digits have to
  be discarded in order to reduce the precision of a result.
  The value must be one of the public constants whose name starts
  with <code>ROUND_</code>.
   - seealso: #ROUND_CEILING
   - seealso: #ROUND_DOWN
   - seealso: #ROUND_FLOOR
   - seealso: #ROUND_HALF_DOWN
   - seealso: #ROUND_HALF_EVEN
   - seealso: #ROUND_HALF_UP
   - seealso: #ROUND_UNNECESSARY
   - seealso: #ROUND_UP
   */
  jint roundingMode_;
}
@property (readonly, class) jint PLAIN NS_SWIFT_NAME(PLAIN);
@property (readonly, class) jint SCIENTIFIC NS_SWIFT_NAME(SCIENTIFIC);
@property (readonly, class) jint ENGINEERING NS_SWIFT_NAME(ENGINEERING);
@property (readonly, class) jint ROUND_CEILING NS_SWIFT_NAME(ROUND_CEILING);
@property (readonly, class) jint ROUND_DOWN NS_SWIFT_NAME(ROUND_DOWN);
@property (readonly, class) jint ROUND_FLOOR NS_SWIFT_NAME(ROUND_FLOOR);
@property (readonly, class) jint ROUND_HALF_DOWN NS_SWIFT_NAME(ROUND_HALF_DOWN);
@property (readonly, class) jint ROUND_HALF_EVEN NS_SWIFT_NAME(ROUND_HALF_EVEN);
@property (readonly, class) jint ROUND_HALF_UP NS_SWIFT_NAME(ROUND_HALF_UP);
@property (readonly, class) jint ROUND_UNNECESSARY NS_SWIFT_NAME(ROUND_UNNECESSARY);
@property (readonly, class) jint ROUND_UP NS_SWIFT_NAME(ROUND_UP);
@property (readonly, class, strong) AndroidIcuMathMathContext *DEFAULT NS_SWIFT_NAME(DEFAULT);

+ (jint)PLAIN;

+ (jint)SCIENTIFIC;

+ (jint)ENGINEERING;

+ (jint)ROUND_CEILING;

+ (jint)ROUND_DOWN;

+ (jint)ROUND_FLOOR;

+ (jint)ROUND_HALF_DOWN;

+ (jint)ROUND_HALF_EVEN;

+ (jint)ROUND_HALF_UP;

+ (jint)ROUND_UNNECESSARY;

+ (jint)ROUND_UP;

+ (AndroidIcuMathMathContext *)DEFAULT;

#pragma mark Public

/*!
 @brief Constructs a new <code>MathContext</code> with a specified
  precision.
 The other settings are set to the default values
  (see <code>DEFAULT</code>).
  An <code>IllegalArgumentException</code> is thrown if the 
 <code>setdigits</code> parameter is out of range
  (&lt;0 or &gt;999999999).
 @param setdigits The  <code> int </code>  digits setting                       for this 
  <code> MathContext </code> .
 @throw IllegalArgumentExceptionparameter out of range.
 */
- (instancetype __nonnull)initWithInt:(jint)setdigits;

/*!
 @brief Constructs a new <code>MathContext</code> with a specified
  precision and form.
 The other settings are set to the default values
  (see <code>DEFAULT</code>).
  An <code>IllegalArgumentException</code> is thrown if the 
 <code>setdigits</code> parameter is out of range
  (&lt;0 or &gt;999999999), or if the value given for the 
 <code>setform</code> parameter is not one of the appropriate
  constants.
 @param setdigits The  <code> int </code>  digits setting                       for this 
  <code> MathContext </code> .
 @param setform The  <code> int </code>  form setting                       for this 
  <code> MathContext </code> .
 @throw IllegalArgumentExceptionparameter out of range.
 */
- (instancetype __nonnull)initWithInt:(jint)setdigits
                              withInt:(jint)setform;

/*!
 @brief Constructs a new <code>MathContext</code> with a specified
  precision, form, and lostDigits setting.
 The roundingMode setting is set to its default value
  (see <code>DEFAULT</code>).
  An <code>IllegalArgumentException</code> is thrown if the 
 <code>setdigits</code> parameter is out of range
  (&lt;0 or &gt;999999999), or if the value given for the 
 <code>setform</code> parameter is not one of the appropriate
  constants.
 @param setdigits The  <code> int </code>  digits setting                       for this 
  <code> MathContext </code> .
 @param setform The  <code> int </code>  form setting                       for this 
  <code> MathContext </code> .
 @param setlostdigits The  <code> boolean </code>  lostDigits
                        setting for this  <code> MathContext </code>
  .
 @throw IllegalArgumentExceptionparameter out of range.
 */
- (instancetype __nonnull)initWithInt:(jint)setdigits
                              withInt:(jint)setform
                          withBoolean:(jboolean)setlostdigits;

/*!
 @brief Constructs a new <code>MathContext</code> with a specified
  precision, form, lostDigits, and roundingMode setting.
 An <code>IllegalArgumentException</code> is thrown if the 
 <code>setdigits</code> parameter is out of range
  (&lt;0 or &gt;999999999), or if the value given for the 
 <code>setform</code> or <code>setroundingmode</code> parameters is
  not one of the appropriate constants.
 @param setdigits The  <code> int </code>  digits setting                         for this 
  <code> MathContext </code> .
 @param setform The  <code> int </code>  form setting                         for this 
  <code> MathContext </code> .
 @param setlostdigits The  <code> boolean </code>  lostDigits
                          setting for this  <code> MathContext </code>
  .
 @param setroundingmode The  <code> int </code>  roundingMode setting
                          for this  <code> MathContext </code>
  .
 @throw IllegalArgumentExceptionparameter out of range.
 */
- (instancetype __nonnull)initWithInt:(jint)setdigits
                              withInt:(jint)setform
                          withBoolean:(jboolean)setlostdigits
                              withInt:(jint)setroundingmode;

/*!
 @brief Returns the digits setting.
 This value is always non-negative.
 @return an <code>int</code> which is the value of the digits
          setting
 */
- (jint)getDigits;

/*!
 @brief Returns the form setting.
 This will be one of 
 <code>ENGINEERING</code>,
  <code>PLAIN</code>, or 
 <code>SCIENTIFIC</code>.
 @return an <code>int</code> which is the value of the form setting
 */
- (jint)getForm;

/*!
 @brief Returns the lostDigits setting.
 This will be either <code>true</code> (enabled) or 
 <code>false</code> (disabled).
 @return a <code>boolean</code> which is the value of the lostDigits
            setting
 */
- (jboolean)getLostDigits;

/*!
 @brief Returns the roundingMode setting.
 This will be one of 
 <code>ROUND_CEILING</code>,
  <code>ROUND_DOWN</code>,
  <code>ROUND_FLOOR</code>,
  <code>ROUND_HALF_DOWN</code>,
  <code>ROUND_HALF_EVEN</code>,
  <code>ROUND_HALF_UP</code>,
  <code>ROUND_UNNECESSARY</code>, or 
 <code>ROUND_UP</code>.
 @return an <code>int</code> which is the value of the roundingMode
          setting
 */
- (jint)getRoundingMode;

/*!
 @brief Returns the <code>MathContext</code> as a readable string.
 The <code>String</code> returned represents the settings of the 
 <code>MathContext</code> object as four blank-delimited words
  separated by a single blank and with no leading or trailing blanks,
  as follows: 
 <ol>
  <li>
  <code>digits=</code>, immediately followed by
  the value of the digits setting as a numeric word. 
 <li>
  <code>form=</code>, immediately followed by
  the value of the form setting as an uppercase word
  (one of <code>SCIENTIFIC</code>, <code>PLAIN</code>, or 
 <code>ENGINEERING</code>).
  <li>
  <code>lostDigits=</code>, immediately followed by
  the value of the lostDigits setting
  (<code>1</code> if enabled, <code>0</code> if disabled). 
 <li>
  <code>roundingMode=</code>, immediately followed by
  the value of the roundingMode setting as a word.
  This word will be the same as the name of the corresponding public
  constant. 
 </ol>
  <p>
  For example: 
 <br><code>
  digits=9 form=SCIENTIFIC lostDigits=0 roundingMode=ROUND_HALF_UP 
 </code>
  <p>
  Additional words may be appended to the result of 
 <code>toString</code> in the future if more properties are added
  to the class.
 @return a <code>String</code> representing the context settings.
 */
- (NSString *)description;

// Disallowed inherited constructors, do not use.

- (instancetype __nonnull)init NS_UNAVAILABLE;

@end

J2OBJC_STATIC_INIT(AndroidIcuMathMathContext)

/*!
 @brief Plain (fixed point) notation, without any exponent.
 Used as a setting to control the form of the result of a 
 <code>BigDecimal</code> operation.
  A zero result in plain form may have a decimal part of one or
  more zeros.
 - seealso: #ENGINEERING
 - seealso: #SCIENTIFIC
 */
inline jint AndroidIcuMathMathContext_get_PLAIN(void);
#define AndroidIcuMathMathContext_PLAIN 0
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, PLAIN, jint)

/*!
 @brief Standard floating point notation (with scientific exponential
  format, where there is one digit before any decimal point).
 Used as a setting to control the form of the result of a 
 <code>BigDecimal</code> operation.
  A zero result in plain form may have a decimal part of one or
  more zeros.
 - seealso: #ENGINEERING
 - seealso: #PLAIN
 */
inline jint AndroidIcuMathMathContext_get_SCIENTIFIC(void);
#define AndroidIcuMathMathContext_SCIENTIFIC 1
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, SCIENTIFIC, jint)

/*!
 @brief Standard floating point notation (with engineering exponential
  format, where the power of ten is a multiple of 3).
 Used as a setting to control the form of the result of a 
 <code>BigDecimal</code> operation.
  A zero result in plain form may have a decimal part of one or
  more zeros.
 - seealso: #PLAIN
 - seealso: #SCIENTIFIC
 */
inline jint AndroidIcuMathMathContext_get_ENGINEERING(void);
#define AndroidIcuMathMathContext_ENGINEERING 2
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ENGINEERING, jint)

/*!
 @brief Rounding mode to round to a more positive number.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  If any of the discarded digits are non-zero then the result
  should be rounded towards the next more positive digit.
 */
inline jint AndroidIcuMathMathContext_get_ROUND_CEILING(void);
#define AndroidIcuMathMathContext_ROUND_CEILING 2
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_CEILING, jint)

/*!
 @brief Rounding mode to round towards zero.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  All discarded digits are ignored (truncated).  The result is
  neither incremented nor decremented.
 */
inline jint AndroidIcuMathMathContext_get_ROUND_DOWN(void);
#define AndroidIcuMathMathContext_ROUND_DOWN 1
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_DOWN, jint)

/*!
 @brief Rounding mode to round to a more negative number.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  If any of the discarded digits are non-zero then the result
  should be rounded towards the next more negative digit.
 */
inline jint AndroidIcuMathMathContext_get_ROUND_FLOOR(void);
#define AndroidIcuMathMathContext_ROUND_FLOOR 3
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_FLOOR, jint)

/*!
 @brief Rounding mode to round to nearest neighbor, where an equidistant
  value is rounded down.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  If the discarded digits represent greater than half (0.5 times)
  the value of a one in the next position then the result should be
  rounded up (away from zero).  Otherwise the discarded digits are
  ignored.
 */
inline jint AndroidIcuMathMathContext_get_ROUND_HALF_DOWN(void);
#define AndroidIcuMathMathContext_ROUND_HALF_DOWN 5
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_HALF_DOWN, jint)

/*!
 @brief Rounding mode to round to nearest neighbor, where an equidistant
  value is rounded to the nearest even neighbor.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  If the discarded digits represent greater than half (0.5 times)
  the value of a one in the next position then the result should be
  rounded up (away from zero).  If they represent less than half,
  then the result should be rounded down. 
 <p>
  Otherwise (they represent exactly half) the result is rounded
  down if its rightmost digit is even, or rounded up if its
  rightmost digit is odd (to make an even digit).
 */
inline jint AndroidIcuMathMathContext_get_ROUND_HALF_EVEN(void);
#define AndroidIcuMathMathContext_ROUND_HALF_EVEN 6
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_HALF_EVEN, jint)

/*!
 @brief Rounding mode to round to nearest neighbor, where an equidistant
  value is rounded up.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  If the discarded digits represent greater than or equal to half
  (0.5 times) the value of a one in the next position then the result
  should be rounded up (away from zero).  Otherwise the discarded
  digits are ignored.
 */
inline jint AndroidIcuMathMathContext_get_ROUND_HALF_UP(void);
#define AndroidIcuMathMathContext_ROUND_HALF_UP 4
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_HALF_UP, jint)

/*!
 @brief Rounding mode to assert that no rounding is necessary.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  Rounding (potential loss of information) is not permitted.
  If any of the discarded digits are non-zero then an 
 <code>ArithmeticException</code> should be thrown.
 */
inline jint AndroidIcuMathMathContext_get_ROUND_UNNECESSARY(void);
#define AndroidIcuMathMathContext_ROUND_UNNECESSARY 7
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_UNNECESSARY, jint)

/*!
 @brief Rounding mode to round away from zero.
 Used as a setting to control the rounding mode used during a 
 <code>BigDecimal</code> operation. 
 <p>
  If any of the discarded digits are non-zero then the result will
  be rounded up (away from zero).
 */
inline jint AndroidIcuMathMathContext_get_ROUND_UP(void);
#define AndroidIcuMathMathContext_ROUND_UP 0
J2OBJC_STATIC_FIELD_CONSTANT(AndroidIcuMathMathContext, ROUND_UP, jint)

/*!
 @brief A <code>MathContext</code> object initialized to the default
  settings for general-purpose arithmetic.That is, 
 <code>digits=9 form=SCIENTIFIC lostDigits=false
  roundingMode=ROUND_HALF_UP</code>.
 - seealso: #SCIENTIFIC
 - seealso: #ROUND_HALF_UP
 */
inline AndroidIcuMathMathContext *AndroidIcuMathMathContext_get_DEFAULT(void);
/*! INTERNAL ONLY - Use accessor function from above. */
FOUNDATION_EXPORT AndroidIcuMathMathContext *AndroidIcuMathMathContext_DEFAULT;
J2OBJC_STATIC_FIELD_OBJ_FINAL(AndroidIcuMathMathContext, DEFAULT, AndroidIcuMathMathContext *)

FOUNDATION_EXPORT void AndroidIcuMathMathContext_initWithInt_(AndroidIcuMathMathContext *self, jint setdigits);

FOUNDATION_EXPORT AndroidIcuMathMathContext *new_AndroidIcuMathMathContext_initWithInt_(jint setdigits) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT AndroidIcuMathMathContext *create_AndroidIcuMathMathContext_initWithInt_(jint setdigits);

FOUNDATION_EXPORT void AndroidIcuMathMathContext_initWithInt_withInt_(AndroidIcuMathMathContext *self, jint setdigits, jint setform);

FOUNDATION_EXPORT AndroidIcuMathMathContext *new_AndroidIcuMathMathContext_initWithInt_withInt_(jint setdigits, jint setform) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT AndroidIcuMathMathContext *create_AndroidIcuMathMathContext_initWithInt_withInt_(jint setdigits, jint setform);

FOUNDATION_EXPORT void AndroidIcuMathMathContext_initWithInt_withInt_withBoolean_(AndroidIcuMathMathContext *self, jint setdigits, jint setform, jboolean setlostdigits);

FOUNDATION_EXPORT AndroidIcuMathMathContext *new_AndroidIcuMathMathContext_initWithInt_withInt_withBoolean_(jint setdigits, jint setform, jboolean setlostdigits) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT AndroidIcuMathMathContext *create_AndroidIcuMathMathContext_initWithInt_withInt_withBoolean_(jint setdigits, jint setform, jboolean setlostdigits);

FOUNDATION_EXPORT void AndroidIcuMathMathContext_initWithInt_withInt_withBoolean_withInt_(AndroidIcuMathMathContext *self, jint setdigits, jint setform, jboolean setlostdigits, jint setroundingmode);

FOUNDATION_EXPORT AndroidIcuMathMathContext *new_AndroidIcuMathMathContext_initWithInt_withInt_withBoolean_withInt_(jint setdigits, jint setform, jboolean setlostdigits, jint setroundingmode) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT AndroidIcuMathMathContext *create_AndroidIcuMathMathContext_initWithInt_withInt_withBoolean_withInt_(jint setdigits, jint setform, jboolean setlostdigits, jint setroundingmode);

J2OBJC_TYPE_LITERAL_HEADER(AndroidIcuMathMathContext)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif

#pragma clang diagnostic pop
#pragma pop_macro("INCLUDE_ALL_AndroidIcuMathMathContext")