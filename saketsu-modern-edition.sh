#! /bin/bash

# Creator: 2ELCN0168
# Last updated on: 2024-12-26
# License: Free for personnal use only

function _themes()
{
        if [[ "${1}" == "normal" ]]; then
                C1='\033[91m'  # RED 
                C2='\033[92m'  # GREEN
                C3='\033[93m'  # YELLOW
                C4='\033[94m'  # BLUE
                C5='\033[95m'  # PINK
                C6='\033[96m'  # CYAN
                C7='\033[97m'  # WHITE
                N='\033[0m'    # RESET
                B2='\033[30;102m' # BG GREEN
        elif [[ "${1}" == "modern" ]]; then
                C1='\033[92m'  # GREEN 
                C2='\033[92m'  # GREEN
                C3='\033[92m'  # GREEN 
                C4='\033[0m'   # NO COLOR
                C5='\033[0m'   # NO COLOR 
                C6='\033[0m'   # NO COLOR 
                C7='\033[0m'   # NO COLOR
                N='\033[0m'    # RESET
                B2='\033[30;102m' # BG GREEN
        elif [[ "${1}" == "saketsu" ]]; then
                C1='\033[91m'  # RED 
                C2='\033[91m'  # RED
                C3='\033[91m'  # RED 
                C4='\033[31m'  # DARK RED
                C5='\033[31m'  # DARK RED 
                C6='\033[31m'  # DARK RED
                C7='\033[97m'  # WHITE
                N='\033[0m'    # RESET
                B2='\033[30;102m' # BG GREEN
        elif [[ "${1}" == "aquatic" ]]; then
                C1='\033[96m'  # CYAN 
                C2='\033[94m'  # BLUE
                C3='\033[96m'  # CYAN 
                C4='\033[94m'  # BLUE
                C5='\033[96m'  # CYAN 
                C6='\033[96m'  # CYAN
                C7='\033[97m'  # WHITE
                N='\033[0m'    # RESET
                B2='\033[30;106m' # BG CYAN 
        fi
}

function _help()
{
        # 2 spaces ${R}-h${N} 6 spaces <desc>\n
        printf "%b" "Welcome to ${R}Saketsu! Modern Edition${N}\n"
        printf "%b" "${R}Usage:${N}\n"
        printf "%b" "${R}  -a${N}      Anonymize sensible data\n"
        printf "%b" "${R}  -b${N}      Make a banner (figlet needed)\n"
        printf "%b" "${R}  -c${N}      No colored output\n"
        printf "%b" "${R}  -d${N}      No disk usage\n"
        printf "%b" "${R}  -h${N}      Display help\n"
        printf "%b" "${R}  -i${N}      No system informations\n"
        printf "%b" "${R}  -k${N}      No Docker informations\n"
        printf "%b" "${R}  -l${N}      Set the first tabstop length [15-50]\n"
        printf "%b" "${R}  -L${N}      Set the second tabstop length [60-150]\n"
        printf "%b" "${R}  -n${N}      No network informations\n"
        printf "%b" "${R}  -t${N}      Set the color scheme\n"
        printf "%b" "${R}  -s${N}      No services\n"
        printf "%b" "${R}  -S${N}      No security informations\n"
        printf "%b" "${R}  -Z${N}      No SELinux status\n"
        printf "%b" "Available color schemes are: ${R}saketsu${N}, "
        printf "%b" "${C}aquatic${N}, ${G}modern${N}.\n"
}

