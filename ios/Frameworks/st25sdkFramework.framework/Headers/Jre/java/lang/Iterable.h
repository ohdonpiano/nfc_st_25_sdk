//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: android/platform/libcore/ojluni/src/main/java/java/lang/Iterable.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_JavaLangIterable")
#ifdef RESTRICT_JavaLangIterable
#define INCLUDE_ALL_JavaLangIterable 0
#else
#define INCLUDE_ALL_JavaLangIterable 1
#endif
#undef RESTRICT_JavaLangIterable

#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability"
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (JavaLangIterable_) && (INCLUDE_ALL_JavaLangIterable || defined(INCLUDE_JavaLangIterable))
#define JavaLangIterable_

@protocol JavaUtilFunctionConsumer;
@protocol JavaUtilIterator;
@protocol JavaUtilSpliterator;

/*!
 @brief Implementing this interface allows an object to be the target of
  the "for-each loop" statement.See
  <strong>
  <a href="{@@docRoot}openjdk-redirect.html?
 v=8&path=/technotes/guides/language/foreach.html">For-each Loop</a>
  </strong>
 @since 1.5
 */
@protocol JavaLangIterable < NSFastEnumeration, JavaObject >

/*!
 @brief Returns an iterator over elements of type <code>T</code>.
 @return an Iterator.
 */
- (id<JavaUtilIterator> __nonnull)iterator;

/*!
 @brief Performs the given action for each element of the <code>Iterable</code>
  until all elements have been processed or the action throws an
  exception.Unless otherwise specified by the implementing class,
  actions are performed in the order of iteration (if an iteration order
  is specified).
 Exceptions thrown by the action are relayed to the
  caller.
 @param action The action to be performed for each element
 @throw NullPointerExceptionif the specified action is null
 @since 1.8
 */
- (void)forEachWithJavaUtilFunctionConsumer:(id<JavaUtilFunctionConsumer>)action;

/*!
 @brief Creates a <code>Spliterator</code> over the elements described by this 
 <code>Iterable</code>.
 @return a <code>Spliterator</code> over the elements described by this 
 <code>Iterable</code>.
 @since 1.8
 */
- (id<JavaUtilSpliterator>)spliterator;

@end

J2OBJC_EMPTY_STATIC_INIT(JavaLangIterable)

FOUNDATION_EXPORT void JavaLangIterable_forEachWithJavaUtilFunctionConsumer_(id<JavaLangIterable> self, id<JavaUtilFunctionConsumer> action);

FOUNDATION_EXPORT id<JavaUtilSpliterator> JavaLangIterable_spliterator(id<JavaLangIterable> self);

J2OBJC_TYPE_LITERAL_HEADER(JavaLangIterable)

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif

#pragma clang diagnostic pop
#pragma pop_macro("INCLUDE_ALL_JavaLangIterable")