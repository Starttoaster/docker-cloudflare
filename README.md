# docker-cloudflare
dDNS container for Cloudflare A Records. Finds A Record identifiers and updates Cloudflare on your current IP address in adjustable time intervals.

# Use

You can either start this container via `docker run` or `docker-compose`. I attached a sample docker-compose.yml file in the repo to use if desired.

Via docker run: `docker run -d -e USER_EMAIL="email@email.com" -e USER_APIKEY="my_global_api_key" -e USER_ZONE="my_zone_id" starttoaster/cloudflare-ddns`

NOTE: The bare minimum required details to interact with Cloudflare's DNS API is the account email, Global API Key, and Zone ID attributes. This container finds other necessary attributes 
without requiring user input by itself, but if you need help finding the 3 required attributes I listed, view the section below regarding "API Attributes".

# Environment Variables

| Variable | Function | Required/Optional |
| ---- | ---- | --- |
| -e INTERVAL | A number, in seconds, for how often to run the update job. Default is 5 minutes (300s) | Optional |
| -e USER_EMAIL | The email address associated with your Cloudflare account | Required |
| -e USER_APIKEY | A unique 'Global API Key' is assigned to every Cloudflare DNS user | Required |
| -e USER_ZONE | A unique 'Zone ID' is assigned to each domain registered in a Cloudflare account | Required |

# API Attributes

Email: This is simply the email address used to sign up for Cloudflare. This can be found under "My Profile".

Global API Key: This is found in the Cloudflare website under "My Profile > API Keys > Global API Key" 

[See this link on finding the Global API Key](https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-CloudFlare-API-key-)

Zone Identifier: Found in the Cloudflare website on your domain's "Overview" page written as "Zone ID"

# System Requirements

| Hardware | Utilization |
| ---- | ---- |
| Disk | 8.4MB |
| CPU | Basically nothing |
| RAM | 1.1MB |

