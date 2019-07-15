#!/bin/bash
echo "
fzf_complete_local_commit() {
    _fzf_complete \"--tac\" \"\$*\" < <(
        git log --oneline origin/master..
    )
}"

echo "
fzf_complete_local_commit_post() {
    cut -d ' ' -f 1
}"

echo "
fzf_complete_branch() {
    _fzf_complete \"--tac\" \"\$*\" < <(
         git for-each-ref refs/heads/ --format '%(refname:short)' --sort committerdate
    )
}"

for command in gcf gcs grom
do
    echo "
_fzf_complete_${command}() {
    fzf_complete_local_commit \"\$@\"
}

_fzf_complete_${command}_post() {
    fzf_complete_local_commit_post \"\$@\"
}"
done

for command in gbd gbD gr gro gxh gxk gxm gxs gco glog
do
    echo "
_fzf_complete_$command() {
    fzf_complete_branch \"\$@\"
}"
done
