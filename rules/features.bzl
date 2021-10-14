feature_names = struct(
    # Virtualize means that swift,clang read from llvm's in-memory file system
    virtualize_frameworks = "apple.virtualize_frameworks",
    # Generate xcodeproj which do not need bazel to build.
    native_xcodeproj = "native_xcodeproj",
)
