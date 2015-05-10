#!/usr/bin/env bash
# Author : Imra Ahmed <researcher6@live.com>
# URL  : https://www.experthelpme.com
# Description : Bash script to control cloud flair DNS entries.

if [ $# -lt 6 ]; then
echo "usage: $0  --zone=<zone> --subdomain=<subdomain> --ip=<ip address> --key=<key> --email=<email> --timeout=<timeout>"
	exit 1;
fi

optspec=":hv-:"
zone=""
subdomain=""
ip=""
email=""
key=""
timeout=""
recid=""
while getopts "$optspec" optchar ; do
    case "${optchar}" in
        -)
      case "${OPTARG}" in
		zone=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
		    zone=${val}
                    ;;
		subdomain=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
		    subdomain=${val}
                    ;;
		ip=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
		    ip=${val}
                    ;;
		email=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
		    email=${val}
                    ;;
		key=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
	            key=${val}
                    ;;
                timeout=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    timeout=${val}
                    ;;

                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
		;;


            esac;;
        *)
    echo "usage: $0  --zone=<zone> --subdomain=<subdomain> --ip=<ip address> --key=<key> --email=<email> --timeout=<timeout>" >&2
      exit 2
      ;;
    esac
done

echo "Downloading DNS information from Cloudflare server and saving it in local file [server-before.log] "
response_json=`curl -k https://www.cloudflare.com/api_json.html?a=rec_load_all\&z="$zone"\&email="$email"\&tkn="$key"`
echo "$response_json " > server-before.log
cat server-before.log  | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep rec_id | sed  's/"//g' | sed 's/objs:\[//g' | sed 's/rec_id://g' >recids 

IFS=$'\n' read -d '' -r -a id < recids
len=${#id[*]} #Num elements in array

                        r=0
                        while [ $r -lt $len ]; do
                                myid=${id[$r]}
	                        response_json=`curl -k https://www.cloudflare.com/api_json.html?a=rec_delete\&z=$zone\&email=$email\&tkn=$key\&id=$myid`

                                let r++
                        done
>working.txt
>notworking.txt

for i in $(echo $ip | tr "," "\n")
do
 if curl -s -w %{time_total}\\n -o /dev/null http://$i
 
        then
          			echo "IP : $i is accessible. DNS record will be added for it."
				 echo "$i">> working.txt
				  myurl="`curl -k https://www.cloudflare.com/api.html?a=rec_new\&name=$subdomain\&email=$email\&tkn=$key\&content=$i\&type=A\&z=$zone\&ttl=$timeout`" 
        else
                  		echo "IP : $i is  NOT accesible !"
		  	        echo "$i" >> notworking.txt
        fi
done

echo "Downloading DNS information from Cloudfare server after changes. Saving in [server-after.log]"
response_json=`curl -k https://www.cloudflare.com/api_json.html?a=rec_load_all\&z="$zone"\&email="$email"\&tkn="$key"`
echo "$response_json " > server-after.log
echo " List of working IPs:"
cat working.txt
echo "List of non-working IPs:"
cat notworking.txt
