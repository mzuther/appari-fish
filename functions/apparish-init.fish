#!/usr/bin/fish

# Appari-Fish
# ===========
# Bookmarks for the fish shell with comprehensive tab completion
#
# Copyright (c) 2019 Martin Zuther (http://www.mzuther.de/)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Thank you for using free software!


set APPARIXVERSION 1.0
set -q APPARIXHOME; or set APPARIXHOME $HOME

set APPARIXRC     $APPARIXHOME/.apparixrc
set APPARIXEXPAND $APPARIXHOME/.apparixexpand
set APPARIXLOG    $APPARIXHOME/.apparixlog


# ------------------------------------------------------------------------------


function apparish -d "Bookmarks for the fish shell"
    # display all bookmarks and portals
    if test (count $argv) -eq 0
        cat $APPARIXRC $APPARIXEXPAND | tr ", " "\t_" | column -t
        return
    end

    # query bookmark
    set mark "$argv[1]"
    set list (grep -F ",$mark," $APPARIXRC $APPARIXEXPAND)

    # if several bookmarks with the same name exist, select the first
    set list $list[1]

    if test -z "$list"
        echo "Mark \"$mark\" not found." >&2
        return 1
    end

    # extract path the selected bookmark points to
    set target (echo $list | tail -n 1 | cut -f 3 -d ",")

    # display selected path (and file or subdirectory)
    if test (count $argv) -eq 1
        echo $target
    else
        set filename "$argv[2]"
        echo $target/$filename
    end
end


# ------------------------------------------------------------------------------


function bm -d "Bookmark current directory as MARK"
    if test (count $argv) -eq 0
        echo "Need mark." >&2
        return 1
    end

    set mark "$argv[1]"
    set old_list (apparish-list $mark)
    set old_list_size (count $old_list)

    # append bookmark to $APPARIXRC
    echo "j,$mark,$PWD" | tee -a $APPARIXLOG >> $APPARIXRC

    # display existing bookmarks with the same mark
    if test $old_list_size -gt 0
        set old_entries_to_show 2

        if test $old_list_size -gt 0
            echo "Bookmark \"$mark\" exists ($old_list_size total):"

            if test $old_list_size -gt $old_entries_to_show
                echo "(...)"
            end

            string join \n $old_list | tail -n $old_entries_to_show
        end
    end

    # display new bookmark
    echo "$PWD (added)"
end



function portal -d "Bookmark subdirectories of current directory"
    if test (count $argv) -ne 0
        echo "This function doesn't take any arguments." >&2
        return 1
    end

    echo "e,$PWD" | tee -a $APPARIXLOG >> $APPARIXRC
    portal-expand
end



function portal-expand -d "Manually re-expand all portals"
    # empty file $APPARIXEXPAND
    rm -f $APPARIXEXPAND
    touch $APPARIXEXPAND

    # extract all portals
    for parentdir in (grep "^e," $APPARIXRC | cut -f 2 -d ,)
        # add all subdirectories in portal as bookmarks
        for subdir in (find $parentdir -mindepth 1 -maxdepth 1 -type d -printf %f\n | sort)
            echo "j,$subdir,$parentdir/$subdir" >> $APPARIXEXPAND
        end
    end
end


# ------------------------------------------------------------------------------


function to -d "Jump to MARK (and enter SUBDIR directory)"
    if test "$argv[1]" = "-"
        set location "-"
    else
        set location (__apparish_get_location $argv)

        if test $status -ne 0
            return 1
        end
    end

    cd $location
end



function whence -d "Jump to multiple-target MARK using a menu"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    # collect and sort relevant bookmarks
    set bookmarks (apparish-list $argv[1] | sort -uV)

    # jump immediately if there's only one possible target
    if test (count $bookmarks) -eq 1
        echo "Only one target.  Jumping..." >&2
        cd $bookmarks[1]
        return 0
    end

    # build menu
    for listid in (seq (count $bookmarks))
        set_color blue
        echo -n $listid
        set_color normal
        echo ") $bookmarks[$listid]"
    end

    # select menu entry
    set PROMPT_CMD "echo; set_color blue; echo -n \"#? \"; set_color normal"
    if test (count $bookmarks) -lt 10
        read -n 1 -p $PROMPT_CMD selected
    else
        read -p $PROMPT_CMD selected
    end

    cd $bookmarks[$selected]
end


# ------------------------------------------------------------------------------


function ald -d "List subdirectories of MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    ls -d $location/*
end



function als -d "List contents of MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    ls $location
end



function amibm -d "Test whether current directory is bookmarked"
    if test (count $argv) -ne 0
        echo "This function doesn't take any arguments." >&2
        return 1
    end

    grep ",$PWD\$" $APPARIXRC | cut -f 2 -d ","
end



function apparish-list -d "List all targets for MARK"
    if test (count $argv) -eq 0
        echo "Need mark." >&2
        return 1
    end

    set mark "$argv[1]"
    grep -F ",$mark," $APPARIXRC $APPARIXEXPAND | cut -f 3 -d ","
end



function bmgrep -d "List all marks where target matches PATTERN"
    if test (count $argv) -eq 0
        echo "Need a PATTERN to search." >&2
        return 1
    end

    set pattern "$argv[1]"
    egrep $pattern $APPARIXRC | cut -f 2,3 -d "," | tr "," "\t" | column -t
end


