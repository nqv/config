# $1 Input file
# $2 First page
# $3 Last page
# Output file: "InputFile_pXX-pYY.pdf"

INPUT_FILE="$1"
FIRST_PAGE="$2"
if [ -z "$INPUT_FILE" ] || [ -z "$FIRST_PAGE" ]; then
	echo "$0 <PDF_FILE> <FIRST_PAGE> [LAST_PAGE]"
	exit 1
fi

LAST_PAGE="$3"
if [ -z "$LAST_PAGE" ]; then
	LAST_PAGE="$FIRST_PAGE"
fi

gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
	-dFirstPage="$FIRST_PAGE" \
	-dLastPage="$LAST_PAGE" \
	-sOutputFile="${1%.pdf}_p${FIRST_PAGE}-p${LAST_PAGE}.pdf" \
	"$INPUT_FILE"
