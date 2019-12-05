## Dep

`dep` is a dependency management tool for Bash. 



## Usage

1. create file: .dep.lock

```
sh=https://github.com/hg2c/sh.git -b master
```

2. ./dep.sh install
3. Add dep.sh in your script 

```
vim main.sh

#!/usr/bin/env bash
set -euo pipefail
source ./dep.sh

... your scripts ...
```

