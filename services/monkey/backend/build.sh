#!/usr/bin/env bash
set -e

if [ -d "build" ]; then rm -rf build; fi
install -d build

root=$PWD
export GOOS=linux

lambdas=()

build() {
    main_file=$1
    cd $(dirname $main_file)
	basename="$(basename $(dirname $main_file))"
	go build -o main
	output_file="$root/build/lambda-$basename.zip"
	echo "Building lambda-$basename.zip"
	touch -mt 200001011337 main
	zip -q -X $output_file main
	rm main

	if [ -f main.tf ]; then
		if [ -f $root/build/lambdas.tf ]; then
			echo "\n\n" >> $root/build/lambdas.tf; 
		fi
		echo "### AWS lambda: $basename ###" >> $root/build/lambdas.tf
		cat main.tf >> $root/build/lambdas.tf
	fi
	lambdas+=($basename)

	if [ ! -f $output_file ]; then
		echo "File '$output_file' not found!"
		exit 1
	fi

	cd $root
}

for main_file in `find cmd -type f -name main.go`; do
    build $main_file
done

echo "Creates vars.tf"
vars=()
re="var\.([a-z_]+)"
s+=`cat build/lambdas.tf`
while [[ $s =~ $re ]]; do
	match=0
	for e in "${vars[@]}"; do 
		[[ "$e" == "${BASH_REMATCH[1]}" ]] && match=1; 
	done

	if [[ "$match" -eq 0 ]]; then
		echo 'variable "'${BASH_REMATCH[1]}'" {}' >> build/vars.tf
		vars+=(${BASH_REMATCH[1]})
	fi
    s=${s#*"${BASH_REMATCH[1]}"}
done

echo "Great success"