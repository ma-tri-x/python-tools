if [ $# == 0 ];then
    echo "please give destiny dir"
    exit 1
fi

destDir=$1

if [ ! -d $destDir ];then
    mkdir -p $destDir
fi

cp *.sh $destDir
cp -r 0 $destDir
cp -r system $destDir
cp -r constant $destDir
cp *.template $destDir
cp *.py $destDir
cp *.gnuplot $destDir
cp All* $destDir
cp *.json $destDir
if [ -d states ];then cp -r states $destDir;fi