split_array_once() {
	local split_on="$1"
	shift
	local arr=("$@")

	for i in "${!arr[@]}"; do
		if [[ "${arr[$i]}" = "$split_on" ]]; then
			pre=("${arr[@]:0:$i}")
			post=("${arr[@]:$((i+1))}")
			return 0;
		fi
	done

	return 1;
}