function main()
{
        tabstop_1=15
        tabstop_2=60

        local opt_a opt_b opt_c opt_d opt_h opt_i opt_k opt_n opt_s
        local opt_S opt_Z
        local theme

        opt_a=0 # Anonymize data
        opt_b=0 # Banner
        opt_c=0 # No colored output
        opt_d=0 # No disk usage
        opt_h=0 # Display help
        opt_i=0 # No system informations
        opt_k=0 # No Docker informations
        opt_n=0 # No network informations
        opt_s=0 # No services informations
        opt_S=0 # No security informations
        opt_Z=0 # No SELinux informations

        theme="normal" # Default theme

        while getopts "ab:cdhikl:L:nt:sSZ" opt; do
                case "${opt}" in
                        a) opt_a=1 ;;
                        b) opt_b=1 && banner_title="${OPTARG}" ;;
                        c) opt_c=1 ;;
                        d) opt_d=1 ;;
                        h) opt_h=1 ;;
                        i) opt_i=1 ;;
                        k) opt_k=1 ;;
                        l) tabstop_1="${OPTARG}" ;;
                        L) tabstop_2="${OPTARG}" ;;
                        n) opt_n=1 ;;
                        t) theme="${OPTARG}" ;;
                        s) opt_s=1 ;;
                        S) opt_S=1 ;;
                        Z) opt_Z=1 ;;
                        ?) opt_h=1 ;;
                esac
        done

        # Initialize theme
        [[ "${opt_c}" -ne 1 ]] && _themes "${theme}"

        # Display help and exit
        [[ "${opt_h}" -eq 1 ]] && _help && exit 0

        # Tabstops management
        if [[ "${tabstop_1}" -lt 15 || "${tabstop_1}" -gt 50 ]]; then
                printf "%b" "${R}The first tabstop must be between 15 and 50!\n"
                exit 1
        fi

        if [[ "${tabstop_2}" -lt 60 || "${tabstop_2}" -gt 150 ]]; then
                printf "%b" "${R}The second tabstop must be between "
                printf "%b" "60 and 150!\n"
                exit 1
        fi

        # Banner with figlet
        if [[ "${opt_b}" -eq 1 ]]; then
                figlet -f slant "${banner_title}" 2> "/dev/null"
        fi

        # System informations
        if [[ "${opt_i}" -ne 1 ]]; then
                printf "%b" "System informations\n"
                display_hostname "${C6}" "${C1}" "${tabstop_1}"
                display_distribution "${C6}" "${C1}" "${tabstop_1}"
                display_kernel "${C6}" "${C1}" "${tabstop_1}"
                display_installed_packages "${C6}" "${C1}" "${tabstop_1}"
                printf "%b" "\n"
                display_cpu "${C6}" "${C1}" "${tabstop_1}"
                display_memory "${C6}" "${C1}" "${tabstop_1}"
                display_uptime "${C6}" "${C1}" "${tabstop_1}"
                display_load "${C6}" "${C1}" "${tabstop_1}"
                printf "%b" "\n"
        fi

        # Network informations
        if [[ "${opt_n}" -ne 1 ]]; then
                printf "%b" "Network informations\n"
                display_inet_addresses "${C6}" "${C1}" "${tabstop_1}" "4"
                display_inet_addresses "${C6}" "${C1}" "${tabstop_1}" "6"
                display_internet_connection "${C6}" "${C1}" "${tabstop_1}"
                printf "%b" "\n"
        fi

        # Security informations
        if [[ "${opt_S}" -ne 1 ]]; then
                printf "%b" "Security informations\n"
                display_usbguard "${C6}" "${C1}" "${tabstop_1}"
                display_rkhunter "${C6}" "${C1}" "${tabstop_1}"
                display_passwds_encryption_method "${C6}" "${C1}" "${tabstop_1}"
                display_drive_encryption "${C6}" "${C1}" "${tabstop_1}"
                if [[ "${opt_Z}" -ne 1 ]]; then
                        display_SELinux "${C6}" "${C1}" "${tabstop_1}"
                fi
                printf "%b" "\n"
        fi

        # Disks and filesystems informations
        if [[ "${opt_d}" -ne 1 ]]; then
                printf "%b" "Filesystems informations\n"
                display_fs_usage "${C2}" "${C6}" \
                "$((tabstop_2 - 35))" "${tabstop_2}"
                printf "%b" "\n"
                display_disks_temp "${C2}" "${B2}"
                printf "%b" "\n"
        fi

        # Services informations
        if [[ "${opt_s}" -ne 1 ]]; then
                services_function
        fi

        # Docker informations
        if [[ "${opt_k}" -ne 1 ]]; then
                docker_function 
        fi
}

### Main functions ###

