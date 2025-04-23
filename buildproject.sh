#!/bin/bash
###############################################################################
# buildproject.sh constructs a new project folder properly organized to maximize
# research efficiency by removing a lot of the time spent finding things. This
# script also automates the population of necessary auxiliary files into the
# project directories.
#
# CLI Input Arguments:  project_type ("applications"/"development")
#                       project_name ([some descriptive name with no spaces])
#
# Written By:           Joseph J. Radler, University of Washington
# Date Written:         04/20/2018
# Date Modified:        04/20/2018
###############################################################################
ptype=$1                                # project_type
pname=$2                                # project_name
db="/Volumes/Data/jjradler_data/Dropbox/Research"
ppath="${db}/${ptype}/${pname}"         # project_path

docfiles_gen () {
    local ptype=$1
    local pname=$2
    local today=`date -u +"%Y-%m-%d"`

    echo "GENERATING DOCUMENTATION FILES FROM TEMPLATES..."

    # COPY OVER THE DOCUMENTATION TEMPLATES
    echo "COPYING OVER DOCUMENTATION TEMPLATES..."
    `cp -v '${db}/Code/homebuilt_tools/scripts/project_automation/documentation_templates/README.md" "${ppath}'`
    `cp -v '${db}/Code/homebuilt_tools/scripts/project_automation/documentation_templates/TODO.md" "${ppath}'`
    `cp -v '${db}/Code/homebuilt_tools/scripts/project_automation/documentation_templates/COLLABORATORS.md" "${ppath}'`
    `cp -v '${db}/Code/homebuilt_tools/scripts/project_automation/documentation_templates/LICENSE" "${ppath}'`



    echo "MODIFYING THE RELEVANT FIELDS IN DOCUMENTATION FILES FOR ${pname}..."
    # MODIFY THE RELEVANT FIELDS IN README.md
    sed -i -e '' "s/#FILENAME/${file}/g" README.md
    sed -i -e '' "s/#PNAME/${pname}/g" README.md
    sed -i -e '' "s/#PTYPE/${ptype}/g" README.md
    sed -i -e '' "s/#DATE/${today}/g" README.md

    # MODIFY THE RELEVANT FIELDS IN TODO.md
    sed -i -e '' "s/#FILENAME/${file}/g" TODO.md
    sed -i -e '' "s/#PNAME/${pname}/g" TODO.md
    sed -i -e '' "s/#PTYPE/${ptype}/g" TODO.md
    sed -i -e '' "s/#DATE/${today}/g" TODO.md

    # MODIFY THE RELEVANT FIELDS IN COLLABORATORS.md
    sed -i -e '' "s/#FILENAME/${file}/g" ${ppath}/admin/COLLABORATORS.md
    sed -i -e '' "s/#PNAME/${pname}/g" ${ppath}/admin/COLLABORATORS.md
    sed -i -e '' "s/#PTYPE/${ptype}/g" ${ppath}/admin/COLLABORATORS.md
    sed -i -e '' "s/#DATE/${today}/g" ${ppath}/admin/COLLABORATORS.md
}

pubdir_gen () {
    # ONLY OPERATES USING GLOBAL VARIABLES
    echo "GENERATING PUBLICATION WRITING DIRECTORIES AND FILES..."

    # CREATE APPROPRIATE DIRECTORIES
    mkdir "${ppath}/pubs"
    mkdir "${ppath}/pubs/drafts/${pname}_v1"
    mkdir "${ppath}/pubs/final/${pname}_final"

    # POPULATE LATEX DIRECTORIES WITH ACS TEMPLATE FILES
    echo "POPULATING THE LATEX DIRECTORIES WITH TEMPLATES..."
    cp -rv "${db}/research/TeX_templates/acs_template" "${ppath}/pubs/drafts/"
    mv -v "${ppath}/pubs/drafts/acs_template" "${ppath}/pubs/drafts/${pname}_v1"
    mv -v "${ppath}/pubs/drafts/${pname}_v1/project.*" "${ppath}/pubs/drafts/${pname}_v1/${pname}_v1.*"
    touch "${ppath}/pubs/drafts/${pname}_v1/${pname}.bib"
}

