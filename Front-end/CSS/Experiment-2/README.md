
Assets compilation Notes : CSS
==============================

*Structure*
```
project-or-theme-dir/
    └── css
        ├── _fragment.css       <- inlined fragment, see main.css
        ├── ...                 <- inlined fragments, see main.css
        │   └── ...
        ├── node_modules        <- gitignored dependencies
        │   └── ...
        ├── main.css            <- source
        └── build.css           <- compiled result
```

*Dependencies*
```
npm install -g suitcss-preprocessor
```

```
#       Compilation commands
cd /path/to/project-or-theme-dir/css

#       Compressed
suitcss --compress main.css build.css

#       Normal
suitcss main.css build.css
```


