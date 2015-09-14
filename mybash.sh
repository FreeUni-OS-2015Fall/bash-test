#! /bin/bash

# \x1B -> \e
red='\x1B[0;31m'
green='\x1B[0;32m'
yellow='\x1B[0;33m'
blue='\x1B[0;34m'
endColor='\x1B[0m'

test_dir=/home/gkiko/Desktop/bash/tests
assign_dir=/home/gkiko/Desktop/bash/assigns
out_dir=outs/
err_dir=errors/

display_summary () {
  if [ $1 -eq 0 ]
  then
    echo -e "${green}SUCCESS${endColor}"
  else
    echo -e "${red}FAIL" >&2
    cat $2 >&2
    printf "${endColor}"
  fi
}

run_tests () {
  echo -e "${yellow}$1${endColor}"
  mkdir "$1/$out_dir" "$1/$err_dir" 2> /dev/null

  counter=1
  for f in $test_dir/*;
  do
    printf "${blue}test #$counter:${endColor} $f "
    base_name=$(basename $f)
    out_file=$1/$out_dir"${base_name%.*}.out"
    error_file=$1/$err_dir"${base_name%.*}.err"
    # echo $out_file

    sh $f > "$out_file" 2> "$error_file"
    return_code=$?

    display_summary $return_code $error_file

    ((counter++))
  done

}

for each_group in $assign_dir/*
do
  for each_assign in $each_group/*
  do
    if [[ $each_assign == *"assign1"* ]]
    then
      find "$each_assign" -type f -executable | while read line; do
        # echo "---" $each_assign
        export UNDER_TEST=$line
        run_tests "$each_assign"
      done
    fi
  done
done
