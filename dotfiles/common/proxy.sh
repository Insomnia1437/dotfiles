# define proxy server if necessary
{%@@ if USE_PROXY == "YES" @@%}
# active proxy in ~/.config/common/local.sh
alias setproxy="export http_proxy=http://{{@@ PROXY @@}}; export https_proxy=http://{{@@ PROXY @@}}; export HTTPs_PROXY=http://{{@@ PROXY @@}}; export HTTPS_PROXY=http://{{@@ PROXY @@}}"
alias noproxy="unset http_proxy; unset https_proxy; unset HTTP_PROXY; unset HTTPS_PROXY"
{%@@ endif @@%}

