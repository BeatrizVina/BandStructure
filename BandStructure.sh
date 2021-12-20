#!/bin/bash  

NBands=`grep NBANDS OUTCAR | awk '{print $15}'` 
NKPoints=`grep NKPTS OUTCAR | awk '{print $4}'`
grep "band No." -B 1 OUTCAR | awk '{print $4,$5,$6}' >k-points.txt
sed -i "/\b\(occupation\)\b/d" k-points.txt 
sed -i '/^[[:space:]]*$/d' k-points.txt
grep "band No." -A $(($NBands+1)) OUTCAR | awk '{print $2}'  >energies.txt 
sed -i "/\b\(No\)\b/d" energies.txt
sed -i '/^$/d' energies.txt
sed -i '/^[[:space:]]*$/d' energies.txt
split -a 3 -d -l $NBands energies.txt k-energies.
for nu in `seq 1 $NKPoints`
do
let nud=nu-1; eid=`printf "%03u" $nud`
paste -s -d " " k-energies.$eid > k-energies-row.$eid
done
cat k-energies-row* > energies-def.txt
paste -d " "  k-points.txt energies-def.txt >bands.txt
awk '{print $1,$2,$3}' bands.txt > bandkpoints.txt
awk '{$1=$2=$3=""; print $0}' bands.txt > bandenergies.txt
mkdir temp
mv k-* energies* temp
rm -r temp
