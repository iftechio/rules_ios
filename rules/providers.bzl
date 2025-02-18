FrameworkInfo = provider(
    fields = {
        "vfsoverlay_infos": "Merged VFS overlay infos, present when virtual frameworks enabled",
        "binary": "The binary of the framework",
        "headers": "Headers of the framework's public interface",
        "private_headers": "Private headers of the framework",
        "modulemap": "The module map of the framework",
        "swiftmodule": "The swiftmodule",
        "swiftdoc": " The Swift doc",
        "framework_deps": "framework_deps, for xcode_native",
        "xcconfig": "config for xcode",
    },
)