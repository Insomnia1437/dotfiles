# define proxy server if necessary
{%@@ if USE_PROXY == "YES" @@%}
# active proxy in ~/.config/common/local.sh
setproxy() {
    export http_proxy="http://{{@@ PROXY @@}}"
    export https_proxy="http://{{@@ PROXY @@}}"
    export HTTP_PROXY="http://{{@@ PROXY @@}}"
    export HTTPS_PROXY="http://{{@@ PROXY @@}}"
    export ALL_PROXY="http://{{@@ PROXY @@}}"
    export all_proxy="http://{{@@ PROXY @@}}"
    export no_proxy="{{@@ NO_PROXY @@}}"
    echo "Proxy on"
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