function data_line()
{
        # Usage: data_line "label" "data" "first_color" "second_color" "tabstop"
        
        local label data tabstop_1 dots_length

        label="${1}"
        data="${2}"
        tabstop_1="${5}"

        # ${#label} is equal to the length of the string in "label" var
        dots_length=$((tabstop_1 - ${#label}))

        # Print as many dots as the result of ${dots_length}
        dots="$(printf '.%.0s' $(seq 1 ${dots_length}))"

        # Indentation and no return (\c)
        echo -e "  \c"
        echo -e "${3}${label}${N} ${dots}: ${4}${data}${N}"
}

function anonymize_data()
{
        # Usage: var=$(anonymize_data "${var}")
        
        local input_data random_seq
        input_data="${1}"

        random_seq="$(head -c 12 /dev/urandom | od -An -t x1 | tr -d ' \n' |
        head -c ${#input_data})"

        printf "%s" "${random_seq}"
}

### System functions ###

function display_hostname()
{
        local _hostname
        _hostname="$(command cat /etc/hostname)"

        if [[ "${opt_a}" -eq 1 ]]; then
                _hostname="$(anonymize_data ${_hostname})"
        fi

        data_line "Hostname" "${_hostname}" "${1}" "${2}" "${3}"
}

function display_distribution()
{
        local pretty_name
        pretty_name="$(command cat /etc/os-release | 
        awk -F '=' '/PRETTY_NAME/ { print $2 }' | tr -d '"')"

        data_line "Distribution" "${pretty_name}" "${1}" "${2}" "${3}"
}

function display_kernel()
{
        local kernel_version
        kernel_version="$(command uname -s) $(command uname -r)"

        if [[ "${opt_a}" -eq 1 ]]; then
                kernel_version="$(anonymize_data ${kernel_version})"
        fi

        data_line "Kernel" "${kernel_version}" "${1}" "${2}" "${3}"
}

function display_installed_packages()
{
        local pkg_mgr pkg_nb
        local pkg_fpk pkg_fpk_nb
        local computed_msg
        
        # Distribution package manager
        if [[ $(command -v pacman) ]]; then
                pkg_mgr="(pacman)"
                pkg_nb="$(pacman -Q | wc -l)"
        elif [[ $(command -v apt) ]]; then
                pkg_mgr="(apt)"
                pkg_nb="$(apt list --installed | wc -l)"
        elif [[ $(command -v dnf) ]]; then
                pkg_mgr="(dnf)"
                pkg_nb="$(dnf list installed | wc -l)"
        elif [[ $(command -v zypper) ]]; then
                pkg_mgr="(zypper)"
                pkg_nb="$(zypper -se --installed-only | wc -l)"
        else
                pkg_mgr=""
                pkg_nb=""
        fi

        # Flatpak
        if [[ $(command -v flatpak) ]]; then
                pkg_fpk="(flatpak)"
                pkg_fpk_nb="$(flatpak list | wc -l)"
        fi

        computed_msg="${pkg_nb}${N}${pkg_mgr}${2} ${pkg_fpk_nb}${N}${pkg_fpk}"

        data_line "Packages" "${computed_msg}" "${1}" "${2}" "${3}"
}

function display_cpu()
{
        [[ -f "/proc/cpuinfo" ]] || return

        local cpu_model
        cpu_model="$(command cat /proc/cpuinfo |
        awk -F ': ' '/model name/ { print $2; exit }')"

        data_line "CPU" "${cpu_model}" "${1}" "${2}" "${3}"
}

function display_memory()
{
        [[ -f "/proc/meminfo" ]] || return

        local mem_available mem_used mem_total

        mem_available="$(grep -i 'MemAvailable' /proc/meminfo |
        awk '{ print $2 }')"
        mem_total="$(grep -i 'MemTotal' /proc/meminfo | awk '{ print $2 }')"

        mem_used="$(awk "BEGIN { 
                print (${mem_total} - ${mem_available}) / 1024 / 1024 
        }")"
        mem_available="$(awk "BEGIN { print ${mem_available} / 1024 / 1024 }")"
        mem_total="$(awk "BEGIN { print ${mem_total} / 1024 / 1024 }")"

        # Convert to GB
        mem_available=$(printf "%.2f" "${mem_available}")
        mem_used=$(printf "%.2f" "${mem_used}")
        mem_total=$(printf "%.2f" "${mem_total}")

        # Stringify
        mem_available="${2}Free: ${1}${mem_available}${N}GB"
        mem_used="${2}Used: ${1}${mem_used}${N}GB"
        mem_total="${2}Total: ${1}${mem_total}${N}GB"

        data_line "Memory" "${mem_available}, ${mem_used}, ${mem_total}" \
        "${1}" "${2}" "${3}"
}

function display_uptime()
{
        local _uptime
        _uptime="$(command uptime -p)"
        data_line "Uptime" "${_uptime}" "${1}" "${2}" "${3}"
}

function display_load()
{
        local load_1 load_5 load_15 
        load_1="${2}$(cat /proc/loadavg | cut -d ' ' -f 1)${N}"
        load_5="${2}$(cat /proc/loadavg | cut -d ' ' -f 2)${N}"
        load_15="${2}$(cat /proc/loadavg | cut -d ' ' -f 3)${N}"

        data_line "Load" "${load_1}(1m), ${load_5}(5m), ${load_15}(15m)" \
        "${1}" "${2}" "${3}"
}

function display_users_logged()
{
        local _users
        _users="$(command who | wc -l)"

data_line "Users logged" "${_users}" "${1}" "${2}" "${3}"
}

### Network functions ###

function display_inet_addresses()
{
        [[ $(command -v ip) ]] || return

        local interfaces ip
        interfaces=$(command ip -o link show | awk -F ': ' '{ print $2 }')

        for ifname in ${interfaces[@]}; do
                # Do not use virtual interfaces
                if [[ "${ifname}" =~ ^veth.* ]]; then
                        continue
                fi
                
                # IPv4
                if [[ "${4}" == "4" ]]; then
                        ip="$(command ip -${4} addr show ${ifname} |
                        awk '/inet / { print $2 }' | cut -d '/' -f 1)"
                # IPv6
                elif [[ "${4}" == "6" ]]; then
                        ip="$(command ip -${4} addr show ${ifname} |
                        awk '/inet6 / { print $2 }' | cut -d '/' -f 1)"
                fi

                for i in ${ip}; do
                        data_line "IPv${4} (${ifname})" "${i}" \
                        "${1}" "${2}" "${3}"
                done
        done
}

