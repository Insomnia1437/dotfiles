# define proxy server if necessary
{%@@ if profile == "server-linac" @@%}
PROXY_SERVER={{@@ linac_proxy @@}}
export http_proxy=http://${PROXY_SERVER}
export https_proxy=https://${PROXY_SERVER}

alias setproxy="export http_proxy=http://${PROXY_SERVER}; export https_proxy=https://${PROXY_SERVER}"
alias noproxy="unset http_proxy; unset https_proxy"
{%@@ endif @@%}

