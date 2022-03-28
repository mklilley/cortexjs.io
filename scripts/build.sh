#!/bin/bash

set -e  # exit immediately on error
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
# set -x    # for debuging, trace what is being executed.

cd "$(dirname "$0")/.."

export BASENAME="\033[40m Cortexjs.io \033[0;0m " # `basename "$0"`

export DOT="\033[32m 羽 \033[0;0m" # Hourglass
export CHECK="\033[32m ✔ \033[0;0m"
export LINECLEAR="\033[1G\033[2K" # position to column 1; erase whole line
export ERROR="\033[31;7m ERROR \033[0;0m"

# Read the first argument, set it to "dev" if not set
ENVIRONMENT="${1-dev}"

# Remove the CNAME file, which is used
# to indicate if this is a production or development build
[ -f "./submodules/cortex-js.github.io/CNAME" ] && rm "./submodules/cortex-js.github.io/CNAME"

mkdir -p ./build
mkdir -p ./src/build

## Copy submodules
printf "$BASENAME$DOT Copying submodules"
mkdir -p ./submodules/cortex-js.github.io/assets/js/
cp ./submodules/code-playground/dist/code-playground.min.js ./submodules/cortex-js.github.io/assets/js/code-playground.min.js
echo -e "$LINECLEAR$BASENAME$CHECK Submodules copied"


## Grok (.d.ts -> .html with frontmatter)
# Uses grok.config.js for additional config option

echo -e "$BASENAME$DOT Groking mathlive"
cd ../mathlive
#npx grok build ./src/mathlive.ts --config ../cortexjs.io/grok.config.js --sdkName mathlive --outDir ../cortexjs.io/src/build/ --outFile mathlive.html --modules mathfield-element options mathlive mathfield commands core
cd ../cortexjs.io/

# echo -e "$BASENAME$DOT Groking MathJSON"
# npx grok  ./submodules/compute-engine/src/latex-syntax/public.ts --sdkName math-json --outDir ./src/build/ --outFile math-json.html

echo -e "$BASENAME$DOT Groking Compute Engine"
cd ../compute-engine/
#npx grok build ./src/compute-engine.ts --config ../cortexjs.io/grok.config.js --sdkName compute-engine --outDir ../cortexjs.io/src/build/ --outFile compute-engine.html
cd ../cortexjs.io/

echo -e "$BASENAME$CHECK Groked"

# Copy the ChangeLog
mkdir -p ./src/build/compute-engine/
cp ./src/_data/_compute-engine-changelog.md ./src/build/compute-engine/changelog.md
cat ./submodules/compute-engine/CHANGELOG.md >> ./src/build/compute-engine/changeLog.md


## Build the guides from the source directories
echo -e "$BASENAME$DOT Building guides"
node ./scripts/build-guides.js  "./submodules/compute-engine/src/" ""
echo -e "$BASENAME$CHECK Guides built"

## Build (.md -> .html)
# DEBUG=Eleventy* npx eleventy --config ./config/eleventy.js
if [ "$ENVIRONMENT" != "watch" ]
then
    # In watch mode, no need to do a build, the watch call will do it later.
    echo -e "$BASENAME$DOT Building static site with eleventy"
    npx eleventy --config ./config/eleventy.js
    echo -e "$BASENAME$CHECK Static site built"
fi

if [ "$ENVIRONMENT" == "production" ]
then
    printf "$BASENAME$DOT Making a production build"
    sync
    # npx html-minifier-terser \
    #     --config-file "./config/html-minifier.json" \
    #     --file-ext html \
    #     --input-dir "./submodules/cortex-js.github.io/" \
    #     --output-dir "./submodules/cortex-js.github.io/"
    postcss --config "./config" --replace "./submodules/cortex-js.github.io/**/*.css"
    echo -e "$LINECLEAR$BASENAME$CHECK Completed build"

fi
