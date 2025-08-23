  #!/bin/bash

# Fix Firefox Developer Edition dock integration
# Corrects Mozilla's packaging bug where StartupWMClass doesn't match actual WM_CLASS

set -euo pipefail

readonly SYSTEM_DESKTOP_FILE="/usr/share/applications/firefox-devedition.desktop"
readonly USER_DESKTOP_DIR="$HOME/.local/share/applications"
readonly USER_DESKTOP_FILE="$USER_DESKTOP_DIR/firefox-devedition.desktop"
readonly WRONG_WM_CLASS="firefox-aurora"
readonly CORRECT_WM_CLASS="firefox-dev"

check_firefox_dev_installed() {
    if [[ ! -f "$SYSTEM_DESKTOP_FILE" ]]; then
        echo "Error: Firefox Developer Edition not found at $SYSTEM_DESKTOP_FILE"
        echo "Install it first: sudo apt install firefox-devedition"
        exit 1
    fi
}

check_packaging_bug_exists() {
    if ! grep -q "StartupWMClass=$WRONG_WM_CLASS" "$SYSTEM_DESKTOP_FILE"; then
        echo "No bug detected. StartupWMClass is not set to $WRONG_WM_CLASS"
        echo "Current value:"
        grep "StartupWMClass=" "$SYSTEM_DESKTOP_FILE" || echo "  (StartupWMClass not found)"
        exit 0
    fi
}

create_user_desktop_dir() {
    mkdir -p "$USER_DESKTOP_DIR"
}

backup_existing_override() {
    if [[ -f "$USER_DESKTOP_FILE" ]]; then
        local backup_file="${USER_DESKTOP_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$USER_DESKTOP_FILE" "$backup_file"
        echo "Backed up existing override to: $backup_file"
    fi
}

create_fixed_desktop_file() {
    cp "$SYSTEM_DESKTOP_FILE" "$USER_DESKTOP_FILE"
    sed -i "s/StartupWMClass=$WRONG_WM_CLASS/StartupWMClass=$CORRECT_WM_CLASS/" "$USER_DESKTOP_FILE"
}

update_desktop_database() {
    update-desktop-database "$USER_DESKTOP_DIR" 2>/dev/null || true
}

verify_fix() {
    local fixed_value
    fixed_value=$(grep "StartupWMClass=" "$USER_DESKTOP_FILE" | cut -d'=' -f2)

    if [[ "$fixed_value" == "$CORRECT_WM_CLASS" ]]; then
        echo "✓ Fix applied successfully"
        echo "  StartupWMClass changed: $WRONG_WM_CLASS → $CORRECT_WM_CLASS"
        echo "  User override created: $USER_DESKTOP_FILE"
    else
        echo "✗ Fix failed. StartupWMClass is: $fixed_value"
        exit 1
    fi
}

show_next_steps() {
    echo ""
    echo "Next steps:"
    echo "  1. Restart GNOME Shell (X11: Alt+F2, type 'r' and press Enter)"
    echo "     OR log out and log back in (Wayland)"
    echo "  2. Pin Firefox Developer Edition to dock if not already pinned"
    echo ""
    echo "The dock should now properly associate running windows with the launcher icon."
}

main() {
    echo "Firefox Developer Edition Dock Fix"
    echo "Fixing Mozilla's StartupWMClass packaging bug..."
    echo ""

    check_firefox_dev_installed
    check_packaging_bug_exists

    echo "Bug confirmed: StartupWMClass=$WRONG_WM_CLASS (should be $CORRECT_WM_CLASS)"
    echo "Creating user override..."

    create_user_desktop_dir
    backup_existing_override
    create_fixed_desktop_file
    update_desktop_database
    verify_fix
    show_next_steps
}

main "$@"
