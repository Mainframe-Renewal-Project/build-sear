set -e

repo_dir="$PWD/sear"
repo_ref="main"

# Function that builds SEAR
function build_package {
    echo "Building in: $repo_dir"

    pushd "$repo_dir"

    # Set up clean build environment
    echo "Fetching ref: $repo_ref"

    git fetch --tags origin "$repo_ref"
    git clean -dxf
    git checkout "origin/$repo_ref"

    # Ready build environment
    python3 -m venv .venv
    ./.venv/bin/pip install build

    # Build package
    ./.venv/bin/python -m build

    popd
}

# Runs the build function
build_package

# Create files.txt, which contain build artifacts
ls -d  "$repo_dir"/dist/* | iconv -f ISO8859-1 -t UTF-8 > files.txt
