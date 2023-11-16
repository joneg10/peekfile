# MIDTERM ASSIGNMENT
## Prepare the optional arguments
directory=$1 # Folder
N=$2 # Number of lines

## Define the default arguments.
if [[ -z $directory ]]; then directory='.'; fi
if [[ -z $N ]]; then N=0;
### As the second input should be the number of lines, if the argument is not numerical
### it will print a warning message and use the default N.
# elif [[ $N != [0-9] ]]; then echo ERROR: Non numerical value, using default value 0.;
fi ### mejorar!

## How many files.
if [[ $(find $directory -type f -name "*.fa" -o -name "*.fasta"  | wc -l ) -eq 0 ]]; then echo The directory is empty.;
elif [[ $(find $directory -type f -name "*.fa" -o -name "*.fasta" | wc -l) -eq 1 ]]; then echo The directory has 1 file.;
else echo The directory has $(find $directory -type f -name "*.fa" -o -name "*.fasta" | wc -l) files.; fi

## How many unique fasta IDs.


## Files:
### Header: filename, symlink?, sequences, total seq length (no gaps), extra: aa/nt seq?
#### We iterate in each file of the directory.
for f in $(find $directory -type f -name "*.fa" -o -name "*.fasta"); do

#### start of the header
header="==="

#### filename
header=$header" "$f

#### is it a symlink? 
if [[ -h $f ]]; then header=$header" ""symlink"; else header=$header" ""–"; fi

#### sequences
header=$header" "$(grep -c ">" < $f) # what if it's not fasta?¿

#### sequence length without gaps


### Content: If fine <= 2N; full cont, if not N head, ... and N tail. If 0 skip.

echo $header
done

