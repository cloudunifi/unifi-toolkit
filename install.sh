#!/bin/sh
set -eu

# UniFi Toolkit installer
# Usage: curl -fsSL https://raw.githubusercontent.com/cloudunifi/unifi-toolkit/main/install.sh | sh

REPO="cloudunifi/unifi-toolkit"
BINARY_NAME="unifi-toolkit"

main() {
    detect_platform
    resolve_version
    download_and_verify
    install_binary
    echo ""
    echo "UniFi Toolkit ${VERSION} installed to ${INSTALL_PATH}"
    echo "Run 'unifi-toolkit --help' to get started."
}

detect_platform() {
    OS="$(uname -s)"
    ARCH="$(uname -m)"

    case "${OS}" in
        Darwin)  OS="macos" ;;
        Linux)   OS="linux" ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "Error: Windows is not supported by this installer."
            echo "Download manually from: https://github.com/${REPO}/releases"
            exit 1
            ;;
        *)
            echo "Error: Unsupported operating system: ${OS}"
            echo "Supported: macOS (Darwin), Linux"
            exit 1
            ;;
    esac

    case "${ARCH}" in
        x86_64|amd64)  ARCH="amd64" ;;
        arm64|aarch64)  ARCH="arm64" ;;
        *)
            echo "Error: Unsupported architecture: ${ARCH}"
            echo "Supported: x86_64/amd64, arm64/aarch64"
            exit 1
            ;;
    esac

    ASSET_NAME="${BINARY_NAME}-${OS}-${ARCH}"
    echo "Detected platform: ${OS}/${ARCH}"
}

resolve_version() {
    if ! command -v curl >/dev/null 2>&1; then
        echo "Error: curl is required but not found."
        exit 1
    fi

    echo "Fetching latest version..."
    RELEASE_INFO="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null)" || {
        echo "Error: Failed to fetch release info from GitHub."
        echo "This may be due to API rate limiting. Try again later or download manually:"
        echo "  https://github.com/${REPO}/releases"
        exit 1
    }

    # Parse tag_name from JSON without jq (POSIX-compatible)
    VERSION="$(echo "${RELEASE_INFO}" | grep '"tag_name"' | sed 's/.*"tag_name": *"//;s/".*//')"

    if [ -z "${VERSION}" ]; then
        echo "Error: Could not determine latest version."
        exit 1
    fi

    echo "Latest version: ${VERSION}"
}

download_and_verify() {
    BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"
    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "${TMP_DIR}"' EXIT

    echo "Downloading ${ASSET_NAME}..."
    curl -fsSL "${BASE_URL}/${ASSET_NAME}" -o "${TMP_DIR}/${ASSET_NAME}" || {
        echo "Error: Failed to download binary."
        echo "Check that a release exists for your platform: ${OS}/${ARCH}"
        echo "  ${BASE_URL}/${ASSET_NAME}"
        exit 1
    }

    echo "Downloading checksums..."
    if curl -fsSL "${BASE_URL}/checksums.txt" -o "${TMP_DIR}/checksums.txt" 2>/dev/null; then
        echo "Verifying checksum..."
        EXPECTED="$(grep " ${ASSET_NAME}$" "${TMP_DIR}/checksums.txt" | awk '{print $1}')"
        if [ -z "${EXPECTED}" ]; then
            echo "Warning: No checksum found for ${ASSET_NAME}, skipping verification."
        else
            if command -v sha256sum >/dev/null 2>&1; then
                ACTUAL="$(sha256sum "${TMP_DIR}/${ASSET_NAME}" | awk '{print $1}')"
            elif command -v shasum >/dev/null 2>&1; then
                ACTUAL="$(shasum -a 256 "${TMP_DIR}/${ASSET_NAME}" | awk '{print $1}')"
            else
                echo "Warning: No SHA256 tool found, skipping verification."
                ACTUAL="${EXPECTED}"
            fi

            if [ "${ACTUAL}" != "${EXPECTED}" ]; then
                echo "Error: Checksum verification failed!"
                echo "  Expected: ${EXPECTED}"
                echo "  Got:      ${ACTUAL}"
                echo "The downloaded file may be corrupted. Please try again."
                exit 1
            fi
            echo "Checksum verified."
        fi
    else
        echo "Warning: Could not download checksums file, skipping verification."
    fi
}

install_binary() {
    INSTALL_DIR="${INSTALL_DIR:-}"

    if [ -z "${INSTALL_DIR}" ]; then
        if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
            INSTALL_DIR="/usr/local/bin"
        elif [ -w "/usr/local" ]; then
            mkdir -p /usr/local/bin
            INSTALL_DIR="/usr/local/bin"
        else
            INSTALL_DIR="${HOME}/.local/bin"
        fi
    fi

    mkdir -p "${INSTALL_DIR}"

    INSTALL_PATH="${INSTALL_DIR}/${BINARY_NAME}"
    cp "${TMP_DIR}/${ASSET_NAME}" "${INSTALL_PATH}"
    chmod +x "${INSTALL_PATH}"

    # Verify installation
    if ! "${INSTALL_PATH}" --version >/dev/null 2>&1; then
        echo "Warning: Installed binary could not be executed."
        echo "You may need to allow it in System Settings > Privacy & Security (macOS)."
    fi

    # Check if install dir is on PATH
    case ":${PATH}:" in
        *":${INSTALL_DIR}:"*) ;;
        *)
            echo ""
            echo "NOTE: ${INSTALL_DIR} is not on your PATH."
            echo "Add it by running:"
            echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
            echo "Or add that line to your shell profile (~/.bashrc, ~/.zshrc, etc.)"
            ;;
    esac
}

main
