if [ -f /opt/rh/devtoolset-9/enable ]; then
    source /opt/rh/devtoolset-9/enable
elif [ -f /opt/rh/devtoolset-7/enable ]; then
    source /opt/rh/devtoolset-7/enable
fi

if [ -f /opt/rh/rh-python38/enable ]; then
    source /opt/rh/rh-python38/enable
fi

if [ -f /opt/rh/rh-git227/enable ]; then
    source /opt/rh/rh-git227/enable
fi
