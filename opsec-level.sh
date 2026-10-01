#!/bin/sh

# gets current VPN and browser
# to determine one's opsec level

get_active_vpns() {
    local found=""
    local warp_iface=0

    _add_vpn() {
        case ",$found," in
            *",$1,"*) ;;
            *) found="${found:+$found,}$1" ;;
        esac
    }

    for path in /sys/class/net/*; do
        [ -d "$path" ] || continue
        local iface=${path##*/}
        
        # skip down interfaces 
        [ "$(cat "$path/operstate" 2>/dev/null)" = "down" ] && continue

        case $iface in
            CloudflareWARP*)    warp_iface=1 ;;
            tailscale*)         _add_vpn Tailscale ;;
            wg*)                _add_vpn WireGuard ;;
            tun*|tap*)          _add_vpn OpenVPN ;;
            nordlynx*|nordtun*) _add_vpn NordVPN ;;
            proton*|pvpn*)      _add_vpn ProtonVPN ;;
            mullvad*)           _add_vpn Mullvad ;;
        esac
    done

    # if we have warp cli use it in case not detected by interfaces
    if command -v warp-cli >/dev/null 2>&1; then
        timeout 2 warp-cli status 2>/dev/null | grep -q "Connected" && _add_vpn "Cloudflare WARP"
    elif [ "$warp_iface" = 1 ]; then
        _add_vpn "Cloudflare WARP"
    fi

    echo "${found:-None}"
}

get_default_browser() {
    if command -v xdg-settings >/dev/null 2>&1; then
        local desktop_file
        desktop_file=$(xdg-settings get default-web-browser 2>/dev/null)
        if [ -n "$desktop_file" ]; then
            local name="${desktop_file%.desktop}"
            case "${name,,}" in
                *firefox*)        echo "Firefox" ;;
                *google-chrome*)  echo "Google Chrome" ;;
                *chromium*)       echo "Chromium" ;;
                *brave*)          echo "Brave" ;;
                *opera*)          echo "Opera" ;;
                *vivaldi*)        echo "Vivaldi" ;;
                *epiphany*|*gnome-web*) echo "Epiphany" ;;
                *midori*)         echo "Midori" ;;
                *konqueror*)      echo "Konqueror" ;;
                *librewolf*)      echo "LibreWolf" ;;
                *waterfox*)       echo "Waterfox" ;;
                *palemoon*)       echo "Pale Moon" ;;
                *seamonkey*)      echo "SeaMonkey" ;;
                *tor-browser*)    echo "Tor Browser" ;;
                *helium*)          echo "Helium Browser" ;;
                *microsoft-edge*|*msedge*) echo "Microsoft Edge" ;;
                *)                
                    local capitalized="${name^}"
                    echo "$capitalized"
                 ;;
            esac
            return
        fi
    fi
    echo "Unknown"
}

get_opsec_level() {
    local vpn_status
    local browser_status
    
    vpn_status=$(get_active_vpns)
    browser_status=$(get_default_browser)

    local vpn_part="No VPN"
    [ "$vpn_status" != "None" ] && vpn_part="$vpn_status"

    local browser_part="No Browser"
    [ "$browser_status" != "None" ] && browser_part="$browser_status"

    echo "$vpn_part + $browser_part"
}

get_opsec_level
