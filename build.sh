set -e

dist_dir="dist"

repo_dir="$PWD/sear"
repo_ref="main"

# Function that builds SEAR
function build_package {
    echo "Building in: $repo_dir"
    echo "Building with $1"

    venv_dir="$PWD/.venv-$1"

    pushd "$repo_dir"

    echo "Fetching ref: $repo_ref"
    git fetch --tags --force origin "$repo_ref"
    git reset --hard "origin/$repo_ref"
    git clean -dxf

    # Ready build environment (outside the repo, so the tree stays clean)
    $1 -m venv "$venv_dir"
    "$venv_dir/bin/pip" install build

    # Build package
    "$venv_dir/bin/python" -m build

    popd

    rm -rf "$venv_dir"
    cp $repo_dir/dist/* "$dist_dir"
}

if [ -d "$dist_dir" ]; then
    rm -rF "$dist_dir"
fi
mkdir -p "$dist_dir"

# Runs the build function
build_package python3.13
build_package python3.14

# Create files.txt, which contain build artifacts
ls -d  $dist_dir/* | iconv -f ISO8859-1 -t UTF-8 > files.txt
