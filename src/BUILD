load("@rules_pkg//pkg:mappings.bzl", "pkg_filegroup", "pkg_files", "strip_prefix")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")

alias(
    name = "main",
    actual = ":website_tarball",
)

pkg_tar(
    name = "website_tarball",
    srcs = [
        "index.html",
    ]
)
