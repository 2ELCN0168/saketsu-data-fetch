#! /bin/bash

# Creator: 2ELCN0168
# Last updated on: 2024-12-20
# License: Free for personnal use only

function _colors()
{
        R='\033[91m' # RED
        G='\033[92m' # GREEN
        Y='\033[93m' # YELLOW
        B='\033[94m' # BLUE
        P='\033[95m' # PINK
        C='\033[96m' # CYAN
        N='\033[0m'  # RESET
}

function _help()
{
        printf "%b" "Welcome to ${R}Saketsu${N}! Fetch system informations.\n"
        printf "%b" "${R}Usage:${N}\n"
        printf "%b" "${R} -c         ${N}  No colored output\n"
        printf "%b" "${R} -d         ${N}  No disk usage\n"
        printf "%b" "${R} -f         ${N}  No fun functions\n"
        printf "%b" "${R} -h         ${N}  Display help\n"
        printf "%b" "${R} -i         ${N}  No system informations\n"
        printf "%b" "${R} -k         ${N}  No docker containers\n"
        printf "%b" "${R} -l ${N}[40-200]  Maximum line length\n"
        printf "%b" "${R} -s         ${N}  No services\n"
}

function main()
{
        max_limit=70

        opt_c=0 # No colored output
        opt_d=0 # No disk usage
        opt_f=0 # No fun functions
        opt_h=0 # Display help
        opt_i=0 # No system informations 
        opt_k=0 # No docker containers informations 
        opt_n=0 # No network informations

        while getopts "cdfhikl:ns" opt; do
                case "${opt}" in
                        c) opt_c=1 ;;
                        d) opt_d=1 ;;
                        f) opt_f=1 ;;
                        h) opt_h=1 ;;
                        i) opt_i=1 ;;
                        k) opt_k=1 ;;
                        l) max_limit=${OPTARG} ;;
                        n) opt_n=1 ;;
                        s) opt_s=1 ;;
                        ?) opt_h=1;;
                esac
        done

        [[ "${opt_c}" -ne 1 ]] && _colors
        [[ "${opt_h}" -eq 1 ]] && _help && exit 0
        if [[ "${max_limit}" -lt 40 || "${max_limit}" -gt 300 ]]; then
                printf "%b" "${R}Total line length must be between 40 and 300.\n${N}"
                exit 1
        fi

        # Function usage:
        # <function> <label_color> <info_color> <max_limit>
        # Change the mono-char variables if you want to change the color.
        if [[ "${opt_i}" -ne 1 ]]; then
                display_distribution "${Y}" "${G}" "${max_limit}"
                display_hostname "${Y}" "${G}" "${max_limit}"
                display_cpu "${Y}" "${G}" "${max_limit}"
                display_kernel "${Y}" "${G}" "${max_limit}"
                display_uptime "${Y}" "${G}" "${max_limit}"
                display_users_logged "${Y}" "${G}" "${max_limit}"
                display_installed_packages "${Y}" "${G}" "${max_limit}"
        fi

        if [[ "${opt_n}" -ne 1 ]]; then
                display_inet4_addresses "${C}" "${P}" "${max_limit}"
                display_inet6_addresses "${C}" "${P}" "${max_limit}"
        fi
                if [[ "${opt_f}" -ne 1 ]]; then
                display_unauthorized_access_state "${R}" "${R}" "${max_limit}"
        fi

        if [[ "${opt_d}" -ne 1 ]]; then
                display_fs_usage "${max_limit}" 
        fi

        if [[ "${opt_s}" -ne 1 ]]; then
                local services
                services=(
                        "sshd"
                        "nftables"
                        "firewalld"
                        "apparmor"
                        "apache2"
                        "httpd"
                        "docker"
                        "networking"
                        "systemd-networkd"
                        "NetworkManager"
                        "systemd-resolved"
                        "systemd-timesyncd"
                        "clamav-daemon"
                        "clamav-clamonacc"
                        "nginx"
                        "dhcpd"
                        "isc-dhcp-server"
                        "kea-dhcp"
                        "bind9"
                        "named"
                        "mariadb"
                        "postgresql"
                        "rpcbind"
                        "fail2ban"
                        "qemu-guest-agent"
                        "zabbix-agent"
                        "snmpd"
                        "cups"
                        "bluetooth"
                        "containerd"
                )
                for i in "${services[@]}"; do
                        display_service_state "${i}" "${B}" "${max_limit}"
                done
        fi

        if [[ "${opt_k}" -ne 1 ]]; then
                display_docker_containers "${C}" "${C}" "${max_limit}"
        fi
        
}

