//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: android/platform/libcore/ojluni/src/main/java/java/io/FilterReader.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_JavaIoFilterReader")
#ifdef RESTRICT_JavaIoFilterReader
#define INCLUDE_ALL_JavaIoFilterReader 0
#else
#define INCLUDE_ALL_JavaIoFilterReader 1
#endif
#undef RESTRICT_JavaIoFilterReader

#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (JavaIoFilterReader_) && (INCLUDE_ALL_JavaIoFilterReader || defined(INCLUDE_JavaIoFilterReader))
#define JavaIoFilterReader_

#define RESTRICT_JavaIoReader 1
#define INCLUDE_JavaIoReader 1
#include "java/io/Reader.h"

@class IOSCharArray;

/*!
 @brief Abstract class for reading filtered character streams.
 The abstract class <code>FilterReader</code> itself
  provides default methods that pass all requests to
  the contained stream. Subclasses of <code>FilterReader</code>
  should override some of these methods and may also provide
  additional methods and fields.
 @author Mark Reinhold
 @since JDK1.1
 */
@interface JavaIoFilterReader : JavaIoReader {
 @public
  /*!
   @brief The underlying character-input stream.
   */
  JavaIoReader *in_;
}

#pragma mark Public

- (void)close;

/*!
 @brief Marks the present position in the stream.
 @throw IOExceptionIf an I/O error occurs
 */
- (void)markWithInt:(jint)readAheadLimit;

/*!
 @brief Tells whether this stream supports the mark() operation.
 */
- (jboolean)markSupported;

/*!
 @brief Reads a single character.
 @throw IOExceptionIf an I/O error occurs
 */
- (jint)read;

/*!
 @brief Reads characters into a portion of an array.
 @throw IOExceptionIf an I/O error occurs
 */
- (jint)readWithCharArray:(IOSCharArray *)cbuf
                  withInt:(jint)off
                  withInt:(jint)len;

/*!
 @brief Tells whether this stream is ready to be read.
 @throw IOExceptionIf an I/O error occurs
 */
- (jboolean)ready;

/*!
 @brief Resets the stream.
 @throw IOExceptionIf an I/O error occurs
 */
- (void)reset;

/*!
 @brief Skips characters.
 @throw IOExceptionIf an I/O error occurs
 */
- (jlong)skipWithLong:(jlong)n;

#pragma mark Protected

/*!
 @brief Creates a new filtered reader.
 @param inArg a Reader object providing the underlying stream.
 @throw NullPointerExceptionif <code>in</code> is <code>null</code>
 */
- (instancetype __nonnull)initWithJavaIoReader:(JavaIoReader *)inArg;

@end

J2OBJC_EMPTY_STATIC_INIT(JavaIoFilterReader)

J2OBJC_FIELD_SETTER(JavaIoFilterReader, in_, JavaIoReader *)

FOUNDATION_EXPORT void JavaIoFilterReader_initWithJavaIoReader_(JavaIoFilterReader *self, JavaIoReader *inArg);

J2OBJC_TYPE_LITERAL_HEADER(JavaIoFilterReader)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif

#pragma clang diagnostic pop
#pragma pop_macro("INCLUDE_ALL_JavaIoFilterReader")