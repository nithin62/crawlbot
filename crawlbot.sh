#!/bin/bash
banner="░█████╗░██████╗░░█████╗░░██╗░░░░░░░██╗██╗░░░░░██████╗░░█████╗░████████╗
██╔══██╗██╔══██╗██╔══██╗░██║░░██╗░░██║██║░░░░░██╔══██╗██╔══██╗╚══██╔══╝
██║░░╚═╝██████╔╝███████║░╚██╗████╗██╔╝██║░░░░░██████╦╝██║░░██║░░░██║░░░
██║░░██╗██╔══██╗██╔══██║░░████╔═████║░██║░░░░░██╔══██╗██║░░██║░░░██║░░░
╚█████╔╝██║░░██║██║░░██║░░╚██╔╝░╚██╔╝░███████╗██████╦╝╚█████╔╝░░░██║░░░
░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚══════╝╚═════╝░░╚════╝░░░░╚═╝░░░
"
echo "$banner"


function URL_Validate {
    url="$1://$2/robots.txt"
    echo url: $url
    status=$(curl -s --head -w %{http_code} $url -o /dev/null)
    echo "status : $status"
    res="$(statuscheck $status)"

    if [[ $res == '1' ]]; then
        downloadRobots $url
    else
        echo "Invalid Domain name or Url!"
        exit
    fi
}


#checking_request_bad_or_not
statuscheck() {
    declare -a badRqs=(000 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 421 422 423 424 425 426 428 431 451 501 502 503 504 505 506 507 508 510 511)
    local logic=1
    for i in "${!badRqs[@]}"
    do
        if [ $1 == ${badRqs[i]} ]
        then
            logic=0
            break
        fi
    done
    echo $logic
}


#downloading_robots.txt_and_appending_it_to_all.txt_textfile_inside_our_created_domain_directory
downloadRobots() {
    echo "checking if the robots.txt exists in $URL..."
    if wget $1 >/dev/null 2>&1 ; then
        echo "robots.txt exists!"
    else
        echo "robots.txt doesnt exist!"
        exit
    fi

    mkdir $URL
    echo "" > $URL/all.txt
    wget -qO- $1 >> $URL/all.txt

    echo "" >> $URL/all.txt

    if [[ -f "robots.txt" ]]; then
        rm robots.txt
    fi
    customizing
}

#filtering_allows_and_disallows_from_all.txt_and_appending_them_to_the_respective_textfiles
function customizing {
    echo "" > $URL/allows.txt && echo "" > $URL/disallows.txt
    while read -r cont; do
        if [[ ${cont:0:5} == 'Allow' ]]; then
            echo "${cont}" >> $URL/allows.txt
        fi

        if [[ ${cont:0:5} == 'Disal' ]]; then
            echo "${cont}" >> $URL/disallows.txt
        fi
    done < $URL/all.txt
    echo "download completed. output saved in /all.txt, /allows.txt, /disallows.txt in the $URL directory"
}




#validating_as_http_or_https
URL=$1

if wget --spider https://$URL 2>/dev/null; then
  URL_Validate "https" "$URL"
else
  URL_Validate "http" "$URL"
fi  










