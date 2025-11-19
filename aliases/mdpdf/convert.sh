#!/bin/bash

# Convert markdown to PDF with styled codeblocks
# Usage: mdpdf input.md [output.pdf]

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: mdpdf <input.md> [output.pdf]"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Determine output file name
if [ -z "$2" ]; then
    OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
else
    OUTPUT_FILE="$2"
fi

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed"
    echo "Install with: sudo apt-get install pandoc"
    exit 1
fi

# Check if wkhtmltopdf is installed (for better PDF generation)
if command -v wkhtmltopdf &> /dev/null; then
    # Use wkhtmltopdf for better rendering
    TEMP_HTML=$(mktemp /tmp/mdpdf_XXXXXX.html)
    
    pandoc "$INPUT_FILE" \
        --standalone \
        --self-contained \
        --css="$SCRIPT_DIR/template.css" \
        --metadata title="Document" \
        -f markdown \
        -t html5 \
        -o "$TEMP_HTML"
    
    wkhtmltopdf \
        --enable-local-file-access \
        --print-media-type \
        "$TEMP_HTML" \
        "$OUTPUT_FILE"
    
    rm -f "$TEMP_HTML"
else
    # Fallback to pandoc's built-in PDF generation
    echo "Note: wkhtmltopdf not found, using pandoc's PDF engine (install wkhtmltopdf for better results)"
    
    # Check if pdflatex is available
    if command -v pdflatex &> /dev/null; then
        pandoc "$INPUT_FILE" \
            --standalone \
            --pdf-engine=pdflatex \
            --highlight-style=tango \
            -V geometry:margin=1in \
            -o "$OUTPUT_FILE"
    else
        echo "Error: Neither wkhtmltopdf nor pdflatex is installed"
        echo "Install one of:"
        echo "  - sudo apt-get install wkhtmltopdf"
        echo "  - sudo apt-get install texlive-latex-base"
        exit 1
    fi
fi

echo "Successfully converted '$INPUT_FILE' to '$OUTPUT_FILE'"
