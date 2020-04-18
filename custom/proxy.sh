# proxy server
PROXY_SERVER=172.19.64.17:8080
# export http_proxy=http://${PROXY_SERVER}
# export https_proxy=https://${PROXY_SERVER}

alias setproxy="export http_proxy=http://${PROXY_SERVER}; export https_proxy=https://${PROXY_SERVER}"
alias noproxy="unset http_proxy; unset https_proxy"