function display_internet_connection()
{
        [[ $(command -v ping) ]] || return 

        local _ping

        if [[ $(command ping -c 1 1.1.1.1) ]]; then
                _ping="Ping ok!"
        else
                _ping="Outside connection not working"
        fi

        data_line "Internet" "${_ping}" "${1}" "${2}" "${3}"
}

### Security functions ###

function display_usbguard()
{
        [[ $(command -v usbguard) ]] || return
        [[ $(command -v systemctl) ]] || return

        local usbguard_state
        usbguard_state="$(systemctl is-active usbguard.service)"

        data_line "USBGuard" "${usbguard_state^}" "${1}" "${2}" "${3}"
}

function display_rkhunter()
{
        [[ $(command -v rkhunter) ]] || return
        
        local rkhunter_last_update

        if [[ -f "/var/log/rkhunter.log" ]]; then
                rkhunter_last_update="$(stat -c %y /var/log/rkhunter.log |
                awk '{ print $1, $2 }' | cut -d '.' -f 1)"
        else
                rkhunter_last_update="Unknown"
        fi

        data_line "RKHunter" "Last update: ${rkhunter_last_update}" \
        "${1}" "${2}" "${3}"
}

function display_passwds_encryption_method()
{
        [[ -f "/etc/login.defs" ]] || return

        local pw_encryption_method
        pw_encryption_method="$(command cat /etc/login.defs |
        awk '/^ENCRYPT_METHOD/ { print $2 }')"

        if [[ "${opt_a}" -eq 1 ]]; then
                pw_encryption_method="$(anonymize_data ${pw_encryption_method})"
        fi

        data_line "Pw. Encryption" "${pw_encryption_method}" \
        "${1}" "${2}" "${3}"
}

function display_drive_encryption()
{
        [[ $(command -v lsblk) ]] || return
        [[ $(command -v blkid) ]] || return

        local encryption_method disk_blkid device_name
        encryption_method="crypto_LUKS"

        for i in $(lsblk -lpno NAME); do
                disk_blkid="$(blkid ${i})"
                if [[ "${disk_blkid}" =~ ${encryption_method} ]]; then
                        device_name="$(echo ${i} | cut -d ' ' -f 1 | tr -d ':')"
                        data_line "Encrypted" \
                        "${device_name} ${2}(${encryption_method})${N}" \
                        "${1}" "${2}" "${3}" 
                fi
        done
}

