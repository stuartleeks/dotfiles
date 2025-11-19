# mdpdf - Markdown to PDF Converter

A bash script to convert Markdown files to PDF with styled code blocks.

## Features

- Converts Markdown files to PDF format
- Styled code blocks with syntax highlighting
- GitHub-like styling for better readability
- Support for multiple code languages
- Clean and professional document formatting

## Prerequisites

The script requires one of the following PDF engines:

- **Recommended**: `wkhtmltopdf` for best results with CSS styling
  ```bash
  sudo apt-get install wkhtmltopdf
  ```

- **Alternative**: `pdflatex` (texlive) for syntax-highlighted code blocks
  ```bash
  sudo apt-get install texlive-latex-base texlive-latex-extra
  ```

Both require `pandoc`:
```bash
sudo apt-get install pandoc
```

## Usage

```bash
mdpdf <input.md> [output.pdf]
```

### Examples

Convert a markdown file to PDF (output file auto-named):
```bash
mdpdf document.md
```

Specify custom output filename:
```bash
mdpdf document.md report.pdf
```

## Styling

The script uses a custom CSS template (`template.css`) that provides:

- **Code blocks**: Styled with background color, borders, and padding
- **Syntax highlighting**: Color-coded keywords, strings, comments, etc.
- **Typography**: Clean, readable fonts and spacing
- **Tables**: Professional borders and alternating row colors
- **Headings**: GitHub-style heading formatting
- **Print optimization**: Prevents page breaks in code blocks

## Customization

To customize the styling, edit `aliases/mdpdf/template.css`:

- Adjust code block colors in the `.sourceCode` section
- Modify fonts in the `body` section
- Change colors for syntax elements (keywords, strings, comments, etc.)
- Adjust spacing and padding to your preference

## Code Block Support

The template includes syntax highlighting for:

- Bash/Shell scripts
- Python
- JavaScript/TypeScript
- Go
- Java
- C/C++
- And many more languages supported by Pandoc

## Example

Create a markdown file:

```markdown
# My Document

This is a sample document with a code block:

\`\`\`python
def hello():
    print("Hello, World!")
\`\`\`
```

Convert it to PDF:

```bash
mdpdf my-document.md
```

This creates `my-document.pdf` with properly styled code blocks.
