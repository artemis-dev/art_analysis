#!/bin/sh 

if [ _$1 = _ ] ; then
    echo "usage: artlogin username"
    return 1
#    exit 1
fi

if [ x$ART_ANALYSIS_DIR = x"" ] ; then
    echo " set environmental value ART_ANALYSIS_DIR"
    return 1
else
    artemis_dir=$ART_ANALYSIS_DIR
fi

if [ x$ART_USER_REPOS = x"" ] ; then
    echo " set environmental value ART_USER_REPOS to point the URL of user source repository"
    return 1
else
    reposdir=${ART_USER_REPOS}
fi    
    
username=$1
userdir=$artemis_dir/user/$username

alias acd="cd ${ARTEMIS_WORKDIR}"

export ARTEMIS_USER=$username
export ARTEMIS_WORKDIR=$userdir

if [ -d $userdir ] ; then
    cd $userdir
    return 0
#    exec zsh
#    exit 0
#    exit 0
elif [ -e $userdir ] ; then
    echo "error: file $userdir exist."
    return 1
#    exit 1
fi

echo "user '$1' not found."

while true; do
    echo -n "create new user? (y/n): "
    read answer
    case $answer in
	y)
	    break
	    ;;
	n)
	    echo "cancelled."
	    return 0
	    ;;
    esac
done

git clone $reposdir $userdir
cd $userdir
git submodule init
git submodule update

git config user.name "$username"

while true; do
    echo -n "input email address: "
    read email
    echo -n "OK? (y/n): "
    read answer
    case $answer in
	y)
	    break
	    ;;
    esac
done

git config user.email "$email"

cat <<EOF

new user '$1' created.
If you want to use some editor other than vi, set core.editor in git configuration.

example: git config core.editor 'emacs -nw'

EOF

#cd $userdir

#exec zsh
