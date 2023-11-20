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
fi

## How many files.
if [[ $(find $directory -type f -name "*.fa" -o -type f -name "*.fasta"  | wc -l ) -eq 0 ]]; then echo The directory has no fasta files.;
elif [[ $(find $directory -type f -name "*.fa" -o -type f -name "*.fasta" | wc -l) -eq 1 ]]; then echo The directory has 1 fasta file.;
else echo The directory has $(find $directory -type f -name "*.fa" -o -type f -name "*.fasta" | wc -l) fasta files.; fi

## How many unique fasta IDs.
fastaID=0
for file in $(find $directory -type f -name "*.fa" -o -name "*.fasta"); do
fastaID=$(($fastaID+$(awk -F' ' '/>/{print $1}' $file | sort | uniq | wc -l))2>fastacan.err) # We redirect this error to a file because we want a clean output, most of times will be because a file is not readable, we'll let the user know later.
done

echo There are $fastaID unique fasta IDs.


## Files:
### Header: filename, symlink?, sequences, total seq length (no gaps), extra: aa/nt seq.

#### We iterate in each file of the directory.
for f in $(find $directory -type f -name "*.fa" -o -name "*.fasta"); do

##### We'll let the user know if a file is not readable, just in case.
if [[ ! -r $f ]]; then echo === $(basename $f) not readable file! && continue; fi #We used basename command in PGB that's why I know it!


#### Creation of the header
header="==="

#### filename
header=$header" "$(basename $f)

#### is it a symlink? 
if [[ -h $f ]]; then header=$header" ""symlink"; fi

#### sequences: by counting how many fasta headers there are.
header=$header" "$(grep -c ">" < $f)"seqs"

#### sequence length without gaps
n=0
header=$header" "$(awk '!/>/{gsub(/-/, "", $0); n=n+length($0)}END{print n}' $f)


#### amino acid sequence or nucleotide sequence? If the sequence hast any character that is not a nucleotide (A, C, T, G) then it will be determined as an aminoacidic sequence.
if [[ $(awk '!/>/{gsub(/-/, "", $0); print $0}' $f | grep -vi ^[A,C,T,G]) ]]; then header=$header" aminoacid_sequence"; else header=$header" nucleotide_sequence"; fi


#### Echo the header before the content.
echo $header

### Content: If line <= 2N; full content, if not N head, ... and N tail. If 0 skip.

if [[ $N -eq 0 ]]; then continue;

elif [[ $((2 * $N)) -gt $(wc -l < $f) ]];
then cat $f;

elif [[ $((2 * $N)) -le $(wc -l < $f) ]];
then head -n $N $f;
echo ...;
tail -n $N $f;
echo ; # This echo is just to make a line jump between different files.
fi

done
