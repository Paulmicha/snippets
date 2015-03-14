
Assets compilation Notes : CSS
==============================

*Structure*
```
project-root-dir/
└── theme/
    └── _assets/
        └── css
            ├── _fragment.css       <- inlined fragment, see main.css
            ├── ...                 <- inlined fragments, see main.css
            │   └── ...
            ├── components          <- gitignored dependencies
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
cd /path/to/project-root-dir

#       Compressed
suitcss --compress theme/_assets/css/main.css theme/_assets/css/build.css

#       Normal
suitcss theme/_assets/css/main.css theme/_assets/css/build.css

#       Watch - Warning : does not work for local includes
#       @see 
suitcss --watch theme/_assets/css/main.css theme/_assets/css/build.css
```