# MAKE THE DIRECTORIES AND SUBDIRECTORIES FOR THE PROJECT
if [ "$ptype" = "applications" ]; then
    # CREATE TREE ROOT DIRS
    echo "CREATING THE ROOT DIRECTORY FOR ${pname}"
    mkdir "${db}/${ptype}/${pname}"

    mkdir "${ppath}/admin"
    mkdir "${ppath}/analysis"
    mkdir "${ppath}/archive"

    # CALCULATION JOBS DIRECTORIES
    mkdir "${ppath}/jobs"
    mkdir "${ppath}/jobs/input"
    mkdir "${ppath}/jobs/output"
    mkdir "${ppath}/jobs/run"

    # DATA SUBDIRECTORIES
    mkdir "${ppath}/data"
    mkdir "${ppath}/data/geom"
    mkdir "${ppath}/data/energy"
    mkdir "${ppath}/data/traj"
    mkdir "${ppath}/data/vib"
    mkdir "${ppath}/data/coupling"

    # NOTES AND MISC PROJECT DOCUMENTATION
    mkdir "${ppath}/notes"

    # PUBLICATION DRAFTING FILES
    mkdir "${ppath}/pubs"
    mkdir "${ppath}/pubs/drafts/${pname}_v1"
    mkdir "${ppath}/pubs/final/${pname}_final"

    # PROJECT MEETING REPORTS AND PRESENTATIONS
    mkdir "${ppath}/reports"

    # MAKE RESOURCES FOLDERS
    mkdir "${ppath}/resources"
    mkdir "${ppath}/resources/background_lit"
    mkdir "${ppath}/resources/tutorials"

    # ANALYSIS, PARSING, AND OTHER AUTOMATION SCRIPTS
    mkdir "${ppath}/scripts"
    mkdir "${ppath}/scripts/parser"
    mkdir "${ppath}/scripts/analysis"
    mkdir "${ppath}/scripts/misc"

    # MISCELLANEOUS TOOLS
    mkdir "${ppath}/tools"

    # GENERATE FILE HEADERS FOR DOCUMENTATION FILES
    docfiles_gen $ptype $pname
    # GENERATE THE PUBLICATIONS DIRECTORY AND POPULATE IT
    pubdir_gen

    echo "PROJECT ${pname} HAS BEEN SUCCESSFULLY CREATED IN ${ppath} !"

elif [ "$ptype" = "development" ]; then
    # CREATE TREE ROOT DIRS
    echo "CREATING THE ROOT DIRECTORY FOR ${pname}"
    mkdir "${db}/${ptype}/${pname}"

    # MAKE PROJECT DIRECTORIES AND PACKAGE SUBDIRECTORIES
    echo "BUILDING PROJECT AND PACKAGE DIRECTORY STRUCTURES..."
    mkdir "${ppath}/admin"
    mkdir "${ppath}/doc"

    mkdir "${ppath}/pubs"
    mkdir "${ppath}/pubs/drafts/${pname}_v1"
    mkdir "${ppath}/pubs/final/${pname}_final"

    mkdir "${ppath}/reports"

    mkdir "${ppath}/resources"
    mkdir "${ppath}/resources/benchmarks"
    mkdir "${ppath}/resources/background_lit"
    mkdir "${ppath}/resources/tutorials"

    mkdir "${ppath}/scripts"
    mkdir "${ppath}/scripts/parser"
    mkdir "${ppath}/scripts/analysis"
    mkdir "${ppath}/scripts/misc"

    mkdir "${ppath}/tools"

    # MAKE SUBDIRECTORY FOR DEVELOPMENT
    echo "BUILDING SOFTWARE DEVELOPMENT SUBDIRECTORIES..."
    mkdir "${ppath}/${pname}"
    mkdir "${ppath}/${pname}/bin"
    mkdir "${ppath}/${pname}/cmake"
    mkdir "${ppath}/${pname}/external"
    mkdir "${ppath}/${pname}/include"
    mkdir "${ppath}/${pname}/src"
    mkdir "${ppath}/${pname}/tests"

    # MAKE READMES AND COLLABORATOR LIST
    docfiles_gen $ptype $pname
    pubdir_gen

    echo "PROJECT ${pname} HAS BEEN SUCCESSFULLY CREATED IN ${ppath} !"
else
    echo "PLEASE ENTER A VALID PROJECT TYPE, EITHER applications OR development!"
fi

