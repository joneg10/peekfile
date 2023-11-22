# MIDTERM ASSIGNMENT
## Prepare the optional arguments
directory=$1 # Folder
N=$2 # Number of lines

## Define the default arguments.
if [[ -z $directory ]]; then directory='.'; fi
if [[ -z $N ]]; then N=0; fi

## How many files? Depending on the number of files (one, multiple or none) the sentence explaining it changes.
if [[ $(find $directory -type f,l -name "*.fa" -o -type f,l -name "*.fasta"  | wc -l ) -eq 0 ]]; then echo The directory has no fasta files.;

elif [[ $(find $directory -type f,l -name "*.fa" -o -type f,l -name "*.fasta" | wc -l) -eq 1 ]]; then echo The directory has 1 fasta file.;

else echo The directory has $(find $directory -type f,l -name "*.fa" -o -type f,l -name "*.fasta" | wc -l) fasta files.; fi

## How many unique fasta IDs.
### Iterate in each file and each line of the file: Take the field with the ID (first word) and count each unique ID:
echo There are $(awk -F' ' '/>/{print $1}' $(find $directory -type f,l -name "*.fa" -o -type f,l -name "*.fasta") | sort | uniq | wc -l) unique fasta IDs.

## Files:
### Header: filename, symlink?, sequences, total seq length (no gaps), extra: aa/nt seq.

#### Iterate in each file of the directory.
for f in $(find $directory -type f,l -name "*.fa" -o -name "*.fasta"); do

##### We'll let the user know if a file is not readable, just in case, even if the terminal will show an error for previous steps like counting fasta IDs.
if [[ ! -r $f ]]; then echo; echo === $f non readable file! && continue; fi

#### Creation of the header
header="=== "

#### Filename: complete just from the folder we are working on, because it will iterate also in subfolders and it's nice to see where the file is stored.
header=$header$f

#### is it a symlink?
if [[ -h $f ]]; then header=$header" ""Symbolic Link"; fi

#### sequences: by counting how many fasta headers (start with >) there are.
header=$header" | Sequences: "$(grep -c ">" < $f)

#### sequence length without gaps
n=0 # Create a counter that will start in 0 each time we iterate in a different folder.
header=$header" | Length: "$(awk '!/>/{gsub(/-/, "", $0);n=n+length($0)}END{print n}' $f)
# gsub will replace the gaps with nothing in each line except the header lines.
# The counter (n) will sum each line's length and at the end of the iteration of the lines it will print the total.

#### amino acid sequence or nucleotide sequence? If the sequence hast any character that is not a nucleotide (A, C, T, G, U – in case it's RNA –, N – indetermination) then it will be determined as an aminoacidic sequence. [^ACTGUN] will grep any character except the characters inside [].
if [[ $(awk '!/>/{gsub(/-/, "", $0); print $0}' $f | grep -i [^ACTGUN]) ]]; then header=$header" | Aminoacid Sequence"; else header=$header" | Nucleotide Sequence"; fi



#### Echo the header before the content.
echo # This echo is just to make a line jump between different files.
echo $header

### Content: If line <= 2N; full content; if not N head, ... and N tail. If 0 skip.
if [[ $N -eq 0 ]]; then continue;

elif [[ $((2 * $N)) -gt $(wc -l < $f) ]];
then cat $f;

elif [[ $((2 * $N)) -le $(wc -l < $f) ]];
then head -n $N $f;
echo ...;
tail -n $N $f;
fi

done