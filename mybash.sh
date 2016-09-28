#! /bin/bash

# \x1B -> \e
red='\x1B[0;31m'
green='\x1B[0;32m'
yellow='\x1B[0;33m'
blue='\x1B[0;34m'
endColor='\x1B[0m'

assign_dir=$1
test_dir=./tests
out_dir=outs/
err_dir=errors/

display_summary () {
  if [ $1 -eq 0 ]
  then
    echo -e "${green}SUCCESS${endColor}"
  else
    echo -e "${red}FAIL" >&2
    cat "$2" >&2
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

    bash $f > "$out_file" 2> "$error_file"

    display_summary $? "$error_file"

    ((counter++))
  done

}

elf_under_test=$(find "$assign_dir" -perm /111 -type f | head -n1)
if ! [[ -x "$elf_under_test" ]]
then
    echo "File '$elf_under_test' is not executable or found"
fi

export UNDER_TEST=$elf_under_test
run_tests "$assign_dir"
