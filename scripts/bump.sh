#!/bin/bash
#
# Version Bump and Release Script for T-Ruby Vim/Neovim Plugin
#
# Usage:
#   ./scripts/bump.sh <type|version>
#
# Arguments:
#   patch       Bump patch version (0.1.0 -> 0.1.1)
#   minor       Bump minor version (0.1.0 -> 0.2.0)
#   major       Bump major version (0.1.0 -> 1.0.0)
#   X.Y.Z       Set exact version (e.g., 0.2.2)
#
# Options:
#   --dry-run   Show what would happen without making changes
#   --help      Show this help message
#
# Examples:
#   ./scripts/bump.sh patch
#   ./scripts/bump.sh minor --dry-run
#   ./scripts/bump.sh 0.2.2

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_ROOT/VERSION"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DRY_RUN=false
BUMP_TYPE=""
EXACT_VERSION=""

print_help() {
    echo "Version Bump and Release Script for T-Ruby Vim/Neovim Plugin"
    echo ""
    echo "Usage: $0 <type> [options]"
    echo ""
    echo "Arguments:"
    echo "  patch       Bump patch version (0.1.0 -> 0.1.1)"
    echo "  minor       Bump minor version (0.1.0 -> 0.2.0)"
    echo "  major       Bump major version (0.1.0 -> 1.0.0)"
    echo "  X.Y.Z       Set exact version (e.g., 0.2.2)"
    echo ""
    echo "Options:"
    echo "  --dry-run   Show what would happen without making changes"
    echo "  --help      Show this help message"
    echo ""
    echo "This script will:"
    echo "  1. Bump the version in VERSION file"
    echo "  2. Commit the version change"
    echo "  3. Create a git tag (v0.x.x)"
    echo "  4. Push the commit and tag to trigger GitHub Actions release"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

get_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "0.1.0"
    fi
}

bump_version() {
    local bump_type=$1

    OLD_VERSION=$(get_version)

    # Parse version components
    IFS='.' read -r MAJOR MINOR PATCH <<< "$OLD_VERSION"

    case $bump_type in
        patch)
            PATCH=$((PATCH + 1))
            ;;
        minor)
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        major)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
    esac

    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    echo "$NEW_VERSION"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        patch|minor|major)
            BUMP_TYPE="$1"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
        *)
            # Check if it's a version number (X.Y.Z format)
            if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                EXACT_VERSION="$1"
                shift
            else
                log_error "Unknown option: $1"
                print_help
                exit 1
            fi
            ;;
    esac
done

if [ -z "$BUMP_TYPE" ] && [ -z "$EXACT_VERSION" ]; then
    log_error "Missing bump type (patch|minor|major) or version (X.Y.Z)"
    print_help
    exit 1
fi

cd "$PROJECT_ROOT"

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    log_error "Working directory is not clean. Please commit or stash changes first."
    exit 1
fi

# Calculate versions
OLD_VERSION=$(get_version)
if [ -n "$EXACT_VERSION" ]; then
    NEW_VERSION="$EXACT_VERSION"
else
    NEW_VERSION=$(bump_version "$BUMP_TYPE")
fi

log_info "Version bump: $OLD_VERSION -> $NEW_VERSION"

if [ "$DRY_RUN" = true ]; then
    log_warn "Dry run mode - showing what would happen:"
    echo ""
    echo "  1. Update VERSION file to $NEW_VERSION"
    echo "  2. git commit -m \"Bump version to $NEW_VERSION\""
    echo "  3. git tag v$NEW_VERSION"
    echo "  4. git push && git push --tags"
    echo ""
    echo "This would trigger GitHub Actions to create:"
    echo "  - GitHub Release"
    exit 0
fi

# Update VERSION file
log_info "Updating VERSION file..."
echo "$NEW_VERSION" > "$VERSION_FILE"

# Commit
log_info "Committing version change..."
git add VERSION
git commit -m "Bump version to $NEW_VERSION"

# Tag
log_info "Creating tag v$NEW_VERSION..."
git tag "v$NEW_VERSION"

# Push
log_info "Pushing to remote..."
git push && git push --tags

echo ""
log_success "Released v$NEW_VERSION!"
echo ""
echo "GitHub Actions will now:"
echo "  - Create a GitHub Release"
echo ""
echo "Monitor progress: https://github.com/type-ruby/t-ruby-vim/actions"
