# Function to run apt-get if needed
apt_get_update_if_needed()
{
    export DEBIAN_FRONTEND=noninteractive
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

# Function to run apt-get if command exists
apt_get_update_if_exists()
{
    if type apt-get > /dev/null 2>&1; then
        apt-get update
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if type dpkg > /dev/null 2>&1 && dpkg -s $1 > /dev/null 2>&1; then
        return 0
    elif type apk > /dev/null 2>&1 && apk -e info $2 > /dev/null 2>&1; then
        return 0
    elif type rpm > /dev/null 2>&1 && rpm -q $3 > /dev/null 2>&1; then
        return 0
    else
        echo "Unable to find package manager to check for packages."
        exit 1
    fi
    install_packages "$@"
    return $?
}

# Checks if command exists, installs it if not
# check_command <command> "<apt packages to install>" "<apk packages to install>" "<dnf/yum packages to install>"
check_command() {
    command_to_check=$1
    shift
    if type "${command_to_check}" > /dev/null 2>&1; then
        return 0
    fi
    install_packages "$@"
    return $?
}

# Installs packages using the appropriate package manager (apt, apk, dnf, or yum)
# install_packages "<apt packages to install>" "<apk packages to install>" "<dnf/yum packages to install>"
install_packages() {
    if type apt-get > /dev/null 2>&1; then
        apt_get_update_if_needed
        apt-get -y install --no-install-recommends $1
    elif type apk > /dev/null 2>&1; then
        apk add $2
    elif type dnf > /dev/null 2>&1; then
        dnf install -y $3
    elif type yum > /dev/null 2>&1; then
        yum install -y $3
    else
        echo "Unable to find package manager to install ${command_to_check}"
        exit 1
    fi
}