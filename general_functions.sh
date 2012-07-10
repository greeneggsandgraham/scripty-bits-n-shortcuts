#!/bin/bash

function bind-U {
    pushd . >> /dev/null
    cd ../
}

function bind-F {
    popd >> /dev/null
}

function ls-type {
    read -n 1 -s _type
    ls_cmd='ls -glhBAF --ignore=#* --ignore=.svn --color=always'
    case $_type in
	"h" )
	    ;;
	"t" ) # sort by modification time
	    ls_cmd="$ls_cmd -t"
	    ;;
	"s" ) # sort by file size
	    ls_cmd="$ls_cmd -S"
	    ;;
	*)
	    ls_cmd="ls --color=always"
	    ;;
    esac
    $ls_cmd
}

function vte-echo {
    echo $1 | cat -vte
}

function do-git {
    local GIT_BIN="/usr/bin/git"

    local dir='.'
    if [[ "$1" ]]; then
	dir=$1
    fi
    local _type
    read -n 1 -s _type
    
    case $_type in
	"d" )
	    CMD="$GIT_BIN diff"
	    ;;
	"c" )
	    CMD="$GIT_BIN commit"
	    ;;
	"u" )
	    CMD="$GIT_BIN pull"
	    ;;
	"s" )
	    CMD="$GIT_BIN status"
	    ;;
	"r" )
	    CMD="$GIT_BIN checkout"
	    ;;
	*)
	    do-git s
	    return 0
	    ;;
    esac

    $CMD $dir
}

function do-svn {
    local dir='.'
    svn_st_arr=''
    if [[ "$1" ]]; then
	dir="$1"
    fi
    local svn_cmd='svn'
    local _type
    read -n 1 -s _type
    case $_type in
	"d" )
	    svn_cmd="$svn_cmd diff -x -w"
	    ;;
	"c" )
	    svn_cmd="$svn_cmd ci"
	    ;;
	"u" )
	    svn_cmd="$svn_cmd up"
	    ;;
	"s" )
	    svn_cmd="$svn_cmd st"
	    ;;
	"r" )
	    svn_cmd="$svn_cmd revert -R "
	    ;;
	"i" )
	    svn_cmd="$svn_cmd info"
	    ;;
	"t" ) 
	    tar-local-mods
	    return
	    ;;
	    
	"&")
	    IFS=$
	    stat=`svn st`
	    count=0;
	    for entry in `echo $stat | cat -vte`
	    do
		svn_st_arr[$count]=$entry
		count=$(($count+1))
	    done
	    for elem_key in ${!svn_st_arr[@]}
	    do
		echo -n "$elem_key "
		echo ${svn_st_arr[$elem_key]} | grep -oP ".*$"
	    done
	    echo -e "\nWhich file: "
	    read _file_number
	    local dir_line=${svn_st_arr[$_file_number]}
	    dir=`echo $dir_line | grep -oP "(?<=\s)[^\s].*$"`
	    echo $dir
	    unset IFS
	    do-svn "$dir"
	    return
	    ;;
	* )
	    svn_cmd="$svn_cmd st"
    esac
    svn_cmd="$svn_cmd $dir"
    echo $svn_cmd
    if [[ $_type == "r" ]]; then
	svn st $dir
	echo -e "\nYou sure you wanna revert everything?"
	read -n 1 _you_sure
	if [[ $_you_sure == "y" ]]; then
	    $svn_cmd
	else
	    echo -e "\ndirtnapping\n"
	    return
	fi
    else
	$svn_cmd
    fi
}

function psgrep {
    for pid in `pgrep java`;
    do
	echo `ps $pid`
	echo ""
    done
}

function ip-address {
    ifconfig | grep -oP -m 1 "(?<=inet addr:)[\w\.]*"
}

function make-local-mod-tarball-name {
    local svn_info=$(svn info | grep -oP "URL:\shttp.*" | sed "s@URL:\s\w*://@@g" | sed "s@/@-@g");
    local revision=$(svn info | grep -oP "(?<=Revision:\s)\d*")
    local timestamp=$(date +%s)
    local separator=__
    LOCAL_MOD_TARBALL_NAME=$(whoami)_$(hostname)${separator}mods${separator}${svn_info}${separator}r${revision}${separator}${timestamp}.tar
}

function tar-local-mods {   
    set +e
    make-local-mod-tarball-name
    local tarball_name=$LOCAL_MOD_TARBALL_NAME
    local args="$*"

    for arg in $args; do
	if [[ `echo $arg | grep -oP "\.tar$"` ]]; then
	    tarball_name=$arg
	fi
    done
    
    local svn_st=$(svn st)    
    local retval=$?
    if [ 0 -ne $retval ]; then	
	echo "Exiting: svn st returned code of ${retval}"
	return $retval
    else	
	local all_files=$(svn st | grep -oP "(?<=\s)\w.*\.*$")
	local previous_tarball_pattern="$(whoami)_$(hostname)__[^\s]*\d+\.tar"	    
	local files=""

	if [[ ! $all_files ]]; then
	    echo "No local mods found."
	    return 0
	fi
	for file in $all_files; do
	    if [[ ! `echo $file | grep -oP "$previous_tarball_pattern"` ]]; then
		files="$files $file"
	    fi
	done

	local tar_cmd="tar -cvf $tarball_name $files"
	echo $tar_cmd

	$tar_cmd

	
    fi
    set -e
}

function variable-variable {
    # similar to php's variable-variable
    # In php, assume: $dogman = 'woof'; $animal = 'dogman'; then $$animal == 'woof';
    # Here, DOGMAN='woof'; ANIMAL='DOGMAN'; variable-variable $ANIMAL # 'woof'
    tmp=\$"$1"
    echo `eval "expr \"$tmp\""`
}

function email-local-mods {
    bash $BASH_FILE_DIR/email-local-mods "$*"
    return 0
}