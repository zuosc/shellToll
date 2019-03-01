cd tmp
git clone --bare http://git.xxx.com/yyy/%1

cd %1.git

git push --mirror https://git.xxx.com/yyy/%1
