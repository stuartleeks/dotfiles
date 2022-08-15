# https://gist.github.com/data-henrik/f8761782bd131148fdd05abedeaa2f63

BASE64_DECODER_PARAM="-d" # option -d for Linux base64 tool
echo AAAA | base64 -d > /dev/null 2>&1 || BASE64_DECODER_PARAM="-D" # option -D on MacOS

decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'='
  fi
  echo "$result" | tr '_-' '/+' | base64 $BASE64_DECODER_PARAM
}

decode_jose(){
   input=$2
   if [[ -z "$input" ]]; then
      if test ! -t 0; then
         # stdin is not a terminal, assume input is piped
         echo "Reading input from stdin..." >&2
         input=$(cat -)
      fi
   fi
   decode_base64_url $(echo -n $input | cut -d "." -f $1) | jq .
}

decode_jwt_part(){
   input=$2
   if [[ -z "$input" ]]; then
      if test ! -t 0; then
         # stdin is not a terminal, assume input is piped
         echo "Reading input from stdin..." >&2
         input=$(cat -)
      fi
   fi
   decode_jose $1 $input | jq 'if .iat then (.iatStr = (.iat|todate)) else . end | if .exp then (.expStr = (.exp|todate)) else . end | if .nbf then (.nbfStr = (.nbf|todate)) else . end'
}

decode_jwt(){
   input=$1
   if [[ -z "$input" ]]; then
      if test ! -t 0; then
         # stdin is not a terminal, assume input is piped
         echo "Reading input from stdin..." >&2
         input=$(cat -)
      fi
   fi
   decode_jwt_part 1 $input
   decode_jwt_part 2 $input
}

# Decode JWT header
alias jwth="decode_jwt_part 1"

# Decode JWT Payload
alias jwtp="decode_jwt_part 2"

# Decode JWT header and payload
alias jwthp="decode_jwt"


# Decode JWE header
alias jweh="decode_jose 1"
