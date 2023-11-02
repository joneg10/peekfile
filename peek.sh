if [[ -n $2 ]]; then numberlines=$2; fi
if [[ -z $2 ]]; then numberlines=3; fi 


if [[ $((2 * numberlines)) -ge $(wc -l < $1) ]]; then cat $1; fi


if [[ $((2 * numberlines)) -lt $(wc -l < $1) ]]; then echo WARNING!; head -n $numberlines $1; echo ...; tail -n $numberlines $1; fi

