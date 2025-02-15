#!/bin/bash 
# If dockerfile failed install manually
if [ -e "/ENVFILE" ]; then
    echo "Executing script"
    PACKAGES=$(</ENVFILE)
    (
        #######################
        # Automatic installer #
        #######################
        if ! command -v bash >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash); fi &&
            if ! command -v curl >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl); fi &&
            curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/automatic_packages.sh" --output /automatic_packages.sh &&
            chmod 777 /automatic_packages.sh &&
            eval /./automatic_packages.sh "$PACKAGES" &&
            rm /automatic_packages.sh

    ) >/dev/null

fi

if [ -e "/MODULESFILE" ]; then
    echo "Executing modules script"
    PACKAGES=$(</MODULESFILE)
    (
        ##############################
        # Automatic modules download #
        ##############################
        if ! command -v bash >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends bash || apk add --no-cache bash); fi &&
            if ! command -v curl >/dev/null 2>/dev/null; then (apt-get update && apt-get install -yqq --no-install-recommends curl || apk add --no-cache curl); fi &&
            mkdir -p /tmpscripts /scripts /etc/cont-init.d \
            && for scripts in "$PACKAGES"; do \
            && curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/$PACKAGES" -o /tmpscripts/$scripts \
            done \
            && /bin/cp -rf /tmpscripts/* /scripts/ \
            && /bin/cp -rf /tmpscripts/* /etc/cont-init.d/ \
            && chmod -R 777 /scripts \
            && chmod -R 777 /etc/cont-init.d \
            rm -rf /tmpscripts
    ) >/dev/null

fi
