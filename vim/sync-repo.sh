#!/bin/sh
git_clone() {
  url=$1
  shift
  repo=`basename $url`
  echo "Checking $repo..."
  if [ -d "$repo" ]; then
    (cd "$repo" && git pull)
  else
    git clone --depth 1 $@ $url
  fi
}

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle

git_clone https://github.com/tpope/vim-pathogen
git_clone https://github.com/scrooloose/nerdtree
git_clone https://github.com/scrooloose/nerdcommenter
git_clone https://github.com/majutsushi/tagbar
git_clone https://github.com/fatih/vim-go
git_clone https://github.com/airblade/vim-gitgutter
git_clone https://github.com/davidhalter/jedi-vim --recursive 
