
git branch --list
git branch --list -a

git branch gh-pages
git checkout gh-pages

# rm *

echo "<h1>This is index.html</h1>" > index.html

git add index.html
git commit -a -m "happy new year"

git push --set-upstream origin gh-pages
git push

# git checkout main
# git branch -d gh-pages