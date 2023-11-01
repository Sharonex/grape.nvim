
only_use_once_flags=" -L --line-number -l --with-filename --column -c "

# split before and after the first ' -- '
arg_string="$*"

# Use cut to split the string into two parts at the --
rg_options=$(echo $* | awk -F ' -- ' '{ print $1}')
words=$(echo $* | awk -F ' -- ' '{ print $2}')

repeatable_options=()
for item in $rg_options; do
    if ! [[ $(echo $only_use_once_flags | grep -- "$item") ]]; then
        repeatable_options+=("$item")
    fi
done


counter=0
for i in $words; do
    if [[ $counter -eq 0 ]]; then
        res+="${rg_options[@]} $i | "
    else
        res+="${repeatable_options[@]} $i | "
    fi
    counter+=1
done

# remove trailing |
res=${res% | }

echo $res >> /tmp/rg_runner.log

eval $res
