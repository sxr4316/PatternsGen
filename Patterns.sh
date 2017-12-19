#!/bin/bash

NWpattern="/prj/vlsi/pete/napali/eng/ForIntegDoNotUse/";

Generate="Generated/";

# Reset Patterns Dircectory if required
if [ "$1" == "reset" ] || [ ! -d "$Generate" ];
	then
		if [ -d "$Generate" ] ;
			then
				rm -rf "$Generate"
		fi
	mkdir $Generate
fi

cd $Generate

# Create hierarchical folder structure of the Patterns
for fold in $(find $NWpattern -mindepth 1 -maxdepth 1 -type d);
	do
		temp=${fold#${NWpattern}};
		if [ ! -d "$temp" ] ;
			then
				mkdir $temp
	
		fi
done

# Create hierarchical folder structure of the Patterns
for fold in $(find $NWpattern -mindepth 2 -maxdepth 2 -type d);
	do
			if [ ! -d ${fold#${NWpattern}} ] && [ ! -L ${fold#${NWpattern}} ] ;
				then
					ln -s $fold ${fold#${NWpattern}}
			fi
	done
cd ..

if [ "$1" == "get" ] ;
	then
		if [ "$2" == "" ];
			then
				echo "Missing Link to folder, to be fetched"
		else
			inplink=$2

			if [[ "$2" =~ ^.*/$ ]];
				then
					reflink=${2: : -1}
			else
				reflink=$2
			fi

			if [ $(find $reflink -type l) ];
				then
					fldrpath="$(readlink $reflink)"
					rm -rf  $reflink
					cp -prf $fldrpath $reflink
			else
				echo "Folder already fetched"
			fi
		fi
fi 		

if [ "$1" == "status" ] ;
	then
		if [ -z `find "$Generate" -mindepth 2 -maxdepth 2 -type d -print -quit` ] ;
			then
				echo "No patterns in debug area which have to be updated"
		else
			num=0;
			echo "Following Folders have been fetched for debug"
			for fold in $(find "$Generate" -mindepth 2 -maxdepth 2 -type d)
				do
					num=$(( num + 1 ));
					echo  "$num : $fold"

			done
		fi
fi

if [ "$1" == "put" ] ;
	then
		if [ -z `find "$Generate" -mindepth 2 -maxdepth 2 -type d -print -quit` ] ;
			then
				echo "No patterns in debug area which have to be updated"
		else
			num=0;
			for fold in $(find "$Generate" -mindepth 2 -maxdepth 2 -type d)
				do
					num=$(( num + 1 ));
					src=$fold
					dest=$NWpattern${fold#${Generate}}"/../"
					\cp -urf $src $dest
#					\rm -rf $src
#					\ln -s  $dest $src
					echo  "$num : $src transferred"
			done
		fi
fi

if [ "$1" == "hardput" ] ;
	then
		if [ ! $(find "$Generate" -mindepth 2 -maxdepth 2 -type d) ];
			then
				echo "No patterns in debug area which have to be updated"
		else
			num=0;
			for fold in $(find "$Generate" -mindepth 2 -maxdepth 2 -type d)
				do
					num=$(( num + 1 ));
					src=$fold
					dest=$NWpattern${fold#${Generate}}
					\rm -rf $dest
					\cp -urf $src $NWpattern${fold#${Generate}}
#					rm -rf $fold
#					ln -s  ${fold#${Generate}} $fold
					echo  "$fold transferred"
			done
		fi
fi
