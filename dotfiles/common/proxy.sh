# define proxy server if necessary
{%@@ if USE_PROXY == "YES" @@%}
# active proxy in ~/.config/common/local.sh
setproxy() {
    local proxy_addr="${1:-{{@@ PROXY @@}}}"
    export http_proxy="http://${proxy_addr}"
    export https_proxy="http://${proxy_addr}"
    export HTTP_PROXY="http://${proxy_addr}"
    export HTTPS_PROXY="http://${proxy_addr}"
    export ALL_PROXY="http://${proxy_addr}"
    export all_proxy="http://${proxy_addr}"
    export no_proxy="{{@@ NO_PROXY @@}}"
    echo "Proxy on: ${proxy_addr}"
}

unsetproxy() {
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ALL_PROXY
    unset all_proxy
    unset no_proxy
    echo "Proxy off"
}
{%@@ endif @@%}