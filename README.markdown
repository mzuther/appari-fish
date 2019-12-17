# Appari-Fish

## Bookmarks for the fish shell with comprehensive tab completion

Appari-Fish is a fish-shell port of apparix (and apparish).  For your
convenience, they all use the same commands and resource files.

## Installation

Open the fish shell, run `fisher add mzuther/appari-fish` and create
the necessary resource files by running `apparish-init`.

## Documentation

Use the command `apparish-help` to display this documentation.

Enter a directory and call `bm foo`.  From now on, you can go to that
directory by issuing `to foo`.  Appari-Fish uses the most recent mark
if identical bookmarks exist.  Thus, you could use a generic bookmark
such as `now` for targets that change often.  Also, check out `to -`!

I recommend you try the tab completion.  To use the editing commands,
set the shell variable `$EDITOR` to your favourite editor.

Thanks to Stijn van Dongen, Sitaram Chamarty and Izaak van Dongen for
coming up with apparix (https://micans.org/apparix/).  Enjoy!
  
## Commands

    apparish-help            Display help for Appari-Fish
    apparish-init            Create resource files for Appari-Fish
    apparish-version         Display license and version for Appari-Fish

---------------------------------------------------------------------

    bm MARK                  Bookmark current directory as MARK
    portal                   Bookmark subdirectories of current directory
    portal-expand            Manually re-expand all portals

---------------------------------------------------------------------

    to MARK [SUBDIR]         Jump to MARK (and enter SUBDIR directory)
    whence MARK              Jump to multiple-target MARK using a menu

---------------------------------------------------------------------

    ald MARK [SUBDIR]        List subdirectories of MARK or its SUBDIR
    als MARK [SUBDIR]        List contents of MARK or its SUBDIR
    amibm                    Test whether current directory is bookmarked
    apparish-list MARK       List all targets for MARK
    bmgrep PATTERN           List all marks where target matches PATTERN

---------------------------------------------------------------------

    ae MARK [SUBDIR/]FILE    Edit FILE in MARK or its SUBDIR
    aget MARK [SUBDIR/]FILE  Copy FILE from MARK or its SUBDIR
    amd MARK SUBDIR          Create directory SUBDIR in MARK
    av MARK [SUBDIR/]FILE    View FILE in MARK or its SUBDIR
    rme MARK [SUBDIR]        Edit README file in MARK or its SUBDIR
    todo MARK [SUBDIR]       Edit TODO file in MARK or its SUBDIR

## Code of conduct

Please read the [code of conduct][COC] before asking for help, filing
bug reports or contributing to this project.  Thanks!

## License

Copyright (c) 2019 [Martin Zuther][]

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Thank you for using free software!


[Martin Zuther]:  http://www.mzuther.de/
[COC]:            https://github.com/mzuther/appari-fish/tree/master/CODE_OF_CONDUCT.markdown