function display_SELinux()
{
        [[ $(command -v sestatus) ]] || return

        local SELinux_state SELinux_policy SELinux_total

        SELinux_state="$(sestatus | awk '/status/ { print $2 }')"
        SELinux_state="${2}${SELinux_state^}${N}"

        SELinux_policy="$(getenforce)"
        SELinux_policy="${2}(${N}${SELinux_policy}${2})${N}"

        SELinux_total="${SELinux_state} ${SELinux_policy}"

        if [[ "${opt_a}" -eq 1 ]]; then
                SELinux_total="$(anonymize_data ${SELinux_total})"
        fi

        data_line "SELinux" "${SELinux_total}" "${1}" "${2}" "${3}"
}

### Disks and filesystems ###

function display_fs_usage()
{
        [[ $(command -v lsblk) ]] || return
        [[ $(command -v df) ]] || return

        local _mountpoint
        local bar_complete bar_empty bar_filled
        local nb_block_empty nb_block_filled
        local total_length right_length
        local disk_usage disk_free_space
        local msg msg_colored msg_diff
        local color

        mountpoint_length_max="${3}"
        total_length="${4}"

        for i in $(command lsblk -no MOUNTPOINTS | grep -v '^$'); do
                disk_usage="$(command df ${i} |
                awk 'NR==2 { print $5 }' | sed 's/%//')"

                disk_free_space="$(command df ${i} | awk 'NR==2 { print $4 }')"

                # Convert to GB
                disk_free_space=$(awk "BEGIN { 
                        print ${disk_free_space} / 1024 / 1024
                }")

                # Truncate output if it's too long
                if [[ "${#i}" -gt "${mountpoint_length_max}" ]]; then
                        i="...${i: -$((mountpoint_length_max - 3))}"
                fi

                right_length=$((total_length - ${#i} + 2))
                printf "  %b" "${1}${i}${N}"

                msg="$(printf "%b: %.2fGB, %b: %b%%" "Free space" \
                "${disk_free_space}" "Used" "${disk_usage}")"

                msg_colored="$(printf "%b: ${C2}%.2f${N}GB, %b: ${C3}%b%%${N}" \
                "Free space" "${disk_free_space}" "Used" "${disk_usage}")"

                msg_diff=$((${#msg_colored} - ${#msg}))

                printf "%$((right_length + msg_diff))b\n" "${msg_colored}"

                if [[ "${disk_usage}" -gt 90 ]]; then
                        # Normally RED 
                        color="${C1}"
                elif [[ "${disk_usage}" -gt 70 ]]; then
                        # Normally YELLOW 
                        color="${C3}"
                else
                        # Normally GREEN
                        color="${C2}"
                fi

                nb_block_filled=$((disk_usage * total_length / 100))
                nb_block_empty=$((total_length - nb_block_filled))

                bar_filled="$(printf "%*s" "${nb_block_filled}" | tr ' ' '|')"
                bar_empty="$(printf "%*s" "${nb_block_empty}" | tr ' ' ' ')"

                bar="${color}${bar_filled}${N}${bar_empty}"

                printf "  [%b]\n" "${bar}"
        done
}

function display_disks_temp()
{
        [[ "${EUID}" -ne 0 ]] && return
        [[ $(command -v smartctl) ]] || return
        [[ $(command -v lsblk) ]] || return

        local disks counter temp
        disks="$(lsblk -do NAME | grep -E '^[a-z0-9]+$')"
        counter=0

        # Indentation
        printf "%s" "  "

        for i in ${disks[@]}; do
                if [[ "${i}" =~ ^nvme.* ]]; then
                        temp="$(smartctl --all /dev/${i} |
                        awk '/Temperature:/ { print $2 }')"
                else
                        temp="$(smartctl --all /dev/${i} |
                        awk '/Temperature/ { print $10 }')"
                fi

                # If temperature cannot be fetched, skip and do nothing
                [[ -z "${temp}" ]] && continue

                i="${1}${i}${N}"
                temp="${2} ${temp}°C ${N}"

if [[ "${counter}" -lt 3 ]]; then
                        printf "%b: %b " "${i}" "${temp}"
                        ((counter++))
                        if [[ "${counter}" -eq 3 ]]; then
                                counter=0
                                printf "%b" "\n"
                                # Indentation
                                printf "%s" "  "
                        fi
                fi
        done

        if [[ "${counter}" -ne 3 ]]; then
                printf "%b" "\n"
        fi
}

### Services ###

function services_function()
{
        [[ $(command -v systemctl) ]] || return

        printf "%b" "Services status\n"
        display_services
        printf "%b" "\n"
}

function display_services()
{
        [[ $(command -v systemctl) ]] || return

        local services_list present_services
        services_list=(
                "sshd"
                "nftables"
                "firewalld"
                "apparmor"
                "apache2"
                "httpd"
                "docker"
                "lxd"
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
                "usbguard"
                "qemu-guest-agent"
                "zabbix-agent"
                "snmpd"
                "cups"
                "bluetooth"
                "containerd"
        )

        # If service exists, add it in another list
        for i in "${services_list[@]}"; do
                if [[ $(systemctl list-units --type=service --all |
                grep -io "${i}.service") ]]; then
                        present_services+=("${i}")
                fi
        done

        local max_length
        local pre_state post_state
        local state_color
        local dot counter
        counter=0
        max_length=40

        for i in "${present_services[@]}"; do
                pre_state="$(systemctl is-active ${i}.service)"

                # Change color if service is up/down/failed
                if [[ "${pre_state}" == "active" ]]; then
                        post_state="(active)"
                        # Normally GREEN
                        state_color="${C2}"
                elif [[ "${pre_state}" == "inactive" ]]; then
                        post_state="(inactive)"
                        # Normally YELLOW 
                        state_color="${C3}"
                elif [[ "${pre_state}" == "failed" ]]; then
                        post_state="(failed!)"
                        # Normally RED 
                        state_color="${C1}"
                fi

                dot="●"

                limit_length=$((max_length - ${#dot} - ${#i} - ${#post_state}))

                post_state="${state_color}${post_state}${N}"
                dot="${state_color}${dot}${N}"

                if [[ "${counter}" -eq 0 ]]; then
                        # Indentation
                        printf "%s" "  "
                fi

                printf "%b %b %b %${limit_length}s" "${dot}" "${i}" \
                "${post_state}" " "

                ((counter++))

                if [[ "${counter}" -eq 2 ]]; then
                        printf "%b" "\n"
                        counter=0
                fi
        done

        if [[ "${counter}" -ne 3 ]]; then
                printf "%b" "\n"
        fi
}

function docker_function()
{
        [[ $(command -v systemctl) ]] || return
        [[ $(command -v docker) ]] || return
        [[ $(systemctl is-active docker.service) == "inactive" ]] && return
        [[ -z $(docker ps -a 2> /dev/null | tail +2) ]] && return

        printf "%b" "Docker containers\n"
        display_docker_containers
        printf "%b" "\n"
}

function display_docker_containers()
{
        # Must be root or in the docker group
        [[ "${EUID}" -ne 0 || $(id -nG) =~ \bdocker\b ]] && return
        [[ $(command -v docker) ]] || return

        local docker_ct_active docker_ct_exited

        for i in $(docker ps --filter "status=running" --format "{{.Names}}")
        do
                docker_ct_active+=("${i}")
        done

        for i in $(docker ps --filter "status=exited" --format "{{.Names}}")
        do
                docker_ct_exited+=("${i}")
        done

        local dot state counter max_length

        counter=0
        max_length=0

        for i in ${docker_ct_active[@]}; do
                state="(running)"
                dot="${C6}●${N}"
                limit_length=$((max_length - 1 - ${#i} - ${#state}))
                state="${C6}${state}${N}"

                if [[ "${counter}" -eq 0 ]]; then
                        # Indentation
                        printf "%b" "  "
                fi

                printf "%b %b %b %${limit_length}s" "${dot}" "${i}" \
                "${state}" " "
                
                ((counter++))

                if [[ "${counter}" -eq 2 ]]; then
                        printf "%b" "\n"
                        counter=0
                fi
        done

        counter=0

        for i in ${docker_ct_exited[@]}; do
                state="(exited)"
                dot="${C4}●${N}"
                limit_length=$((max_length - 1 - ${#i} - ${#state}))
                state="${C6}${state}${N}"

                if [[ "${counter}" -eq 0 ]]; then
                        # Indentation
                        printf "%b" "  "
                fi

                printf "%b %b %b %${limit_length}s" "${dot}" "${i}" \
                "${state}" " "
                
                ((counter++))

                if [[ "${counter}" -eq 2 ]]; then
                        printf "%b" "\n"
                        counter=0
                fi
        done
}

main "${@}"
