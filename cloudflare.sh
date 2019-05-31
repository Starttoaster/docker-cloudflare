#!/bin/sh

EMAIL="$USER_EMAIL"
GAPIK="$USER_APIKEY"
ZONE="$USER_ZONE"

if [ -z "$GAPIK" ] || [ -z "$EMAIL" ] || [ -z "$ZONE" ]; then
    echo "Missing required environment variables!!" 1>&2
    exit 1
fi

while true
do
getIdent() {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "id" \
             | grep -v "zone" \
             | sed 's/ //g' \
             | sed 's/{"id":"//g' \
             | sed 's/"//g'
}
getType() {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "type" \
             | sed 's/ //g' \
             | sed 's/"type":"//g' \
             | sed 's/"//g'
}
getSub() {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | grep "name" \
             | grep -v "zone" \
             | sed 's/ //g' \
             | sed 's/"name":"//g' \
             | cut -f1 -d"."
}
getProxy() {
        curl -sX GET "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
             -H "X-Auth-Email: "$EMAIL"" \
             -H "X-Auth-Key: "$GAPIK"" \
             -H "Content-Type: application/json" \
             | tr '[' '\n' \
             | tr ',' '\n' \
             | sed 's/{//g' \
             | grep "proxied" \
             | sed 's/"proxied"://g' \
             | sed 's/"//g'
}
setIP() {
	IP=$(curl -s4 ifconfig.co)
	curl -sX PUT "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
		-H "X-Auth-Email: "$EMAIL"" \
		-H "X-Auth-Key: "$GAPIK"" \
		-H "Content-Type: application/json" \
		--data '{"type":"A","name":"'$SUB'","content":"'$IP'","proxied":'$PROXY'}' \
		| tr '[' '\n' \
		| tr ',' '\n' \
		| grep "content\|name\|proxied\|success" \
		| grep -v "zone" \
		| sed 's/ //g'
}
getIdent | while read -r IDENT; do
        if [ "$(getType)" = "A" ]; then
                SUB=$(getSub)
		PROXY=$(getProxy)
                setIP
                echo "-----------------"
        fi;done
echo "*****************"

export INTERVAL=$(echo "$INTERVAL" | sed 's/[A-Za-z]//g')
sleep "$INTERVAL"
done
