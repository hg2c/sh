#!/usr/bin/env bash

checklist=$(cat <<-END
[ ] Compile Spark
[ ] Compile Carbon
[ ] Package Spark
[ ] Release Spark
END
)

checklist_complete() {
    local item="$1"
    checklist=$(echo "$checklist" | sed "s/\[ \] $item/\[X\] $item/")
}

checklist_complete "Compile Spark"
checklist_complete "Package Spark"

echo "$checklist"
