# NERDtree: Cut/copy/paste files and directories

This plugin adds cut/copy/paste to NERDTree.

## Installation

Copy the plugin file to your `.vim/plugin` directory, or install via Pathogen/Vundle.

## Usage

In NERDtree, select the file or folder that you want to cut or copy and press `mx` for cutting or `mxx` for copying,
followed by <Enter>.
(sadly, `mc` for "copy" was already taken :'( ).

Navigate to the target folder where you want to paste the item and press `mp`. If the filename already exists,
the plugin will prompt to replace it.
