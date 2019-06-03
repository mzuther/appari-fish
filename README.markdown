# Appari-Fish

## Bookmarks for the fish shell with comprehensive tab completion

Appari-Fish is a fish-shell port of apparix (and apparish).  For your
convenience, they all use the same commands and resource files.

To install, open the fish shell, run `fisher add mzuther/appari-fish`
and create the necessary resource files by running `apparish-init`.

Then go to a directory and call `bm foo`.  From now on, you can go to
that directory by issuing `to foo`.  Appari-Fish uses the most recent
mark if identical bookmarks exist.  Thus, you may use a bookmark such
as `now` for a target that changes often.  Also, check out `to -`!

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
