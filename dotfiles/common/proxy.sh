# define proxy server if necessary
{%@@ if USE_PROXY == "YES" @@%}
# PROXY_SERVER={{@@ PROXY @@}}
# http_proxy=http://${PROXY_SERVER}
# https_proxy=https://${PROXY_SERVER}

# active proxy in ~/.config/common/local.sh
alias setproxy="export http_proxy=http://{{@@ PROXY @@}}; export https_proxy=https://{{@@ PROXY @@}}"
alias noproxy="unset http_proxy; unset https_proxy"
{%@@ endif @@%}