# ------------------------------------------------------------------------------


function ae -d "Edit FILE in MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    $EDITOR $location
end



function aget -d "Copy FILE from MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    else if test -z "$argv[2]" -o ! -f "$argv[2]"
        echo "Need a FILE to copy." >&2
        return 1
    end

    cp $location .
end



function amd -d "Create directory SUBDIR in MARK"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    mkdir -p $location
end



function av -d "View FILE in MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    view $location
end



function rme -d "Edit README file in MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    $EDITOR $location/README
end



function todo -d "Edit TODO file in MARK or its SUBDIR"
    set location (__apparish_get_location $argv)

    if test $status -ne 0
        return 1
    end

    $EDITOR $location/TODO
end


# ------------------------------------------------------------------------------


function apparish-init -d "Create resource files for Appari-Fish"
    if test -f $APPARIXRC -a -f $APPARIXEXPAND
        echo "Appari-Fish is already installed."
    else
        test -f $APPARIXRC; or touch $APPARIXRC
        test -f $APPARIXEXPAND; or touch $APPARIXEXPAND

        echo "Appari-Fish is up and running."
    end
end



function apparish-help -d "Display help for Appari-Fish"
    set_color -o red
    echo '
                     A  P  P  A  R  I  -  F  I  S  H'

    set_color normal
    set_color yellow
    echo '
                    Bookmarks for the fish shell with
                      comprehensive tab completion'

    set_color normal
    echo '

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
  '

    __apparish_display_separator

    __apparish_display_usage "apparish-help"
    __apparish_display_usage "apparish-init"
    __apparish_display_usage "apparish-version"

    __apparish_display_separator

    __apparish_display_usage "bm MARK"
    __apparish_display_usage "portal"
    __apparish_display_usage "portal-expand"

    __apparish_display_separator

    __apparish_display_usage "to MARK [SUBDIR]"
    __apparish_display_usage "whence MARK"

    __apparish_display_separator

    __apparish_display_usage "ald MARK [SUBDIR]"
    __apparish_display_usage "als MARK [SUBDIR]"
    __apparish_display_usage "amibm"
    __apparish_display_usage "apparish-list MARK"
    __apparish_display_usage "bmgrep PATTERN"

    __apparish_display_separator

    __apparish_display_usage "ae MARK [SUBDIR/]FILE"
    __apparish_display_usage "aget MARK [SUBDIR/]FILE"
    __apparish_display_usage "amd MARK SUBDIR"
    __apparish_display_usage "av MARK [SUBDIR/]FILE"
    __apparish_display_usage "rme MARK [SUBDIR]"
    __apparish_display_usage "todo MARK [SUBDIR]"

    echo
end



function apparish-version -d "Display license and version for Appari-Fish"
    set_color -o red
    echo '
                     A  P  P  A  R  I  -  F  I  S  H'

    set_color normal
    set_color yellow
    echo '
                    Bookmarks for the fish shell with
                      comprehensive tab completion'

    set_color normal
    set_color -o
    echo "

  Copyright (c) 2019 Martin Zuther (http://www.mzuther.de/)"

    set_color normal
    echo "
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>."

    set_color -o
    echo "
  Thank you for using free software!
  "
    set_color normal
end


# ------------------------------------------------------------------------------


function __apparish_get_location
    set number_of_arguments (count $argv)
    set mark "$argv[1]"
    set subdir "$argv[2]"

    switch $number_of_arguments
        case 0
            echo "Need mark." >&2
            false # set error flag
        case 1
            set location (apparish $mark)
        case 2
            set location (apparish $mark $subdir)
        case "*"
            echo "Too many arguments." >&2
            false # set error flag
    end

    if test $status -ne 0
        return 1
    end

    echo $location
end


# ------------------------------------------------------------------------------


function __apparish_complete -d "Complete bookmarks and paths for Appari-Fish"
    set suffix "$argv[1]"
    set number_of_finished_commands "$argv[2]"

    switch $number_of_finished_commands
        case 1
            cat $APPARIXRC $APPARIXEXPAND | grep '^j,' | cut -d ',' -f2 -s
        case 2
            set command_line (commandline -bo)
            set mark "$command_line[2]"
            set subdir "$command_line[3]"

            __fish_complete_suffix $subdir $suffix "" (apparish $mark)
        case "*"
            return 1
    end
end



function __apparish_complete_mark -d "Complete bookmarks for Appari-Fish"
    set number_of_finished_commands (count (commandline -pco))

    switch $number_of_finished_commands
        case 1
            __apparish_complete "" $number_of_finished_commands
        case "*"
            return 1
    end
end



function __apparish_complete_mark_file -d "Complete files for Appari-Fish"
    __apparish_complete "" (count (commandline -pco))
end


function __apparish_complete_mark_subdir -d "Complete subdirectories for Appari-Fish"
    __apparish_complete "/" (count (commandline -pco))
end


# ------------------------------------------------------------------------------


function __apparish_display_usage -d "Display usage and description of apparish command"
    set usage "$argv[1]"
    set cmd (string split " " $usage)[1]
    set description (functions -Dv $cmd)[5]

    set_color -o
    printf "  %-25s" $usage
    set_color normal
    printf "%s\n" $description
end



function __apparish_display_separator -d "Display line separator"
    set_color blue
    echo -n "  "
    string repeat -n 69 "-"
    set_color normal
end