function data_line()
{
        local label
        local value
        local color_1
        local color_2
        local target_length
        local label_length
        local value_length
        local dots_length
        local dots

        label="${1}"
        value="${2}"
        color_1="${3}"
        color_2="${4}"
        target_length="${5}"

        label_length=${#label}
        value_length=${#value}
        dots_length=$((target_length - label_length - value_length))

        dots=$(printf '.%.0s' $(seq 1 ${dots_length}))

        echo -e "${color_1}${label}${N} ${dots} ${color_2}${value}${N}"
}

function display_distribution()
{
        source "/etc/os-release"
        data_line "Distribution" "${PRETTY_NAME}" "${1}" "${2}" "${3}"
}

function display_hostname()
{
        local hostname
        hostname=$(cat "/etc/hostname")

        data_line "Hostname (FQDN)" "${hostname}" "${1}" "${2}" "${3}"
}

function display_cpu()
{
        local cpu
        cpu=$(command cat "/proc/cpuinfo" | grep "model name" | uniq |
        xargs | sed 's/.*:\s*//')
        data_line "CPU" "${cpu}" "${1}" "${2}" "${3}"
}

function display_kernel()
{
        local kernel
        kernel=$(printf "%s %s" "$(command uname -s)" "$(command uname -r)")
        data_line "Kernel" "${kernel}" "${1}" "${2}" "${3}"
}

function display_uptime()
{
        local uptime
        uptime=$(command uptime -p | cut -d ' ' -f 2-)
        data_line "Uptime" "${uptime}" "${1}" "${2}" "${3}"
}

function display_users_logged()
{
        local users
        users=$(command who | command wc -l)
        data_line "Users logged in" "${users}" "${1}" "${2}" "${3}"
}

function display_inet4_addresses()
{
        if ! command -v ip 1> "/dev/null" 2>&1; then
                data_line "MISSING PACKAGE" "iproute2 is needed!" \
                "${1}" "${2}" "${3}"
                return
        fi

        local interfaces
        local ip4
        interfaces=$(command ip -o link show | awk -F': ' '{ print $2 }')
        
        for ifname in ${interfaces}; do
                ip4=$(command ip -4 addr show "${ifname}" |
                awk '/inet / { print $2 }' | cut -d '/' -f 1)
                for ip in ${ip4}; do
                        data_line "IPv4 (${ifname})" "${ip}" "${1}" "${2}" "${3}"
                done
        done
}

function display_inet6_addresses()
{
        if ! command -v ip 1> "/dev/null" 2>&1; then
                data_line "MISSING PACKAGE" "iproute2 is needed!" \
                "${1}" "${2}" "${3}"
                return
        fi

        local interfaces
        local ip6
        interfaces=$(command ip -o link show | awk -F': ' '{ print $2 }')

        for ifname in ${interfaces}; do
                ip6=$(command ip -6 addr show "${ifname}" |
                awk '/inet6 / { print $2 }' | cut -d '/' -f 1)
                for ip in ${ip6}; do
                        data_line "IPv6 (${ifname})" "${ip}" "${1}" "${2}" "${3}"
                done
        done
}

function display_installed_packages()
{
        local pkg_mgr
        local pkg_nb
        local pkg_fpk

        if command -v pacman 1> "/dev/null" 2>&1; then
                pkg_mgr="pacman"
                pkg_nb=$(pacman -Q | wc -l)
        elif command -v apt 1> "/dev/null" 2>&1; then
                pkg_mgr="apt"
                pkg_nb=$(apt list --installed | wc -l)
        elif command -v dnf 1> "/dev/null" 2>&1; then
                pkg_mgr="dnf"
                pkg_nb=$(dnf list installed | wc -l)
        elif command -v zypper 1> "/dev/null" 2>&1; then
                pkg_mgr="zypper"
                pkg_nb=$(zypper se --installed-only | wc -l)
        fi

        if command -v flatpak 1> "/dev/null" 2>&1; then
                pkg_fpk=$(flatpak list | wc -l) 
                data_line "Packages installed" \
                "${pkg_nb}(${pkg_mgr}), ${pkg_fpk}(flatpak)" "${1}" "${2}" "${3}"
        else
                data_line "Packages installed" \
                "${pkg_nb}(${pkg_mgr})" "${1}" "${2}" "${3}"
        fi
}

function display_fs_usage()
{
        local mountpoint
        local disk_usage
        local filled_blocks
        local empty_blocks
        local bar_filled
        local bar_empty
        local bar_length
        local bar
        local mountpoint_length

        mountpoint_length=14

        command lsblk -o MOUNTPOINTS -n | grep -v '^$' | while read -r mountpoint; do


                disk_usage=$(command df "${mountpoint}" | 
                awk 'NR==2 { print $5 }' | sed 's/%//')

                if [[ "${disk_usage}" -ge 90 ]]; then
                        color="${R}"
                elif [[ "${disk_usage}" -ge 70 ]]; then
                        color="${Y}"
                else
                        color="${G}"
                fi

                bar_length=$(($1 - mountpoint_length - 13))
                filled_blocks=$((disk_usage * bar_length / 100)) 
                empty_blocks=$((bar_length - filled_blocks))

                bar_filled=$(printf '%*s' "${filled_blocks}" | tr ' ' '#')
                bar_empty=$(printf '%*s' "${empty_blocks}" | tr ' ' '-')
                bar="${bar_filled}${bar_empty}"
                
                printf "%-${mountpoint_length}s usage: [%b%b%b] %3d%%\n" \
                "${mountpoint}" "${color}" "${bar}" "${N}" "${disk_usage}"
        done
}

function display_service_state()
{
        if ! systemctl list-units --type=service --all | grep -q "${1}.service" \
        1> "/dev/null" 2>&1; then
                return
        fi

        local value
        local color_1
        local color_2
        local target_length
        local label_length
        local value_length
        local dots_length
        local dots
        local label

        local service_state
        local service_state_length

        local service_enabled
        local service_enabled_length

        label="${1}.service"
        value="${2}"
        target_length="${3}"
        label_length=${#label}


        service_state=$(systemctl is-active "${1}")
        service_enabled=$(systemctl is-enabled "${1}")

        if [[ "${service_state}" == "active" ]]; then
                color_2="${G}"
        elif [[ "${service_state}" == "failed" ]]; then
                color_2="${R}"
        else
                color_2="${Y}"
        fi

        if [[ "${service_enabled}" == "enabled" ]]; then
                color_3="${G}"
        elif [[ "${service_enabled}" == "disabled" ]]; then
                color_3="${Y}"
        elif [[ "${service_enabled}" == "not-found" ]]; then
                color_3="${R}"
        fi

        service_enabled_length=${#service_enabled}
        service_state_length=${#service_state}

        value_length=$((service_enabled_length + service_state_length))
        dots_length=$((target_length - label_length - service_state_length - \
        service_enabled_length - 2))
        dots=$(printf '.%.0s' $(seq 1 ${dots_length}))
        echo -e "${2}${label}${N} ${dots} ${color_2}${service_state}${N}(${color_3}${service_enabled}${N})"
}

function display_docker_containers()
{
        if ! command -v docker 1> "/dev/null" 2>&1; then
                return
        fi

        if [[ "${EUID}" -ne 0 && ! "$(id -nG)" =~ \bdocker\b ]]; then
                return
        fi

        local dock_ct
        
        for i in $(docker ps --filter "status=running" --format "{{.Names}}"); do
                dock_ct+=("${i}")
        done

        for i in "${dock_ct[@]}"; do
                data_line "(docker) - ${i}" "Running" "${1}" "${2}" "${3}"
        done
}

# Fun functions
function display_unauthorized_access_state()
{
        local access_status
        access_status="Not allowed!"

        data_line "Unauthorized access is" "${access_status}" "${1}" "${2}" "${3}"
}

main "${@}"
