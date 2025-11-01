set -e

dist_dir="dist"

repo_dir="$PWD/sear"
repo_ref="main"

# Function that builds SEAR
function build_package {
    echo "Building in: $repo_dir"
    echo "Building with $1"

    pushd "$repo_dir"

    # Set up clean build environment
    echo "Fetching ref: $repo_ref"

    git fetch --tags --force origin "$repo_ref"
    git clean -dxf
    git checkout "origin/$repo_ref"

    # Ready build environment
    $1 -m venv ".venv-$1"
    "./.venv-$1/bin/pip" install build

    # Build package
    "./.venv-$1/bin/python" -m build

    popd

    cp $repo_dir/dist/* "$dist_dir"
}

if [ -d "$dist_dir" ]; then
    rm -rF "$dist_dir"
fi
mkdir -p "$dist_dir"

# Runs the build function
build_package python3.12
build_package python3.13

# Create files.txt, which contain build artifacts
ls -d  $dist_dir/* | iconv -f ISO8859-1 -t UTF-8 > files.txt
