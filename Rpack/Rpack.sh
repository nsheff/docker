# Given a path/to/Rpackage, build and check the R package.
# This first roxygenizes the package to ensure docs are up-to-date,
# Then runs R CMD check
# Finally runs R CMD BiocCheck
# You can optionally give a second parameter:
# "bio" to skip R check, or
# "cran" skip R BiocCheck

roxygenize.sh -i $1

# R --no-save <<END
# devtools::install_deps("$1");
# END

a=$(R CMD build $1)
echo "Building..."
echo "$a"

# Get the name of the built tarball
regex="building '(.*)'"
regex="building ‘(.*)’"
[[ $a =~ $regex ]]
name="${BASH_REMATCH[1]}"

echo "Built tarball: $name"

if [  "$2" != "bio" ]; then
echo "R CMD check $name..."
R CMD check --as-cran $name
fi
if [  "$2" != "cran" ]; then
echo "R CMD BiocCheck $name..."
R CMD BiocCheck $name
fi
