# Keep all classes and methods to avoid issues
-keep class * { *; }

# Keep annotations (important for libraries like Retrofit, Gson, etc.)
-keepattributes *Annotation*

# Keep Serializable and Parcelable classes
-keep class * implements java.io.Serializable { *; }
-keep class * implements android.os.Parcelable { *; }

# Keep all enum values (prevent ProGuard from removing enum fields)
-keepclassmembers enum * { public static **[] values(); public static ** valueOf(java.lang.String); }

# Keep Firebase-related classes (if using Firebase)
-keep class com.google.firebase.** { *; }

# Keep Glide (if using Glide for image loading)
-keep class com.bumptech.glide.** { *; }

# Keep Retrofit & OkHttp (if using them)
-keep class com.squareup.retrofit2.** { *; }
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep JSON libraries (Gson, Moshi, Jackson)
-keep class com.google.gson.** { *; }
-keep class com.squareup.moshi.** { *; }
-keep class com.fasterxml.jackson.** { *; }

# Prevent warnings for missing classes
-dontwarn android.support.**
-dontwarn androidx.**

# Keep logging for debugging (optional)
-assumenosideeffects class android.util.Log { *; }

-keep class com.hyphenate.** {*;}
-dontwarn com.hyphenate.**