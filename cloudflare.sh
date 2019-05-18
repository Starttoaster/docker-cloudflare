#!/bin/sh

EMAIL="$USER_EMAIL"
GAPIK="$USER_APIKEY"
ZONE="$USER_ZONE"

while true
do
getIdent() {
        wget --no-check-certificate --header="X-Auth-Email: "$EMAIL"" --header="X-Auth-Key: "$GAPIK"" \
                -qO- "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records" \
                | tr '[' '\n' \
                | tr ',' '\n' \
                | sed 's/{//g' \
                | grep "id" \
                | grep -v "zone" \
                | sed 's/"id"://g' \
                | sed 's/"//g'
}
getType() {
        wget --no-check-certificate --header="X-Auth-Email: "$EMAIL"" --header="X-Auth-Key: "$GAPIK"" \
                -qO- "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
                | tr '[' '\n' \
                | tr ',' '\n' \
                | sed 's/{//g' \
                | grep "type" \
                | sed 's/"type"://g' \
                | sed 's/"//g'
}
getSub() {
        wget --no-check-certificate --header="X-Auth-Email: "$EMAIL"" --header="X-Auth-Key: "$GAPIK"" \
                -qO- "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
                | tr '[' '\n' \
                | tr ',' '\n' \
                | sed 's/{//g' \
                | grep "name" \
                | grep -v "zone" \
                | sed 's/"name"://g' \
                | sed 's/"//g' \
                | cut -f1 -d"."
}
getProxy() {
	wget --no-check-certificate --header="X-Auth-Email: "$EMAIL"" --header="X-Auth-Key: "$GAPIK"" \
		-qO- "https://api.cloudflare.com/client/v4/zones/"$ZONE"/dns_records/"$IDENT"" \
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
        fi;done

export INTERVAL=$(echo "$INTERVAL" | sed 's/[A-Za-z]//g')
sleep "$INTERVAL"s
done
